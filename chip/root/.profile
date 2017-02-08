# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n
alias ls='ls --color=auto'
alias ll='ls -la'
alias l='ls -l'
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$ '
LS_COLORS=$LS_COLORS:'di=0;36:' ; export LS_COLORS
