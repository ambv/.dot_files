PS1=$PROMPT_TEMPLATE
PROMPT=$PROMPT_TEMPLATE
RPROMPT="%D{%T}"
HISTSIZE=200000
preexec() {
    print -rn -- $terminfo[cuu1]
    let cols=$COLUMNS-9
    while [[ $cols -gt 0 ]]; do
        print -n $terminfo[cuf1]
        let cols=cols-1
    done
    print `date +%H:%M:%S`
}

unalias alias   # restore aliasing in the shell

#
# execute local-specific settings
#
if [ -e ~/.profile_local ]; then
  source ~/.profile_local
fi
