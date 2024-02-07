# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "$HOME/Git/dotfiles/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dotfiles"; then

	# Create a new window inline within session layout definition.
	#new_window "misc"

	# Load a defined window layout.
	new_window "dots"
	run_cmd "cd ~/Git/dotfiles/ && pwd && git pull"
	new_window "ansible"
	run_cmd "cd ~/Git/laptop-dev-ansible/ && pwd && git pull"
	new_window "nvim"
	run_cmd "cd ~/Git/idevim/ && pwd && git pull"
	# new_window "homelab"
	# run_cmd "cd ~/Git/homelab/ && pwd && git pull"
	load_window "homelab"

	# Select the default active window on session creation.
	select_window 4

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
