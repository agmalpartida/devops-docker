alias g='git'

# go to root of directory
alias ghome='cd "$(git rev-parse --show-toplevel)"'

# Cleanup remote repository of all branches already merged into master
alias gcleanup="git branch --remotes --merged | grep -v master | sed 's@ origin/@:@' | xargs git push origin"

# archive
alias garchive="git archive --output=archive-HEAD.tar.gz HEAD"

# submodules
alias gsub="git submodule update --init --recursive"

# number of commmits by user
alias gcommitter="git shortlog -s -n --all"

function gacp() {
	cd "$(git rev-parse --show-toplevel)"
	git add .
	git commit -m "$1"
	git push
	cd -
}

github-account() {
	if [ -z "$1" ]; then
		echo "Please, give me a github user account and I show you all PUBLIC repositories for him"
	else
		curl -s "https://api.github.com/users/${1}/repos?per_page=1000" | grep git_url | awk '{print $2}' | sed 's/"\(.*\)",/\1/'
	fi
}

function gsummary() {
	echo "current git user is $(git config --get user.name)"
	git log --author="$(git config --get user.name)" --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 + $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }'
}
