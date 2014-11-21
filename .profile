# $FreeBSD: src/etc/root/dot.profile,v 1.20 1999/08/27 23:24:09 peter Exp $
#
PATH=/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${HOME}/bin:$HOME/.rvm/bin:/usr/local/texlive/2013/bin/x86_64-darwin
export PATH
TERM=${TERM:-cons25}
export TERM
PAGER=vimpager
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

WHOIS=`which whois`
iwhois() {
    resolver=".whois.geek.nz"
    tld=`echo ${@: -1} | awk -F "." '{print $NF}'`
    if [ `echo $tld | egrep 'com|net|tv|cc'` ]; then
        $WHOIS "$@"
    else
        $WHOIS -h $tld$resolver "$@"
    fi;
}

alias l='ls -loBaFT'
alias ls='ls -Ga'
alias rm='rm -i'
alias mtr='mtr --curses'
#alias whois='iwhois'
alias idid='idone'
alias less=$PAGER
alias docker=docker-osx
alias apg='apg -m 20 -M SNCL -n 1'

HISTIGNORE='&:l: *'; export HISTIGNORE

if [ ! -f ${HOME}/.gpg-agent-info ]; then
    gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info"
fi
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    GPG_TTY=$(tty)
    export GPG_TTY
fi


if [ -f `which brew` ]; then
    if [ -f `brew --prefix git`/etc/bash_completion.d/git-completion.bash ]; then
        source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
    fi

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi

    if [ -d `brew --prefix`/opt/android-sdk ]; then
        export ANDROID_HOME=`brew --prefix`/opt/android-sdk
    fi
fi

if [ -d "/Library/Java/JavaVirtualMachines/1.6.0_45-b06-451.jdk" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/1.6.0_45-b06-451.jdk/Contents/Home/"
fi

if [ -f `which tmuxinator` ]; then
    if [ -f ~/.bin/tmuxinator.bash ]; then
        source ~/.bin/tmuxinator.bash
    fi
fi

if [ -f `which rvm` ]; then
    if [ -f ~/.rvm/scripts/rvm ]; then
        source ~/.rvm/scripts/rvm
    fi
fi

if which plenv > /dev/null; then eval "$(plenv init -)"; fi

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
export DISABLE_AUTO_TITLE=true
tset
