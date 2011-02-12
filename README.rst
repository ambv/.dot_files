ambv's ``.dot_files``
---------------------

This is my distributed configuration I use for my command-line work on all
servers I have access to.  It consists of following parts:

* ZSh, Bash and coreutils configuration which makes the shell look and behave
  virtually the same regardless whether I'm working on *Mac OS X*, *Debian*,
  *Fedora*, *Solaris* or *Cygwin* (sic!)

* the most badass *Python*-oriented *Vim* configuration out there

* `ack <http://betterthangrep.com/>`_ with a sensible default configuration

* *Git* config that makes the command-line a bit more sexy (*Vim* used for
  diffing, colors everywhere)

* a *Mercurial* config that should be the default (convert, extdiff, fetch, mq
  extensions on, ask for username if I didn't input any, merge and diff with
  Vim)

* decent global ``.gitignore`` and ``.hgignore`` files with the most common
  temporary and runtime file masks included, plus some *Python* related goodies 

* a *Python* shell startup config that enables readline support

* an installer for the whole package (for *Python* 2.4-2.7) that enables me to
  setup my environment anywhere by simply cloning the repo and running
  ``./install.py``

* a *MacPorts* bootstrap script that lets me set up a Mac OS X box in just 10
  hours or so (compiling, compiling, compiling). No user attendance needed
  though so I can run it overnight.

Y U NO USE PATHOGEN / OHMYZSH / HOMEBREW
========================================

A question I get sometimes is why isn't this configuration using the new and hip
package managers like *Pathogen* for Vim scripts, *oh-my-zsh* for ZSh or
*homebrew* for Mac OS X. The answer is that I want to avoid additional package
managers that become dependencies themselves. I didn't actually try using them
in a distributed manner but my intuition tells me it would complicate the setup.
Remember that its greatest feature is currently the ability to use the whole
thing unmodified on Linux, Mac OS X, Solaris and Cygwin (and native Win32 Vim!).

How can you benefit from this
=============================

The whole thing is virtually public domain, you can take whatever you like and
paste it to your own configuration (e.g. the *Vim* part). Feel free to browse
through the package. I'm open to suggestions, updates and corrections.
