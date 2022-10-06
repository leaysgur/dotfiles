# ================================================================
# Environment variables
# ================================================================
export PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin
export LANG=en_US.UTF-8
export EDITOR=vim
export TERM=xterm-256color
export CLICOLOR=true


# ================================================================
# Core(prompt, completion)
# ================================================================
setopt no_beep

# Enable completion
autoload -Uz compinit && compinit

# Enable Shift+Tab
bindkey '^[[Z' reverse-menu-complete

# Pure prompt
if [ -d ~/.pure ]; then
  fpath+=$HOME/.pure
  autoload -Uz promptinit && promptinit
  prompt pure
fi

# Enable `zmv` command
autoload -Uz zmv
alias zmv='noglob zmv -W'

# ================================================================
# History
# ================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt share_history
setopt hist_ignore_space
setopt hist_reduce_blanks


# ================================================================
# Aliases
# ================================================================
alias vi='vim'
alias vu='vim'
alias vo='vim'
alias bi='vim'
alias bu='vim'
alias bo='vim'
alias ci='vim'
alias cu='vim'
alias co='vim'

alias ll='ls -lahF'

alias treee='rg --files | tree --fromfile'

alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gr='git reset'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gch='git checkout'
alias gbd='git branch --merged | grep -v "*" | xargs -I % git branch -d %'


# ================================================================
# Externals
# ================================================================
# For Volta, Node.js version manger
if [ -d ~/.volta/bin ]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# For Cargo, Rust language utilities
if [ -d ~/.cargo/bin ]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

# Enhancd, enhanced `cd` command
if [ -d ~/.enhancd ]; then
  source ~/.enhancd/init.sh
  export ENHANCD_HOOK_AFTER_CD=ls
fi

# Bat, enhanced `cat` command
if [ -f /usr/local/bin/bat ]; then
  export BAT_STYLE="plain"
  export BAT_THEME="Nord"
fi

# Override local settings if exists
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
