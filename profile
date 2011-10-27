#
# Bash-specific profile. For Zsh specific look at zshrc,
# for common variables look at profile_common.
#

#
# the prompt
#
if [ -e ~/.pscolors ]; then
  source ~/.pscolors
fi
export PS1="$PS_USERCOLOR\\u$PS_ATCOLOR@$PS_HOSTCOLOR\\H$PS_COLONCOLOR:$PS_PATHCOLOR\\w$PS_PROMPTCOLOR $ $PS_NOCOLOR"

# 
# my Bash modifications
#
shopt -s histappend cdspell
case "$TERM" in
xterm*|rxvt*)
  bind Space:magic-space
  bind -m vi-insert "\C-n":menu-complete
  bind -m vi-insert "\C-p":dynamic-complete-history
  bind -m vi-insert "\C-a":vi-append-eol
esac
export HISTCONTROL=erasedups
export HISTSIZE=10000
set -o vi

source ~/.profile_common

#
# load Bash completion if found
#
if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion 
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
