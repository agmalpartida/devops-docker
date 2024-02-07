# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Git/job/devops-tools/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dev"; then

	# Load a defined window layout.
	#load_window "example"

	new_window "devops"
	run_cmd "cd ~/Git/job/devops-tools/ && pwd && git pull"
	new_window "crm-back"
	run_cmd "cd ~/Git/job/moneyeu-crm-back/ && pwd && git fetch"
	new_window "crm-front"
	run_cmd "cd ~/Git/job/moneyeu-crm-front/ && pwd && git fetch"

	# Select the default active window on session creation.
	select_window 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
