#!/bin/sh

# Set Opts
#---------------------------------------------
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
unsetopt BEEP

# Set Language
#---------------------------------------------
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Set Base Config
#---------------------------------------------
export OSTYPE=$(uname -a | awk '{print $1}')
export CLICOLOR=1
export TERM=xterm-256color
export ZSH_DOTFILES_DIR="${HOME}/Git/dotfiles"
export ZSH_CMD_PATH="${ZSH_DOTFILES_DIR}/zsh/cmd"
export TOOLS_PATH="${HOME}/.local/opt/tools"
export _ZSH_CONFIG_PATH="${ZSH_DOTFILES_DIR}/zsh"
export _ZSH_PLUGINS_PATH="${_ZSH_CONFIG_PATH}/plugins"
export _ZSH_COMPLETIONS_PATH="${_ZSH_CONFIG_PATH}/completions"
export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000

# Set Zsh Prompt
#---------------------------------------------
fpath+=("${_ZSH_CONFIG_PATH}/pure")
autoload -U promptinit; promptinit
prompt pure

# Load Commands
#---------------------------------------------
for z (${ZSH_CMD_PATH}/**/*(N.)) source $z
# source "${ZSH_DOTFILES_DIR}/${OSTYPE}.zshrc"

# Load Plugins
#---------------------------------------------
for z in `ls ${_ZSH_PLUGINS_PATH}`;
do
  if [ -f "${_ZSH_PLUGINS_PATH}/${z}/${z}.zsh" ]; then
    source "${_ZSH_PLUGINS_PATH}/${z}/${z}.zsh";
  fi || true
done;

# Zsh Completions + Keybindings
#---------------------------------------------
source ${_ZSH_COMPLETIONS_PATH}/completions.zsh

# Load Tools
#---------------------------------------------
type LoadTools &>/dev/null && LoadTools || true

# PATH {{{
export PATH="/usr/local/bin:$PATH"

# Extend $PATH without duplicates
_extend_path() {
  if ! $(echo "$PATH" | tr ":" "\n" | grep -qx "$1"); then
    export PATH="$1:$PATH"
  fi
}

# Add custom bin to $PATH
[[ -d "$HOME/Git/aws-scripts" ]] && _extend_path "$HOME/Git/aws-scripts"
[[ -d "$HOME/.tmuxifier/bin" ]] && _extend_path "$HOME/.tmuxifier/bin"
[[ -d "$HOME/.scripts" ]] && _extend_path "$HOME/.scripts"
[[ -d "$HOME/.scripts/git" ]] && _extend_path "$HOME/.scripts/git"
[[ -d "$HOME/.local/bin" ]] && _extend_path "$HOME/.local/bin"

# }}}

# ZSH Bindkey Reverse Lookup
bindkey -e  # emac mode
# Binds
bindkey "^[[3~" delete-char
bindkey "^A" beginning-of-line
bindkey "^Q" end-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey -s '^f' 'lf\n'
bindkey -s '^v' 'nvim\n'

# https://github.com/jimeh/tmuxifier
#eval "$(tmuxifier init -)"

# for lf file manager
export OPENER='rifle'

