# rdiff.py: diff against remote repositories
#
# Copyright 2007-10 Brendan Cully <brendan@kublai.com>
#
# This software may be used and distributed according to the terms
# of the GNU General Public License, incorporated herein by reference.

'''diff against remote repositories

When this extension is loaded, if the first argument to the diff command
is a remote repository URL, the diff will be performed against that
URL. If revision arguments are given, the first revision is the revision
in the source repository, and the second revision is looked up in the
destination.
'''

from mercurial.i18n import _
from mercurial import changegroup, cmdutil, scmutil, commands, hg, patch
from mercurial import util
from mercurial import localrepo

import os

#!#*@#$()* continual unfriendly API changes!
def findincomingfn(repo):
    try:
        from mercurial import discovery
        discovery.findcommonincoming
        def fi(*args, **opts):
            ret = discovery.findcommonincoming(repo, *args, **opts)
            #print ret
            if type(ret[1]) != bool:
                return ret[1]
            if not ret[1]:
                return []
            return ret[2]
        return fi
    except ImportError:
        return repo.findincoming

def getpeer(ui, opts, source):
    try:
        peer = hg.peer(ui, opts, source)
        # ewwww, life without an API is messy
        if isinstance(peer, localrepo.localpeer):
            peer = localrepo.locallegacypeer(peer._repo)
        return peer
    except AttributeError:
        return hg.repository(ui, source)

def capable(repo, name):
    try:
        return repo.capable(name)
    except AttributeError:
        # pre-2.3
        return name in repo.capabilities

def rdiff(ui, repo, url, lrev=None, rrev=None, *pats, **opts):
    def rui():
        try:
            return hg.remoteui(repo, opts)
        except AttributeError:
            # pre 1.6
            return cmdutil.remoteui(repo, opts)

    try:
        other = getpeer(rui(), {}, url)
    except AttributeError:
        # pre-1.3
        other = hg.repository(ui, url)
        cmdutil.setremoteconfig(ui, opts)
    ui.status(_('comparing with %s\n') % url)

    if rrev:
        if capable(other, 'lookup'):
            rrev = other.lookup(rrev)
        else:
            error = _("Other repository doesn't support revision lookup, so a rev cannot be specified.")
            raise util.Abort(error)

    incoming = findincomingfn(repo)(other, heads=rrev and [rrev] or [])
    if not incoming:
        # remote is a subset of local
        if not rrev:
            if capable(other, 'lookup'):
                rrev = other.lookup('tip')
            else:
                raise util.Abort(_('cannot determine remote tip'))
        other = repo

    bundle = None
    try:
        if incoming:
            # create a bundle (uncompressed if other repo is not local)
            if not rrev:
                cg = other.changegroup(incoming, "incoming")
            else:
                if not capable(other, 'changegroupsubset'):
                    raise util.Abort(_("Partial incoming cannot be done because other repository doesn't support changegroupsubset."))
                cg = other.changegroupsubset(incoming, rrev and [rrev] or [],
                                             'incoming')
            bundle = changegroup.writebundle(cg, '', 'HG10UN')
            other = hg.repository(ui, bundle)

        if lrev:
            lrev = repo.changectx(lrev).node()

        rrev = other.changectx(rrev or 'tip').node()
        if opts['reverse']:
            lrev, rrev = rrev, lrev
        if not lrev:
            # bundle dirstate removed prior to hg 1.1
            lrev = repo.dirstate.parents()[0]

        try:
            try:
                # scmutil.match expects a context not a repo
                m = scmutil.match(repo[None], pats, opts)
            except (ImportError, AttributeError):
                m = cmdutil.match(repo, pats, opts)
            chunks = patch.diff(other, lrev, rrev, match=m,
                                opts=patch.diffopts(ui, opts))
            for chunk in chunks:
                ui.write(chunk)
        except AttributeError:
            # 1.0 compatibility
            fns, matchfn, anypats = cmdutil.matchpats(repo, pats, opts)
            patch.diff(other, lrev, rrev, fns, match=matchfn,
                       opts=patch.diffopts(ui, opts))
            
    finally:
        if hasattr(other, 'close'):
            other.close()
        if bundle:
            os.unlink(bundle)

def diff(orig, ui, repo, *pats, **opts):
    """
    [rdiff]
    If the first argument to the diff command is a remote repository URL,
    the diff will be performed against that URL. If revision arguments are
    given, the first revision is the revision in the source repository,
    and the second revision is looked up in the destination.
    
    The --reverse flag cause the direction of the diff to be reversed.
    """
    url = None
    rrev = None
    if pats:
        path = ui.expandpath(pats[0])
        if hasattr(hg, 'parseurl'):
            args = hg.parseurl(ui.expandpath(pats[0]), [])
            # parseurl changed from returning two args to three
            path, rrev = args[0], args[-1]
            # 1.6 (3d6915f5a2bb): parseurl returns (url, (branch, branches))
            if type(rrev) == tuple:
                rrev = rrev[0]
        if '://' in path or os.path.isdir(os.path.join(path, '.hg')):
            url = path
            pats = pats[1:]

    if url:
        lrev = None
        if len(opts['rev']) > 2 or rrev and len(opts['rev']) > 1:
            raise util.Abort(_('too many revisions'))
        if opts['rev']:
            lrev = opts['rev'][0]
        if len(opts['rev']) > 1:
            rrev = opts['rev'][1]
        return rdiff(ui, repo, url, lrev, rrev, *pats, **opts)
    else:
        return orig(ui, repo, *pats, **opts)

def wrapcommand(table, command, wrapper):
    aliases, entry = cmdutil.findcmd(command, table)
    for alias, e in table.iteritems():
        if e is entry:
            key = alias
            break

    origfn = entry[0]
    def wrap(*args, **kwargs):
        return wrapper(origfn, *args, **kwargs)

    wrap.__doc__ = getattr(origfn, '__doc__')
    wrap.__module__ = getattr(origfn, '__module__')

    newentry = list(entry)
    newentry[0] = wrap
    table[key] = tuple(newentry)
    return newentry

def uisetup(ui):
    rdiffopts = [('', 'reverse', None, _('reverse patch direction'))] + \
        commands.remoteopts

    odoc = diff.__doc__
    entry = wrapcommand(commands.table, 'diff', diff)
    entry[0].__doc__ += odoc
    entry[1].extend(rdiffopts)
