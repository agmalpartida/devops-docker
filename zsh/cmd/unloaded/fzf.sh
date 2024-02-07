# use the output of fzf as an argument for another command
alias f='nvim $(fzf)'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# to install the key bindings and fuzzy completion:
# $(brew --prefix)/opt/fzf/install

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow  -g "!{*.git*,*node_modules*,Library,Applications,*cache*,.zsh*,.powerline,.nvm,.hammer*,.fzf,.pyenv,.tmux,.npm}/*" 2> /dev/null'

#export FZF_DEFAULT_OPTS="--prompt=' ' --cycle --preview='bat {}' +i --bind=ctrl-j:preview-half-page-down,ctrl-k:preview-half-page-up"

export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
--bind 'ctrl-v:execute(nvim {+})'
"

# nord theme
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
#     --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
#     --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
#     --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

# Setting ag as the default source for fzf
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Fuzzy completion alias
# By default, the install script defines the fuzzy completion trigger as **
export FZF_COMPLETION_TRIGGER='**'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#export FZF_TMUX_OPTS="-p"
#export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Solarized colors
#export FZF_DEFAULT_OPTS='
#--color fg:#ffffff,bg:#30333d,hl:#A3BE8C,fg+:#D8DEE9,bg+:#30333d,hl+:#A3BE8C,border:#585e74
#--color pointer:#f9929b,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#9ce5c0,marker:#EBCB8B
#'

# DO NOT UNCOMMENT BELOW LINES BECAUSE FREEZZY TMUX AFTER EXECUTE CTRL-R
#FZF_TAB_COMMAND=(
#fzf
#--ansi
#--expect='$continuous_trigger' # For continuous completion
#--nth=2,3 --delimiter='\x00'  # Don't search prefix
#--layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
#--tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
#'--query=$query'   # $query will be expanded to query string at runtime.
#'--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
#)
#zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

#zstyle ':completion:complete:*:options' sort false

#export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# install plugin: zplug Aloxaf/fzf-tab, from:github
# only aws command completion
#zstyle ':completion:*:*:aws' fzf-search-display true
# or for everything
#zstyle ':completion:*' fzf-search-display true

#zstyle ":completion:*:git-checkout:*" sort false
#zstyle ':completion:*:descriptions' format '[%d]'
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

## FZF FUNCTIONS ##

# find-directories - usage: fdd <SEARCH_TERM>
fdd() {
	cd $(find . -path "*/.*" -type d | fzf-tmux)
}

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
	if [ ! "$#" -gt 0 ]; then
		echo "Need a string to search for!"
		return 1
	fi
	rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
	local files
	IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))

	# IFS=$'\n' files=($(fzf --prompt="> select a file: " --border --multi --reverse --border --preview='head -$LINES {}' --height 70% | xargs -r $EDITOR))
	[[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fh [FUZZY PATTERN] - Search in command history
fh() {
	print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fbr [FUZZY PATTERN] - Checkout specified branch
# Include remote branches, sorted by most recent commit and limited to 30
fgb() {
	local branches branch
	branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
		branch=$(echo "$branches" |
			fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) &&
		git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# tm [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
ftm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	if [ $1 ]; then
		tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1")
		return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux $change -t "$session" || echo "No sessions found."
}

# tm [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tm` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftm` will delete that session if it exists
ftmk() {
	if [ $1 ]; then
		tmux kill-session -t "$1"
		return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux kill-session -t "$session" || echo "No session found to delete."
}

# fuzzy grep via rg and open in vim with line number
fgr() {
	local file
	local line

	read -r file line <<<"$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

	if [[ -n $file ]]; then
		vim $file +$line
	fi
}
