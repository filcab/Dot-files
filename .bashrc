export HOME=~

# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Combine multiline commands into one in historty
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"

# Set a history file size
export HISTFILESIZE=100000
export HISTSIZE=1000
shopt -s histappend

# Colorize 'ls' command output
export CLICOLOR=1

#export SBCL_HOME=/Users/filcab/toolchains/lib/sbcl

# Use emacsclient as an EDITOR. Spawn a new emacs --daemon if it isn't running
export EDITOR="emacsclient -t"
export ALTERNATE_EDITOR=""

# CDPATH ~= PATH for the `cd' command
#export CDPATH=.:~:~/ist:~/dev/stuff

# Path for hunspell dictionaries
export DICPATH=~/.hunspell

###### PATHs ######
# Put /usr/local/bin before /usr/bin
export PATH=/usr/local/bin:$PATH

# MacTeX
export PATH=/usr/texbin:$PATH

# Coq theorem prover
export PATH=$PATH:~/coq/bin

# PostgreSQL
export PATH=$PATH:/Library/PostgreSQL/8.4/bin
export MANPATH=$MANPATH:/Library/PostgreSQL/8.4/share/man
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Library/PostgreSQL/8.4/lib
export CPATH=$CPATH:/Library/PostgreSQL/8.4/include

# Lisps/Scheme
export PATH=$PATH:/Applications/Dev/AllegroCL
export PATH=$PATH:/Users/filcab/dev/stuff/plt/bin

# Graphviz
export PATH=$PATH:/Applications/Dev/Graphviz.app/Contents/MacOS

# Valgrind
export PATH=$PATH:~/valgrind/bin
export CPATH=$CPATH:~/valgrind/include

# LLVM/clang
export PATH=$PATH:~/llvm/bin
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Users/filcab/llvm/lib
export CPATH=$CPATH:~/llvm/include
export MANPATH=$MANPATH:~/llvm/man:~/llvm/share/man

# System LLVM-GCC
export PATH=$PATH:/Developer/usr/bin

# Chrome related stuff
#export PATH=$PATH:~/dev/stuff/google/depot_tools

# MacPorts
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/local/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/local/share/pkgconfig

# We don't want this all the time
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/opt/local/lib

export MANPATH=$MANPATH:/opt/local/share/man
#export QTDIR=/opt/local/lib/qt3

function mostly_ports()
{
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export PKG_CONFIG_PATH=/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH
  export PKG_CONFIG_PATH=/opt/local/share/pkgconfig:$PKG_CONFIG_PATH
  export DYLD_LIBRARY_PATH=/opt/local/lib:$DYLD_LIBRARY_PATH
  export CPATH=/opt/local/include:$CPATH
}

# Fink
#export PATH=$PATH:/sw/bin
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/sw/lib
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/sw/lib/pkgconfig

#function mostly_fink()
#{
#  export PATH=/sw/bin:$PATH
##  export DYLD_LIBRARY_PATH=$LIBJPEG:/sw/lib:$DYLD_LIBRARY_PATH
#  export PKG_CONFIG_PATH=/sw/lib/pkgconfig:$PKG_CONFIG_PATH
#  export LYBRARY_PATH=/sw/lib:/$LIBRARY_PATH
#  export CPATH=/sw/include:$CPATH
#}

# Ada
#export PATH=$PATH:/usr/local/ada-4.3/bin

# /usr/local before /usr
#export PATH=/usr/local/bin:$PATH

# ghc
export PATH=$PATH:~/.cabal/bin:~/ghc/bin
# Let's try xmonad on X-Windows
#export USERWM=`which xmonad`

# mkvtools
export PATH=$PATH:/Applications/Mkvtoolnix.app/Contents/MacOS

# Bash completion
#source ~/.bash.d/cabal-completion

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
#if [ -f /sw/etc/bash_completion ]; then
#    . /sw/etc/bash_completion
#fi

HOME_BASH_DIR=~/.bash.d
if [ -d $HOME_BASH_DIR -a -r $HOME_BASH_DIR -a -x $HOME_BASH_DIR ]; then
  for i in $HOME_BASH_DIR/*; do
    [[ ${i##*/} != @(*~|*.bak|*.swp|\#*\#|*.dpkg*|.rpm*) ]] &&
      [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi

# Color for manpages:
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Make us smile a bit...
if which fortune &>/dev/null;
then
  echo
  fortune -s
  echo
fi

SSHFS_HOSTS=~/.sshfs/hosts
SSHFSMP=~/.sshfs
SSHFSOPTS=reconnect,ping_diskarb,ssh_command=/usr/bin/ssh

# functions
#function intel()
#{
#	source /opt/intel/cc/9.1.037/bin/iccvars.sh
#	source /opt/intel/idb/9.1.037/bin/idbvars.sh
#}

# pman so com progs default
#function pman()
#{
#	SECTION=""
#	if [[ $1 -ne 0 ]]; then
#		SECTION=$1
#		shift
#	fi
#	man -t $SECTION $1 | pstopdf -i -o /tmp/pman.$1.pdf
#	open -a Preview /tmp/pman.$1.pdf
#	sleep 1s
#	rm /tmp/pman.$1.pdf
#}

# pman: man viewed in Preview (no temp files)
function pman()
{
        SECTION=""
        if [[ $1 -ne 0 ]]; then
                SECTION=$1
                shift
        fi
	man -W $SECTION $1 &> /dev/null
	if [[ $? -ne 0 ]]; then		# Pagina nao encontrada
		return 1
	fi
        man -t $SECTION $1 | ps2pdf - - | open -f -a Preview
}

complete -F _man pman

# TODO: sshfs
#function monta {
#    local tudo=`grep $1 $SSHFS_HOSTS | sed -e 's/[^:]*://'`
#    local host=`echo $tudo | sed -e 's/\([^ ]*\)/\1/'`
#    local resto=`echo $tudo | sed -e 's/\([^ ]*\)//'`

#    sshfs $host $SSHFSMP/$1 -ovolname=$1,$SSHFSOPTS
#}

#function umonta {
#    umount $SSHFSMP/$1
#}

# bash completion
#_monta()
#{
#    local cur prev hosts
#    COMPREPLY=()
#    cur="${COMP_WORDS[COMP_CWORD]}"
#    prev="${COMP_WORDS[COMP_CWORD-1]}"
#    hosts=`sed -e 's/\([^:]*\):.*/\1/' ${SSHFS_HOSTS}`

#    COMPREPLY=( $(compgen -W "${hosts}" -- ${cur}) )
#    return 0
#}
#complete -F _monta monta

## Fink stuff
#test -r /sw/bin/init.sh && /sw/bin/init.sh

## Process listing functions
function procs {
  ps ax -o "pid,comm" "$@"
}

## See if pidof already exists
#res=`pidof $0 2>/dev/null`
res=`which pidof`
if [ -z $res ]; then
  function pidof {
    for i in "$@"; do
      procs | awk "{ if (\$2 ~ \"^-?$1\$\" || \$2 ~ \".*/$1\$\") print \$1 }"
    done
  }
fi

## Function to emulate `watch'
res=`which watch`
if [ -z $res ]; then
  function watch () {
    while true; do
      clear
      echo "Watching (2 secs.) command: " "$@"
      "$@"
      sleep 2
    done
  }
fi

## Function for loading F-Script Anywhere into a running app.
function loadfs ()
{
  if [ -z "$1" ]; then
    echo "Usage: loadfs application" >&2
    echo "Example: loadfs TextEdit" >&2
  else
    gdb --batch -x <(echo loadfs $1)
  fi
}

## Function for getting Tracks from the GPS
function gpstracks ()
{
  if [ -z "$1" ]; then
    echo "Usage: gpstracks outfile" >&2
    echo "Example: gpstracks tracks.gpx" >&2
  else
    ~/dev/stuff/gpsbabel/gpsbabel -D5 -t -i garmin -f /dev/cu.PL2303-* \
                                         -o gpx    -F $1
  fi
}


# Set up some aliases (needs cleaning)
#alias ls='ls -G'
alias cd..='cd ..'
#alias ls='gls --color'
alias less='less -r'
alias grep='grep --color=auto'

#alias sshfs='/Applications/MacFUSE/sshfs.app/Contents/Resources/sshfs-static'
#alias ssh='/usr/bin/ssh'
#alias seq='gseq'

alias port='port -u -c'
alias erc="emacs -e '(call-interactively #\'irc)' &"
#alias emacs='emacsclient -t'
alias ldd='otool -L'

alias mysqladmin='sudo mysqladmin5 -u root -p'

myPS1=$PS1
case `hostname` in
  fry)
    aklog

    export PATH=/stuff/src/compiled/bin:$PATH
    export PATH=/stuff/src/compiled/llvm/bin:$PATH
    export PATH=/opt/google/chrome:$PATH

    myPS1='$(ppwd \l)\u@\h:\w> '
  ;;
  *)
    myPS1='[\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;31m\]\h\[\033[01;34m\] \w\[\033[00m\]] \$ '
esac

if [ -z "$EMACSPATH" -a -z "$MYVIMRC" ]; then
  export PS1=$myPS1
fi

