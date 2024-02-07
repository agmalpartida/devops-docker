##################
# DOCKER aliases #
##################
dkHelp()
{
   # Display Help
   echo "Description of the docker aliases."
   echo
   echo "dk      - docker"
   echo "dki     - images"
   echo "dkrm    - rm"
   echo "dkl     - logs"
   echo "dklf    - logs follow"
   echo "dkfc    - rm all"
   echo "dkfi    - rm all images"
   echo "dkt     - stats"
   echo "dkps    - ps"
   echo "dkpsa   - ps all"
   echo "dkln    - logs follow '\$1'=<part of name>"
   echo "dkclean - rm all "exited" and dangling volume"
   echo "dkprune - remove all of them"
   echo "dktop   - stats, more info"
   echo "dkstats - stats, no stream"
   echo "dke     - exec sh shell, '\$1'=container"
   echo "dkexe   - exec, '\$1'=container, '\$2'=shell"
   echo "dkstate - inspect, $1=container"
   echo "---"
   echo "dkc     - docker compose"
   echo "dkcu    - start docker compose"
   echo "dkcd    - stop docker compose"
   echo "dkcps   - status docker compose"
   echo "dkcb    - new docker compose build from ground up"
   echo "dkcc    - check if docker-compose.yml file is valid"
   echo
}

alias dk='docker'
alias dki='docker images'
alias dkrm='docker rm'
alias dkl='docker logs'
alias dklf='docker logs -f'
alias dkfc='docker rm `docker ps --no-trunc -aq`'
alias dkfi='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias dkt='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'
alias dkps='docker ps --format="table {{.Names}}\t{{.Image}}\t{{.Ports}}"'
alias dkpsa='docker ps -a --format="table {{.Names}}\t{{.Image}}\t{{.Ports}}"'

alias dkc="docker-compose"
alias dkcu="docker-compose up -d"
alias dkcd="docker-compose down"
alias dkcps="docker-compose ps"
alias dkcb="docker-compose build --no-cache"
alias dkcc="docker-compose config"

dkln() {
  docker logs -f `docker ps | grep $1 | awk '{print $1}'`
}

dkclean() {
  docker rm $(docker ps --all -q -f status=exited) 2>/dev/null
	# When a volume exists and is no longer connected to any containers, it's called a dangling volume
  docker volume rm $(docker volume ls -qf dangling=true) 2>/dev/null
}

dkprune() {
  docker system prune -af
}

dktop() {
  docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}

dkstats() {
  if [ $# -eq 0 ]
    then docker stats --no-stream;
    else docker stats --no-stream | grep $1;
  fi
}

dke() {
  docker exec -it $1 /bin/sh
}

dkexe() {
  docker exec -it $1 $2
}

dkstate() {
  docker inspect $1 | jq .[0].State
}
