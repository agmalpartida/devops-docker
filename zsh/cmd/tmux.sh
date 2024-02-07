alias t='TMUX='' tmux new-session -A -s main'

export TMUX_FZF_SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
export TMUX_FZF_OPTIONS="-d 35%"
export TMUX_FZF_PANE_FORMAT="[#{window_name}] #{pane_current_command}  [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{?pane_active,[active],[inactive]}"

#export tmuxifier_CONFIGDIR="~/Git/dotfiles/.config/tmux/sessions"

function tmux-shortcuts {
	cat ~/.tmux.conf | awk '/^[bind]/ && last {print $0,"\t",last} {last=""} /^#/{last=$0}' | column -t -s $'\t' | fzf
}

# function tl {
# 	# tmuxifier load
# 	tmuxifier load ~/Git/dotfiles/.config/tmux/sessions/$1.yaml
# }

# function ts {
# 	# tmuxifier freeze: capture session to yaml file
# 	tmuxifier freeze $1
# }

function tp {
	tmux popup -E "$1"
}

alias tx="tmuxifier"
alias tls="tmuxifier ls"
alias tld="tx s dotfiles"
alias tlt="tx s tf"
alias tlm="tx s main"
alias tle="tx s dev"

# show available tmux sessions
if [[ -z $TMUX ]]; then
	sessions=$(tmux ls 2>/dev/null | awk '! /attached/ { sub(":", "", $1); print $1; }' | xargs echo)
	if [[ -n $sessions ]]; then
		echo "==> Available tmux sessions: $sessions"
	fi
	unset sessions
fi

# Crate and attach a new session with args
# defaults: session named "new" in ${HOME} as working dir with window named "main"
#
# Usage:
# $ tnew
# $ tnew remote ~/path/to/dir
# $ tnew remote ~/path/to/dir scripts
tnew() {
	local session_name="${1:-new}"
	local session_dir=${2:-~/}
	local session_window_name="${3:-main}"

	tmux new-session \
		-d \
		-s "${session_name}" \
		-c "${session_dir}" \
		-n "${session_window_name}"
}

# change cd and vim functionality to automatically rename tmux windows and panes
# unalias vim
# CHAR_LIMIT=15
# MY_VIM="/usr/bin/vim.gtk3"

# tmux ls > /dev/null 2>&1
# TMUX_STATUS=$?
# if [ $TMUX_STATUS -eq 0 ]; then

#     basedirRename () {

#         getval=$(pwd)
#         BASEPATH_FULL="${getval##*/}"
#         BASEPATH="${BASEPATH_FULL:0:$CHAR_LIMIT}/"

#         tmux rename-window " $BASEPATH "
#         tmux select-pane -T " $BASEPATH "
#     }

#     cd () {
#         builtin cd "$@"
#         CD_STATUS=$?
#         basedirRename
#         return "$CD_STATUS"
#     }

#     vim () {

#         FILENAME_FULL="$@"
#         FILENAME="${FILENAME_FULL:0:$CHAR_LIMIT}"
#         tmux rename-window " $FILENAME "
#         tmux select-pane -T " $FILENAME "

#         $MY_VIM $@
#         VIM_STATUS="$?"

#         basedirRename
#         return "$VIM_STATUS"
#     }

#     basedirRename
# fi
