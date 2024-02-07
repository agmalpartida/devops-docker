session_root "$HOME/Git/homelab/"

# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Git/homelab"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "homelab"

# Split window into panes.
run_cmd "cd ~/Git/homelab/gitops && pwd && git pull"
# split_v 20
# run_cmd "cd ~/Git/homelab/gitops/argocd/apps/"

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
select_pane 1
