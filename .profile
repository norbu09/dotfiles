# $FreeBSD: src/etc/root/dot.profile,v 1.20 1999/08/27 23:24:09 peter Exp $
#
PATH=/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${HOME}/bin:/usr/local/texlive/2013/bin/x86_64-darwin:${HOME}/.rvm/bin
export PATH
TERM=${TERM:-cons25}
export TERM
PAGER=vimpager
export PAGER
MORE=-nce
export MORE
BLOCKSIZE=M
export BLOCKSIZE
HOMEBREW_GITHUB_API_TOKEN=863bc2b5217e761c88bafb41a432dd036ab2f7b7
export HOMEBREW_GITHUB_API_TOKEN

#ENV=$HOME/.bashrc
#export ENV

EDITOR=nvim
export EDITOR

LSCOLORS='bxfxdxcxBxahahBxBxbxbx'
export LSCOLORS

WHOIS=`which whois`

########## functions

iwhois() {
    resolver=".whois.geek.nz"
    tld=`echo ${@: -1} | awk -F "." '{print $NF}'`
    if [ `echo $tld | egrep 'com|net|tv|cc'` ]; then
        $WHOIS "$@"
    else
        $WHOIS -h $tld$resolver "$@"
    fi;
}

## Print a horizontal rule
rule () {
	printf "%$(tput cols)s\n"|tr " " "─"}}
}

## format git diffs
function strip_diff_leading_symbols () {
	color_code_regex="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])"

	# simplify the unified patch diff header
	gsed -r "s/^($color_code_regex)diff --git .*$//g" | \
		gsed -r "s/^($color_code_regex)index .*$/\n\1$(rule)/g" | \
		gsed -r "s/^($color_code_regex)\+\+\+(.*)$/\1+++\5\n\1$(rule)\x1B\[m/g" #|\

	# actually strips the leading symbols
#		gsed -r "s/^($color_code_regex)[\+\-]/\1 /g"
}


###################

alias vim=nvim
alias l='ls -loBaFT'
alias ls='ls -Ga'
alias rm='rm -i'
alias mtr='mtr --curses'
#alias whois='iwhois'
alias idid='idone'
alias less=$PAGER
alias apg='apg -m 20 -M SNCL -n 1'
alias issues='ghi --no-pager list'
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
GRC=`which grc`

HISTIGNORE='&:l: *'; export HISTIGNORE


if `which -s todo.sh`; then
    alias t='todo.sh'
fi

# if [ ! -f ${HOME}/.gpg-agent-info ]; then
#     # GPG_TTY=$(tty)
#     # export GPG_TTY
#     gpg-agent --daemon --write-env-file "${HOME}/.gpg-agent-info"
# fi
# if [ -f "${HOME}/.gpg-agent-info" ]; then
#     . "${HOME}/.gpg-agent-info"
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
# fi
# start GPG agent in case it is not running already
if [ ! -e ${HOME}/.gnupg/S.gpg-agent ]; then
	gpg-agent --daemon
fi

if `which -s brew`; then
    echo "Setting up Homebrew ..."
    if [ -f `brew --prefix git`/etc/bash_completion.d/git-completion.bash ]; then
        source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
    fi

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi

    if [ -d `brew --prefix`/opt/android-sdk ]; then
        export ANDROID_HOME=`brew --prefix`/opt/android-sdk
    fi

    if [ -d `brew --prefix`/share/git-core/contrib/diff-highlight ]; then
        ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" ~/bin/diff-highlight
    fi

    if [ -d `brew --prefix`/etc/grc.bashrc ]; then
        source "`brew --prefix`/etc/grc.bashrc"
    fi

fi

if [ -d "/Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk/Contents/Home/"
fi

if `which -s tmuxinator`; then
    if [ -f ~/.bin/tmuxinator.bash ]; then
        echo "Setting up tmuxinator ..."
        source ~/.bin/tmuxinator.bash
    fi
fi

# if [ -f `which rvm` ]; then
#     if [ -f ~/.rvm/scripts/rvm ]; then
#         echo "Setting up rvm ..."
#         rvm use ruby-1.9.3-p547
#     fi
# fi

if `which -s vagrant`; then
    export VAGRANT_HOME=/Volumes/exobrain/vagrant
fi

if `which -s plenv`; then 
		eval "$(plenv init -)"
fi

source ~/bin/git-prompt.sh
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

if `which -s rvm`; then
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi
