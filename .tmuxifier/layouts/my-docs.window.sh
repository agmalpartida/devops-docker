# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Git/my-docs"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "my-docs-srv"

# Split window into panes.
#split_v 20
#split_h 50
run_cmd "source /Users/alberto/Git/my-docs/.venv/bin/activate && mkdocs serve --config-file /Users/alberto/Git/my-docs/mkdocs.yml"

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
#select_pane 1
