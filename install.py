#!/usr/bin/env python
import sys
import os
import subprocess
import optparse

try:
    from hashlib import md5
except ImportError:
    import md5 as md5lib
    md5 = md5.new

if sys.version_info[:2] < (2, 4):
    # subprocess was introduced in Python 2.4
    print "Sorry, Python 2.4 required."
    sys.exit(1)

user_home_dir = os.path.expanduser("~")
dot_files_dir = os.path.dirname(__file__)
parser = optparse.OptionParser()
parser.add_option("-U", "--uninstall", 
                  action="store_true",
                  dest="uninstall", 
                  default=False,
                  help="uninstall the distribution from the home directory")
parser.add_option("-v", "--verbose", 
                  action="store_true",
                  dest="verbose", 
                  default=False,
                  help="more detailed output")
parser.add_option("-d", "--dir",
                  dest="dir",
                  default=user_home_dir,
                  help="specify a directory to install to/uninstall from",
                  metavar="DIR")

(options, args) = parser.parse_args()


class Command(object):
    warnings = []
    verbose = []


class Install(Command):
    cmd_message = "Installing dot_files to"

    def no_target(self, source, target):
        status = subprocess.call("ln -s %s %s" % (os.path.realpath(source), os.path.realpath(target)), shell=True)
        if status == 0:
            self.verbose.append("linked %s to %s" % (source, target))
        else:
            self.warnings.append("creating link %s to %s failed with status code %d" % (source, target, status))

    def target_link_same(self, source, target, real_source, real_target):
        self.verbose.append("link from %s to %s already exists" % (source, target))       
            
    def target_link_different(self, source, target, real_source, real_target):
        self.warnings.append("link at %s exists but points to %s" % (target, real_target))

    def target_differen(self, source, target):
        self.warnings.append("target %s exists but is not a link" % (target, ))


class Uninstall(Command):
    cmd_message = "Uninstalling dot_files from"
    
    def no_target(self, source, target):
        self.verbose.append("target %s was missing" % (target,))

    def target_link_same(self, source, target, real_source, real_target):
        os.unlink(target)
        self.verbose.append("link from %s to %s removed" % (source, target))       
            
    def target_link_different(self, source, target, real_source, real_target):
        self.warnings.append("skipped target at %s: link points to %s" % (target, real_target))

    def target_differen(self, source, target):
        self.warnings.append("skipped target at %s: not a link" % (target, ))


if not options.uninstall:
    handler = Install()
else:
    handler = Uninstall()

print handler.cmd_message, "%s..." % options.dir,

for entry in os.listdir(dot_files_dir):
    if entry.startswith('.') or entry.endswith('~') or \
       entry in ('install.py', ):
        continue
    
    source = os.path.join(dot_files_dir, entry)
    target = os.path.join(options.dir, ".%s" % entry)

    if not os.path.exists(target):
        handler.no_target(source, target)
    elif os.path.islink(target):
        real_source = os.path.realpath(source)
        real_target = os.path.realpath(target)
        if real_source == real_target:
            handler.target_link_same(source, target, real_source, real_target)
        else:
            handler.target_link_different(source, target, real_source, real_target)
    else:
        handler.target_different(source, target)

print "done."

for w in handler.warnings:
    print "Warning:", w

if options.verbose:
    for v in handler.verbose:
        print v
