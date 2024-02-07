#!/bin/sh
# Set tmux status line color based on hostname
SESSION=$USER

hash_string256() {
  # For none GNU systems
  hash_value=$(printf "%s" "$1" | md5 | tr "a-f" "A-F")
  # For GNU systems
  # hash_value=$(printf "%s" "$1" | md5sum |tr -d " -"| tr "a-f" "A-F")
  printf "ibase=16; (%s + %X) %% 100 \n" $hash_value "$2" | bc
}

tmux -2 new-session -d -s $SESSION

tmux set -g status-fg colour$(hash_string256 $HOST)
tmux set -g status-bg colour$(hash_string256 $HOST 127)

# Attach to session
tmux -2 attach-session -t $SESSION
