# HISTORY {{{
# with "C-p" I am going back in my history
#
HISTFILE="$HOME/.history"
SAVEHIST=1000
HISTSIZE=1200
HISTCONTROL=ignoreboth
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# 2x control is completion from history!!!
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
bindkey '^X^X' hist-complete

## Delete the bash history entry at offset OFFSET ##
#Delete only one history entry
#history -d offset
#history -d number
#history -d 1013

# }}}
