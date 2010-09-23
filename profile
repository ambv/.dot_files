#
# Bash-specific profile. For Zsh specific look at zshrc,
# for common variables look at profile_common.
#

# 
# my Bash modifications
#
shopt -s histappend cdspell
bind Space:magic-space
bind -m vi-insert "\C-n":menu-complete
bind -m vi-insert "\C-p":dynamic-complete-history
bind -m vi-insert "\C-a":vi-append-eol
export HISTCONTROL=erasedups
export HISTSIZE=10000
export PS1="\\u@\\H:\\w $ "
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
