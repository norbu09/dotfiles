# $FreeBSD: src/etc/root/dot.profile,v 1.20 1999/08/27 23:24:09 peter Exp $
#
PATH=/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${HOME}/bin:$HOME/.rvm/bin
export PATH
TERM=${TERM:-cons25}
export TERM
PAGER=less
export PAGER
MORE=-nce
export MORE
BLOCKSIZE=M
export BLOCKSIZE

#ENV=$HOME/.bashrc
#export ENV

EDITOR=vim
export EDITOR

LSCOLORS='bxfxdxcxBxahahBxBxbxbx'
export LSCOLORS

alias l='ls -loBaFT'
alias ls='ls -Ga'
alias rm='rm -i'
alias mtr='mtr --curses'

HISTIGNORE='&:l: *'; export HISTIGNORE

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

if [ -f /opt/boxen/env.sh ]; then
    source /opt/boxen/env.sh
fi

if [ -d "/Library/Java/JavaVirtualMachines/1.6.0_45-b06-451.jdk" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/1.6.0_45-b06-451.jdk/Contents/Home/"
fi

if [ -d /opt/boxen/homebrew/opt/android-sdk ]; then
    export ANDROID_HOME=/opt/boxen/homebrew/opt/android-sdk
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
