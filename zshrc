# ================================================================
# Core
# ================================================================
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

# No beep!
setopt no_beep


# ================================================================
# History
# ================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt inc_append_history
setopt share_history


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

alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gr='git reset'
alias gc='git commit -v'
alias gca='git commit --amend'
alias grs='git restore'
alias gch='git checkout'
alias gsw='git switch'
alias gbd='git branch --merged | grep -v "*" | xargs -I % git branch -d %'


# ================================================================
# Local if exists(e.g.: For ANTHROPIC_API_KEY)
# ================================================================
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi


# ================================================================
# Externals
# ================================================================
# Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# mise
if [ -f /opt/homebrew/bin/mise ]; then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
fi

# For Cargo, Rust language utilities
if [ -d ~/.cargo ]; then
  source ~/.cargo/env
fi

# Prompt
if [ -d ~/Codes/pure ]; then
  fpath+=(~/Codes/pure)
  autoload -U promptinit; promptinit
  prompt pure
fi

# Fzf, fuzzy finder
if [ -f /opt/homebrew/bin/fzf ]; then
  export FZF_DEFAULT_OPTS="--layout reverse"
  export FZF_ALT_C_COMMAND=""
  export FZF_CTRL_T_COMMAND=""
  source <(fzf --zsh)

  # `cd` without args: pick a dir under ~/Codes and ~/Sandbox
  cd() {
    if (( $# )); then
      builtin cd "$@"
      return
    fi
    local dir
    dir=$(builtin cd ~ && print -l Codes/*(N/) Sandbox/*(N/) | fzf) && builtin cd ~/$dir
  }
fi

# Eza, enhanced `ls` command
if [ -f /opt/homebrew/bin/eza ]; then
  alias ls='eza'
  alias tree='eza -T --all --git-ignore'
fi

# Bat, enhanced `cat` command
if [ -f /opt/homebrew/bin/bat ]; then
  export BAT_STYLE="plain"
  export BAT_THEME="ansi"
  export BAT_PAGER="never"
fi

# Use nvim
if [ -f /opt/homebrew/bin/nvim ]; then
  export GIT_EDITOR="nvim"
fi

# GPG, for git commit signing
export GPG_TTY=$TTY


# ================================================================
# Completion (Keep this section last!)
# `compinit` must run after all `fpath` changes,
# and before any `compdef` calls.
# ================================================================
autoload -Uz compinit && compinit

# Enable Shift+Tab
bindkey '^[[Z' reverse-menu-complete

# Graphite, `gt` completions(run `gt completion >> ~/.zshrc`)
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt

