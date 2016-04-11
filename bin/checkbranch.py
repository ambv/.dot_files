"""
Mercurial hook to check that individual changesets don't happen on a
forbidden branch.

To use the changeset hook in a local repository, include something like the
following in its hgrc file.

[hooks]
pretxnchangegroup.checkbranch = python:/home/hg/repos/hooks/checkbranch.py:hook

[checkbranch]
allow-branches = default, 3.2, 3.1, 2.7, 2.6, 2.5
"""

from mercurial.node import bin
from mercurial import util


def hook(ui, repo, node, **kwargs):
    branches = ui.configlist('checkbranch', 'allow-branches')
    if not branches:
        print 'checkbranch: No branches are configured'
        return False

    n = bin(node)
    start = repo.changelog.rev(n)
    end = len(repo.changelog)
    failed = False
    for rev in xrange(start, end):
        n = repo.changelog.node(rev)
        ctx = repo[n]
        branch = ctx.branch()
        if branch not in branches:
            ui.warn(' - changeset %s on disallowed branch %r!\n'
                  % (ctx, branch))
            failed = True
    if failed:
        ui.warn('* Please strip the offending changeset(s)\n'
                '* and re-do them, if needed, on another branch!\n')
        return True

