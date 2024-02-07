# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Desktop"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "main"; then

	# Create a new window inline within session layout definition.
	new_window "docs"
	run_cmd "cd ~/Documents/Docs/"
	new_window "CHECK"
	run_cmd "nvim ~/Desktop/.check.md"
	new_window "desktop"
	run_cmd "pwd"

	# Load a defined window layout.
	#load_window "example"

	# Select the default active window on session creation.
	select_window 3

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
