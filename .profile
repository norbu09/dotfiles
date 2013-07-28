# $FreeBSD: src/etc/root/dot.profile,v 1.20 1999/08/27 23:24:09 peter Exp $
#
PATH=/sbin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/X11R6/bin:${HOME}/bin:/usr/local/pgsql/bin:/opt/local/bin:/opt/local/sbin:/usr/local/share/npm/bin:/usr/texbin:~/.cabal/bin:/usr/local/share/python:/Applications/VMware\ Fusion.app/Contents/Library
export PATH
TERM=${TERM:-cons25}
export TERM
PAGER=less
export PAGER
MORE=-nce
export MORE
BLOCKSIZE=M
export BLOCKSIZE

ENV=$HOME/.bashrc
export ENV

EDITOR=vim
export EDITOR

LSCOLORS='bxfxdxcxBxahahBxBxbxbx'
export LSCOLORS

alias l='ls -loBaFT'
alias ls='ls -Ga'
alias rm='rm -i'
alias mtr='mtr --curses'

HISTIGNORE='&:l: *'; export HISTIGNORE

if [ -d "/Library/Java/JavaVirtualMachines/1.6.0_32-b05-420.jdk" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/1.6.0_32-b05-420.jdk/Contents/Home/"
fi
if [ -d "$HOME/.ec2" ]; then
    export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
    export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
    export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.3-57419/jars"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

if [ -f `which brew` ]; then
    if [ -f `brew --prefix git`/etc/bash_completion.d/git-completion.bash ]; then
        source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
    fi

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi
fi

if [ -d "$HOME/perl5/perlbrew" ]; then
    source ~/perl5/perlbrew/etc/bashrc
fi

GIT_PS1=`__git_ps1 2>/dev/null`
if [ $? -eq 0 ]; then
    GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWDIRTYSTATE
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\][$?] \[\033[01;34m\]\W\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\] ⇾ '
else
    #PS1='\[\e[7m\]\u@\h:\W(${SHLVL}/\!-$?)\$\[\e[m\] '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\][$?] \[\033[01;34m\]\W\[\033[01;33m\]\[\033[00m\] ⇾ '
fi
export PS1
tset
