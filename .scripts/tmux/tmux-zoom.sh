#!/bin/bash

# Instructions
# ------------
#
# 1. Install this script and give it execute permission somewhere in your PATH.
#    For example:
#
#    $ mkdir -p ~/bin
#    $ chmod +x ~/bin/tmux-zoom.sh
#
# 2. Add a shortcut in your ~/.tmux.conf file:
#
#    bind C-k run "tmux-zoom.sh"
#
# 3. When using this shortcut, the current tmux pane will open in a new window by itself.
#    Running it again in the zoomed window will return it to its original pane. You can have
#    as many zoomed windows as you want.

current=$(tmux display-message -p '#W-#I-#P')
list=$(tmux list-window)

[[ "$current" =~ ^(.*)-([0-9]+)-([0-9]+) ]]
current_window=${BASH_REMATCH[1]}
current_pane=${BASH_REMATCH[2]}-${BASH_REMATCH[3]}
new_zoom_window=ZOOM-$current_pane

if [[ $current_window =~ ZOOM-([0-9]+)-([0-9+]) ]]; then
  if [ "$(tmux list-panes | wc -l)" -gt 1 ]; then
    tmux display-message "other panes exist"
    exit 0
  fi
  old_zoom_window=ZOOM-${BASH_REMATCH[1]}-${BASH_REMATCH[2]}
  tmux select-window -t ${BASH_REMATCH[1]} \; select-pane -t ${BASH_REMATCH[2]} \; swap-pane -s $old_zoom_window.0 \; kill-window -t $old_zoom_window
elif [[ $list =~ $new_zoom_window ]]; then
  tmux select-window -t $new_zoom_window
else
  if [ "$(tmux list-panes | wc -l)" -eq 1 ]; then
    tmux display-message "already zoomed"
    exit 0
  fi
  tmux new-window -d -n $new_zoom_window \; swap-pane -s $new_zoom_window.0 \; select-window -t $new_zoom_window
fi


