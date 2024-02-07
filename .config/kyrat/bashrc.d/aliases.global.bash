alias app-online="lsof -nPi | cut -f 1 -d ' '| uniq | tail -n +2"
alias bofh='telnet towel.blinkenlights.nl 666 2>/dev/null |tail -2'

alias json-print='echo '$1' | sed 's/\\//g' | jq .'

alias clr='clear;echo "Currently logged in on $(tty), as $USER in directory $PWD."'

alias v='vim'
alias h='history'
alias ls="ls -hF"
alias l="ls -hF"
alias la="ls -AhF"
alias ll="ls -ltrAhF"
alias cd=' cd'
alias ..=' cd ..; ll'
alias ...=' cd ..; cd ..; ll'
alias ....=' cd ..; cd ..; cd ..; ll'
alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias p=' ps aux | grep'
alias ping='sudo ping -c 5'
alias ipr="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ip a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
alias info="neofetch --config off --bold off --colors 4 1 8 8 8 7"
alias disk="ncdu"

# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'

# putting sudo before the last shell command
alias sudo-last-cmd='sudo $(fc -ln -1)'

# to view 10 largest directories in your current directory
alias dul='du -hs */ | sort -hr | head'

# show process using sockets
alias conn='ss -p'

#################################
# Get top process eating memory #
#################################
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

##############################
# Get top process eating cpu #
##############################
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'


# {{{ RANDOM SHIT
alias ka="killall" \
      sudo="sudo " \
      free="free -hm" \
      ipp="curl ipinfo.io/ip" \
      wttr="curl wttr.in/" \
      wget="wget -c" \
      cls="printf '\033c' && clear" \
      rr="curl -sL https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
      # }}}
      # {{{ CP,MV,RM AND MKDIR
      alias cp="cp -rfv" \
            mv="mv -fv" \
            rm="rm -rfv" \
            mkdir="mkdir -pv"
                  # }}}

