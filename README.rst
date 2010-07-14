ambv's ``.dot_files``
---------------------

This is my distributed configuration I use for my command-line work on all servers I have access to.
It consists of following parts:

* Bash and coreutils configuration which makes the shell look virtually the same regardless whether
  I'm working on *Mac OS X*, *Debian*, *Fedora* or *Solaris*
* the most badass *Python*-oriented *Vim* configuration out there
* a *Python* shell startup config
* *Git* config that makes the command-line a bit more sexy (*Vim* used for diffing, colors everywhere)
* a *Mercurial* config that should be the default (convert, extdiff, fetch, mq extensions on, ask for
  username if I didn't input any, merge and diff with Vim)
* decent global ``.gitignore`` and ``.hgignore`` files with the most common temporary and runtime
  file masks included, plus some *Python* related goodies 
* an installer for the whole package (in *Python*) that enables me to setup my environment by simply
  cloning the repo and running ``./install.py``
* a *MacPorts* bootstrap script that lets me set up a Mac OS X box in just 10 hours or so
  (compiling, compiling, compiling). No user attendance needed though so I can run it overnight.

How can you benefit from this
=============================

At the moment it's mostly take it or leave it, my way or the highway, etc. etc. There is simply no
mechanism to decide which parts you use and which you don't. One day I might provide one but I
wouldn't hold my breath (I'm **always** using the whole shebang).

Of course as the whole thing is virtually public domain, you can take whatever you like and paste it
to your own configuration (e.g. the *Vim* part). So feel free to browse through the package. I'm
also open to suggestions, updates and corrections.
