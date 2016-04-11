"""
Mercurial hook to check that a new changegroup (a group of pushed changesets)
doesn't create new heads on any branch.

To use the changeset hook in a local repository, include something like the
following in its hgrc file.

[hooks]
pretxnchangegroup.checkheads = python:/home/hg/repos/hooks/checkheads.py:hook
"""

from mercurial.node import bin, nullrev
from mercurial import util


def hook(ui, repo, node, **kwargs):
    changelog = repo.changelog
    # rev number of the first new cset
    start = changelog.rev(bin(node))
    end = len(changelog)
    # The rev numbers in this changegroup
    newcsets = range(start, end)
    # The rev numbers of the changegroup parents (not in the changegroup)
    parents = set()

    for n in newcsets:
        for p in changelog.parentrevs(n):
            if p == nullrev:
                continue
            if p < start:
                parents.add(p)

    for p in parents:
        branch = repo[p].branch()
        # The heads descending from that parent, on the same branch
        pheads = set([p])
        reachable = set([p])
        for x in xrange(p + 1, end):
            if repo[x].branch() != branch:
                continue
            for pp in changelog.parentrevs(x):
                if pp in reachable:
                    reachable.add(x)
                    pheads.discard(pp)
                    pheads.add(x)
        # More than one head? Suggest merging
        if len(pheads) > 1:
            ui.warn('* You are trying to create new head(s) on %r!\n' % branch)
            ui.warn('* Please run "hg pull" and then merge at least two of:\n')
            ui.warn('* ' + ', '.join(str(repo[h]) for h in pheads) + '\n')
            return True
