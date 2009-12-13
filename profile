#
# my exports
#

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PS1="\\u@\\H:\\w $ "
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:"
export PATH="/opt/automation:/opt/local/sbin:/opt/local/bin:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:$PATH"
export EDITOR=/usr/bin/vi
export VIMFILES=~/.vim/
export HISTCONTROL=erasedups
export HISTSIZE=10000
export PYTHONSTARTUP=~/.pythonstartup
export QTDIR=/opt/local/lib/qt3


# 
# my Bash modifications
#
shopt -s histappend cdspell
bind Space:magic-space
bind -m vi-insert "\C-n":menu-complete
set -o vi


#
# my aliases
#

# LANDSRAAD
alias landsraad="ssh -Yp26 ambv@92.43.117.100"
alias caladan="ssh -Yp26 ambv@92.43.117.101"
alias arrakis="ssh -Yp26 ambv@92.43.117.102"
alias giediprime="ssh -Yp26 ambv@92.43.117.103"

# STUDENT-TV
KNEST="fwknop -D nest.student-tv.pl:61841 -A tcp/26 -s -u nest"
KHIVE="fwknop -D hive.student-tv.pl:61841 -A tcp/26 -s -u hive"
alias knest=$KNEST
alias khive=$KHIVE
alias hive="ssh -Yp26 hive@hive.student-tv.pl"
alias nest="ssh -Yp26 nest@91.102.115.194"
alias anest="ssh -Yp26 ambv@91.102.115.194"
alias poltv="ssh -p26 tuvok@81.210.76.98"

# SOFTAX
alias mars="ssh -Y llanga@mars.softax.local"
alias neptun="ssh -Y llanga@neptun.softax.local"
alias bolt="ssh -Y ambv@bolt.stxnext.pl"
alias nutpen="ssh -Y ambv@nutpen.stxnext.local"

# SAFE COMMANDS
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias die='logout'
alias ll='ls -la'
alias lt='tree -AphL '
alias tree='tree -A '

# shortcuts
alias ip='ipython2.6'
alias pro='cd ~/Documents/Projekty;lt 1'
alias propy='cd ~/Documents/Projekty/Python;lt 1'
alias prostx='cd ~/Documents/Projekty/STX-Next;lt 1'
alias proeuro='cd ~/Documents/Projekty/STX-Next/EuroPython;lt 1'

alias sync-director='rsync -zcIre"ssh -p26" --progress /Users/ambv/Documents/Eclipse-3.4-workspace/impulse-director2/webstart/release/ hive@hive.student-tv.pl:/var/www/html/impulse-director/'

alias sync-kontrol='rsync -zcIre"ssh -p26" --progress /Users/ambv/Documents/Eclipse-3.4-workspace/impulse-kontrol/release/ hive@hive.student-tv.pl:/var/www/html/impulse-kontrol/'

alias sync-hive='scp -P26 /Users/ambv/Documents/Eclipse-3.4-workspace/impulse-hive/release/impulse-hive.war hive@hive.student-tv.pl:~/'

alias jloc='let "a = 0"; for num in `find . -iname "*.java" | xargs -I {} wc -l {} | cut -d. -f1 | tr -d " "`; do let "a = a + num"; done; echo $a;'
alias loc='let "a = 0"; for num in `find . -iname "*.py" | xargs -I {} wc -l {} | cut -d. -f1 | tr -d " "`; do let "a = a + num"; done; echo $a;'

alias pgstart="sudo su postgres -c '/opt/local/lib/postgresql83/bin/pg_ctl -D /opt/local/var/db/postgresql83/defaultdb -l /opt/local/var/log/postgresql83/postgres.log start'"
alias pgstop="sudo su postgres -c '/opt/local/lib/postgresql83/bin/pg_ctl -D /opt/local/var/db/postgresql83/defaultdb stop -m fast'"
alias pgstatus="sudo su postgres -c '/opt/local/lib/postgresql83/bin/pg_ctl status -D /opt/local/var/db/postgresql83/defaultdb'"
alias ptar='tar --use-compress-program /opt/local/bin/pbzip2 '
