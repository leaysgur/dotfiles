# ================================================================
# Environment variables
# ================================================================
export PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin
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

# Ensure `cwd` for Wezterm opening new session
__vte_urlencode() (
  LC_ALL=C
  str="$1"
  while [ -n "$str" ]; do
    safe="${str%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
    printf "%s" "$safe"
    str="${str#"$safe"}"
    if [ -n "$str" ]; then
      printf "%%%02X" "'$str"
      str="${str#?}"
    fi
  done
)
__vte_osc7 () {
  printf "\033]7;file://%s%s\007" "${HOSTNAME:-}" "$(__vte_urlencode "${PWD}")"
}
precmd_functions+=(__vte_osc7)

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
alias vu='vi'
alias vo='vi'
alias bi='vi'
alias bu='vi'
alias bo='vi'
alias ci='vi'
alias cu='vi'
alias co='vi'
alias vi='nvim'

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
alias gsw='git switch'
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
  export BAT_PAGER="never"
fi

# Use nvim
if [ -f /usr/local/bin/nvim ]; then
  export GIT_EDITOR="nvim"
fi

# Override local settings if exists
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
