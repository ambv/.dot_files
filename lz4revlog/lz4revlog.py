# lz4revlog.py - lz4 delta compression for mercurial
#
# Copyright 2012 Facebook
#
# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.

'''store revlog deltas using lz4 compression

This extension uses the lz4 compression algorithm to store deltas,
rather than Mercurial's default of zlib compression.  lz4 offers much
faster decompression than zlib, at a cost of about 30% more disk
space.  The improvement in decompression speed leads to speedups in
many common operations, such as update and history traversal.

To use lz4 compression, a repository can be created from scratch or
converted from an existing repository, for example using :hg:`clone
--pull`.

The behaviour of Mercurial in an existing zlib-compressed repository
will not be affected by this extension.

To avoid use of lz4 when cloning or creating a new repository, use
:hg:`--config format.uselz4=no`.

Interop with other Mercurial repositories is generally not affected by
this extension.
'''

from mercurial import error, extensions, localrepo, revlog, util
from mercurial.i18n import _
import lz4

testedwith = '3.9.1'

def replaceclass(container, classname):
    '''Replace a class with another in a module, and interpose it into
    the hierarchies of all loaded subclasses. This function is
    intended for use as a decorator.

      import mymodule
      @replaceclass(mymodule, 'myclass')
      class mysubclass(mymodule.myclass):
          def foo(self):
              f = super(mysubclass, self).foo()
              return f + ' bar'

    Existing instances of the class being replaced will not have their
    __class__ modified, so call this function before creating any
    objects of the target type.
    '''
    def wrap(cls):
        oldcls = getattr(container, classname)
        oldbases = (oldcls,)
        newbases = (cls,)
        for subcls in oldcls.__subclasses__():
            if subcls is not cls:
                assert subcls.__bases__ == oldbases
                subcls.__bases__ = newbases
        setattr(container, classname, cls)
        return cls
    return wrap

try:
    _compress = lz4.compressHC
    _decompress = lz4.decompress
    # don't crash horribly if invoked on an incompatible hg
    usable = localrepo.localrepository.openerreqs
except (AttributeError, ImportError):
    def lz4missing(eek):
        raise util.Abort(_('the lz4revlog extension requires lz4 support'))
    _compress = _decompress = lz4missing
    usable = False

def decompress(orig, bin):
    if not bin:
        return bin
    t = bin[0]
    if t == '\0':
        return bin
    if t == '4':
        return _decompress(bin[1:])
    return orig(bin)

def requirements(orig, repo):
    reqs = orig(repo)
    if repo.ui.configbool('format', 'uselz4', True):
        reqs.add('lz4revlog')
    return reqs

if usable:
    if util.safehasattr(localrepo, 'newreporequirements'):
        extensions.wrapfunction(localrepo, 'newreporequirements', requirements)
    else:
        @replaceclass(localrepo, 'localrepository')
        class lz4repo(localrepo.localrepository):
            def _baserequirements(self, create):
                reqs = super(lz4repo, self)._baserequirements(create)
                if create and self.ui.configbool('format', 'uselz4', True):
                    reqs.append('lz4revlog')
                return reqs

    @replaceclass(revlog, 'revlog')
    class lz4revlog(revlog.revlog):
        def __init__(self, opener, indexfile, **kwds):
            super(lz4revlog, self).__init__(opener, indexfile, **kwds)
            opts = getattr(opener, 'options', None)
            self._lz4 = opts and 'lz4revlog' in opts

        def compress(self, text):
            if util.safehasattr(self, '_lz4') and self._lz4:
                if not text:
                    return ('', text)
                l = len(text)
                c = _compress(text)
                if len(text) <= len(c):
                    if text[0] == '\0':
                        return ('', text)
                    return ('u', text)
                return ('', '4' + c)
            return super(lz4revlog, self).compress(text)

    extensions.wrapfunction(revlog, 'decompress', decompress)
    cls = localrepo.localrepository
    for reqs in 'supportedformats openerreqs'.split():
        getattr(cls, reqs).add('lz4revlog')
    if util.safehasattr(cls, '_basesupported'):
        # hg >= 2.8. Since we're good at falling back to the usual revlog, we
        # aren't going to bother with enabling ourselves per-repository.
        cls._basesupported.add('lz4revlog')
    else:
        # hg <= 2.7
        cls.supported.add('lz4revlog')
