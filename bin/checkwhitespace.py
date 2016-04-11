"""
Mercurial hooks to check changegroups and individual changesets for
whitespace issues.

To use the changeset hook in a local repository, include something like the
following in your hgrc file, and make sure that this file (check_whitespace.py)
and reindent.py are in the same directory.

[hooks]
pretxncommit.whitespace = python:/home/hg/repos/hooks/checkwhitespace.py:check_whitespace_single
"""

# Mercurial hooks are not run with the hook's directory in sys.path
import sys, os
sys.path.append(os.path.dirname(__file__))

from StringIO import StringIO
from reindent import Reindenter
from mercurial import revset
from mercurial import node
from mercurial import cmdutil

def check_file(ui, repo, path, rev):
    """Check a particular (file, revision) pair for whitespace issues.

    Return True if whitespace problems exist, else False.

    """
    ui.debug("checking file %s at revision %s for whitespace issues\n" %
             (path, node.short(repo[rev].node())))

    # Check Python files using reindent.py
    if path.endswith('.py'):
        content = StringIO(repo[rev][path].data())
        reindenter = Reindenter(content)
        if reindenter.run():
            ui.warn(" - file %s is not whitespace-normalized in %s\n"
                    % (path, str(repo[rev])))
            return True

    # Check ReST files for tabs and trailing whitespace
    elif path.endswith('.rst'):
        lines = StringIO(repo[rev][path].data()).readlines()
        for line in lines:
            if '\t' in line:
                ui.warn(" - file %s contains tabs in %s\n"
                        % (path, str(repo[rev])))
                return True

            elif line.rstrip('\r\n') != line.rstrip('\r\n '):
                ui.warn(" - file %s has trailing whitespace in %s\n"
                        % (path, str(repo[rev])))
                return True

    return False

def compare_revisions(repo, ui, rev1, rev2):
    """Given a known good revision 'rev1' and a revision 'rev2',
    check all files that have changed between 'rev1' and 'rev2'
    for whitespace issues.

    Returns a count of bad files.

    """
    bad_files = 0
    status = repo.status(rev1, rev2)
    modified, added = status[0], status[1]
    for path in modified + added:
        if check_file(ui, repo, path, rev2):
            bad_files += 1
    return bad_files

def check_whitespace(ui, repo, node, **kwargs):
    """Check whitespace for an incoming changegroup.

    Suitable for use as a pretxnchangegroup hook.

    """
    bad_files = 0

    # revision number of first incoming changeset of the changegroup
    start = repo[node].rev()
    files = set()
    heads = set([start])
    # Find all heads in changegroup
    for rev in xrange(start, len(repo)):
        for p in repo.changelog.parentrevs(rev):
            heads.discard(p)
        heads.add(rev)
        files.update(repo[rev].files())
    # Process each head and check modified files in it
    for head in heads:
        ctx = repo[head]
        for f in files:
            if f not in ctx:
                continue
            if check_file(ui, repo, f, head):
                bad_files += 1

    if bad_files:
        msg = ("* Run Tools/scripts/reindent.py on .py files or "
               "Tools/scripts/reindent-rst.py on .rst files listed above\n"
               "* and commit that change before pushing to this repo.\n")
        ui.warn(msg)
        # return value of 'True' indicates failure
        return True
    return False

def check_whitespace_single(ui, repo, **kwargs):
    """Check whitespace for a single changeset.

    Suitable for use as a pretxncommit hook.

    """
    head = repo[kwargs['node']].rev()
    # Enough to compare with just one parent:  both parents should
    # be whitespace-clean already.
    source = repo[kwargs['parent1']].rev()

    if compare_revisions(repo, ui, source, head):
        msg = ("* Run Tools/scripts/reindent.py on .py files or "
               "Tools/scripts/reindent-rst.py on .rst files listed above\n"
               "* and rerun your tests to fix this before checking in.\n")
        ui.warn(msg)
        # return value of 'True' indicates failure
        return True
    return False
