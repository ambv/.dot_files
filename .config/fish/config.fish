# Shell variables live in ~/.config/fish/fish_variables.
# List with `set -U`.

set -x PATH $HOME/.dot_files/bin $HOME/.poetry/bin $HOME/.cargo/bin $HOME/.local/bin /Library/TeX/texbin /opt/homebrew/bin $PATH
set -x PATH "/Users/ambv/Library/Application Support/edgedb/bin" "$PATH" # EdgeDB
set -x PATH $PATH /Users/ambv/opt/anaconda3/condabin
# set -x LDFLAGS -L/usr/local/opt/python@3.8/lib
# set -x PKG_CONFIG_PATH /usr/local/opt/python@3.8/lib/pkgconfig
set -x DOCKER_DEFAULT_PLATFORM linux/amd64

starship init fish | source

#
# NOTE: Don't put *private* tokens here, use ~/.fish_local.
#

# SAFE COMMANDS WHEN INTERACTIVE
if test -t 0
    alias ci="echo \"You probably meant vi. Or are you still using RCS?\"; false"
    alias cp="/bin/cp -ir"
    alias dc="echo \"You don't really use 'dc', do you?\"; false"
    alias dk="docker"
    alias dkl="docker container ls -a && docker image ls -a"
    alias dke="docker exec -it"
    # dkclr is a function
    alias grep="/usr/bin/grep --color=auto"
    alias oni="/Applications/Onivim2.app/Contents/MacOS/Oni2"
    alias ll="/bin/ls -lah"
    alias lt="/opt/homebrew/bin/tree -AphL"
    alias mv="/bin/mv -i"
    alias rm="/bin/rm -i"
    alias tree="/opt/homebrew/bin/tree -A"
    alias vi="vim"
    function hg
        set cmd (which hg)
        PYTHONWARNINGS=i $cmd $argv
    end
    function pip
        set cmd (which pip)
        PYTHONWARNINGS=i $cmd $argv
    end
    function pipenv
        set cmd (which pipenv)
        PYTHONWARNINGS=i $cmd $argv
    end
    function poetry
        set cmd (which poetry)
        PYTHONWARNINGS=i $cmd $argv
    end
    function dkr
        set name (echo $argv[1] | cut -f2 -d/)
        docker run -it --rm --name $name $argv[2..]
    end
    function sitediff
        git diff -U0 --color | grep -av "<lastmod>" | grep -av "<updated>" | grep -av "?v=202" | less -r
    end
end

function fish_greeting
    fortune
end

set -x WINTITLE (echo %self)
function fish_title
    echo $WINTITLE ' '
    pwd
end

function wintitle
    echo -ne "\033]0;$argv\007"
    set -x WINTITLE $argv
end

function dkclr
    docker image prune -a --filter "until=24h"
    docker container prune --filter "until=24h"
    docker volume prune --filter "label!=keep"
    docker network prune --filter "until=24h"
end

set -x PYENV_ROOT $HOME/.pyenv
fish_add_path /usr/local/opt/autoconf@2.69/bin
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

source ~/.fish_local
