alias g='git'
alias gup='git pull; git add . ; git commit -m "wip" ; git push'

git-status() {
gitdir="$PWD"
find $gitdir -name ".git" 2> /dev/null | sed 's/\/.git/\//g' | awk '{print "\033[1;32m\nRepo ----> \033[0m " $1; system("git --git-dir="$1".git --work-tree="$1" status")}'
}

# Cleanup remote repository of all branches already merged into master
alias git-cleanup="git branch --remotes --merged | grep -v master | sed 's@ origin/@:@' | xargs git push origin"

alias gl="git log --oneline | fzf --preview 'git show --name-only {1}'"

github-account() {
  if [ -z "$1" ]; then
    echo "Please, give me a github user account and I show you all repositories for him"
  else
    curl -s "https://api.github.com/users/${1}/repos?per_page=1000" |grep git_url |awk '{print $2}' | sed 's/"\(.*\)",/\1/'
  fi
}


function delete-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}
