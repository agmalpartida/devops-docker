# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Git/job/"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "tf"; then

	# Create a new window inline within session layout definition.
	new_window "tf-modules"
	run_cmd "~/Git/job/terraform-modules/"
	new_window "tf-live"
	run_cmd "~/Git/job/terraform-live/"
	new_window "tf-apply"
	run_cmd "~/Git/job/terraform-live/"

	# Load a defined window layout.
	#load_window "example"

	# Select the default active window on session creation.
	select_window 3

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
