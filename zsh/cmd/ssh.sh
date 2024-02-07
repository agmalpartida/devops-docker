# Remove --clear because ask password each session
eval $(keychain -q --agents ssh --eval personal job git-nopass)
# Kill currently running agent processes
# $ keychain -k

alias sshconfig='vim $HOME/.ssh/config'

# to do not pass sshrc files
alias sshx='/usr/bin/ssh'

# Set tmux pane title on SSH connections
s() {
	if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
		# if you're running tmux on localhost, rename its window
		tmux rename-window "$(echo $* | cut -d . -f 1)"
		command kyrat "$@"
		#command sshrc "$@"
		#tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		command kyrat "$@"
		#command sshrc "$@"
	fi
}

# /etc/profile.d/complete-hosts.sh
# Autocomplete Hostnames for SSH etc.
_complete_hosts() {
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	host_list=$({
		for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config; do
			[ -r $c ] && sed -n -e 's/^Host[[:space:]]//p' -e 's/^[[:space:]]*HostName[[:space:]]//p' $c
		done
		for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts; do
			[ -r $k ] && egrep -v '^[#\[]' $k | cut -f 1 -d ' ' | sed -e 's/[,:].*//g'
		done
		sed -n -e 's/^[0-9][0-9\.]*//p' /etc/hosts
	} | tr ' ' '\n' | grep -v '*')
	COMPREPLY=($(compgen -W "${host_list}" -- $cur))
	return 0
}
complete -F _complete_hosts sshrc 2>/dev/null
complete -F _complete_hosts host 2>/dev/null

export KYRAT_SHELL=bash
