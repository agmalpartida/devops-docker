if type nvim >/dev/null 2>&1; then
	alias vim='nvim'
fi

alias v='nvim'
alias vi='nvim'
alias v.='nvim .'
alias vconf='v $HOME/.config/nvim/init.lua'

function reload-all-vim() {
	tmux list-panes -aF "#{pane_id} #{pane_current_command}" |
		awk '/vim|nvim/ {print $1}' |
		xargs -I {} tmux send-keys -t {} "C-[" ":so ~/.config/nvim/init.lua" "C-m"
}

# Enabled true color support for terminals
# export NVIM_TUI_ENABLE_TRUE_COLOR=1

#################
#  zsh vi mode  #
#################
# vi mode. Prefer vi shortcuts.
# bindkey -v

# DEFAULT_VI_MODE=viins
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
# timeout to change normal mode. DO NOT set keytimeout too low in order to work Esc map. Default is 0.4
# KEYTIMEOUT=0.8  # =1 is too low to work alternative Esc map key
# mapped kj to Esc:
# bindkey -M viins 'kj' vi-cmd-mode

# You can fix the backspace key as follows:
# bindkey '^?' backward-delete-char
# # Control-h also deletes the previous char
# bindkey '^H' backward-delete-char
# bindkey '^W' backward-kill-word
# # to get last argument
# bindkey -M viins '\e.' insert-last-word

# # emacs like mode
# bindkey '^A' beginning-of-line
# bindkey '^E' end-of-line

# autoload -U up-line-or-beginning-search
# autoload -U down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# # beginning search with arrow keys and j/k
# bindkey "^[OA" up-line-or-beginning-search
# bindkey "^[OB" down-line-or-beginning-search
# bindkey -M vicmd "k" up-line-or-beginning-search
# bindkey -M vicmd "j" down-line-or-beginning-search

# # beginning search in insert mode, redundant with the up/down arrows above
# # but a little easier to press.
# bindkey "^P" history-search-backward
# bindkey "^N" history-search-forward

# # `v` is already mapped to visual mode, so we need to use a different key to open vim (Control-x + Control-e)
# autoload -z edit-command-line
# zle -N edit-command-line
# bindkey "^X^E" edit-command-line

# # with i+a on visual mode, select text between quotes
# # ci"
# autoload -U select-quoted
# zle -N select-quoted
# for m in visual viopp; do
#   for c in {a,i}{\',\",\`}; do
#     bindkey -M $m $c select-quoted
#   done
# done

# # with i+a on visual mode, select text between bracket
# # ci{, ci(
# autoload -U select-bracketed
# zle -N select-bracketed
# for m in visual viopp; do
#   for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
#     bindkey -M $m $c select-bracketed
#   done
# done

# # surround
# autoload -Uz surround
# zle -N delete-surround surround
# zle -N add-surround surround
# zle -N change-surround surround
# bindkey -a cs change-surround
# bindkey -a ds delete-surround
# bindkey -a ys add-surround
# bindkey -M visual S add-surround

# __set_cursor() {
#     local style
#     case $1 in
#         reset) style=0;; # The terminal emulator's default
#         blink-block) style=1;;
#         block) style=2;;
#         blink-underline) style=3;;
#         underline) style=4;;
#         blink-vertical-line) style=5;;
#         vertical-line) style=6;;
#     esac

#     [ $style -ge 0 ] && print -n -- "\e[${style} q"
# }

# # Set your desired cursors here...
# __set_vi_mode_cursor() {
#     case $KEYMAP in
#         vicmd)
#           __set_cursor block
#           ;;
#         main|viins)
#           __set_cursor vertical-line
#           ;;
#     esac
# }

# __get_vi_mode() {
#     local mode
#     case $KEYMAP in
#         vicmd)
#           mode=NORMAL
#           ;;
#         main|viins)
#           mode=INSERT
#           ;;
#     esac
#     print -n -- $mode
# }

# zle-keymap-select() {
#     __set_vi_mode_cursor
#     zle reset-prompt
# }

# zle-line-init() {
#     zle -K $DEFAULT_VI_MODE
# }

# zle -N zle-line-init
# zle -N zle-keymap-select
