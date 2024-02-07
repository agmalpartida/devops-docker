# brew install krew
# https://krew.sigs.k8s.io/plugins/
# kubectl krew install view-utilization

# kubectl krew install ssh-jump
# kubectl krew install topology
# kubectl krew install who-can
# kubectl krew install whoami

# setup autocomplete in zsh into the current shell
#source <(kubectl completion zsh)
alias k='kubectl'
# complete -F __start_kubectl k

KUBECONFIG="$HOME/.kube/config"
# Extend $KUBECONFIG without duplicates
_extend_kubeconfig() {
	if ! $(echo "$KUBECONFIG" | tr ":" "\n" | grep -qx "$1"); then
		export KUBECONFIG="$KUBECONFIG:$1"
	fi
}

# for i in ~/.kube/files/*.yaml; do
# 	if [[ -e $i ]]; then
# 		_extend_kubeconfig $i
# 	fi
# done

alias krmevicted="kubectl get pod -n media | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n media"

alias ktop='kubectl top nodes --use-protocol-buffers'
alias kk='kubectl kustomize --enable-helm | kubectl apply -f -'
alias kkd='kubectl kustomize --enable-helm | kubectl delete -f -'

alias c1="awk '{print \$1}'"
alias c2="awk '{print \$2}'"
alias c3="awk '{print \$3}'"
alias c4="awk '{print \$4}'"
alias c5="awk '{print \$5}'"
alias c6="awk '{print \$6}'"
alias c7="awk '{print \$7}'"
alias c8="awk '{print \$8}'"
alias c9="awk '{print \$9}'"
alias c10="awk '{print \$10}'"

## stern k8s logs
#source <(stern --completion=zsh)
#stern hello-world  # tail all pods containing "hello-world" in its name
#stern .            # tail all pods in current namespace
#stern --since 1h . # tail logs from last one hour
alias st='stern'

# brew install dty1er/tap/kubecolor
#alias kubectl='kubecolor'
alias kns="kubens"
alias kcx="kubectx"

alias kg='kubectl get'

alias ka='kubectl apply --recursive -f'
alias kex='kubectl exec -i -t'
alias klo='kubectl logs -f'
alias klop='kubectl logs -f -p'
alias kd='kubectl describe'
alias krm='kubectl delete'
alias kgpo='kubectl get pods'
alias kgpon='kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces'
alias kdpo='kubectl describe pods'
alias krmpo='kubectl delete pods'
alias kgdep='kubectl get deployment'
alias kddep='kubectl describe deployment'
alias krmdep='kubectl delete deployment'
alias kgsvc='kubectl get service'
alias kgsa='kubectl get services --all-namespaces'
alias kdsvc='kubectl describe service'
alias krmsvc='kubectl delete service'
alias kging='kubectl get ingress'
alias kding='kubectl describe ingress'
alias krming='kubectl delete ingress'
alias kgcm='kubectl get configmap'
alias kdcm='kubectl describe configmap'
alias krmcm='kubectl delete configmap'
alias kgsec='kubectl get secret'
alias kdsec='kubectl describe secret'
alias krmsec='kubectl delete secret'
alias kgno='kubectl get nodes'
alias kdno='kubectl describe nodes'
alias kgns='kubectl get namespaces'
alias kdns='kubectl describe namespaces'
alias krmns='kubectl delete namespaces'

alias kgd='kubectl get deployments '
alias kgda='kubectl get deployments --all-namespaces'

alias kgpoall='kubectl get pods --all-namespaces'
alias kgpoallw='kubectl get pods --all-namespaces -o wide'
alias kdpoall='kubectl describe pods --all-namespaces'
alias kdpoallw='kubectl describe pods --all-namespaces -o wide'
alias kgdepall='kubectl get deployment --all-namespaces'
alias kgdepallw='kubectl get deployment --all-namespaces -o wide'
alias kddepall='kubectl describe deployment --all-namespaces'
alias kddepallw='kubectl describe deployment --all-namespaces -o wide'
alias kgsvcall='kubectl get service --all-namespaces'
alias kgsvcallw='kubectl get service --all-namespaces -o wide'
alias kdsvcall='kubectl describe service --all-namespaces'
alias kdsvcallw='kubectl describe service --all-namespaces -o wide'
alias kgingall='kubectl get ingress --all-namespaces'
alias kgingallw='kubectl get ingress --all-namespaces -o wide'
alias kdingall='kubectl describe ingress --all-namespaces'
alias kdingallw='kubectl describe ingress --all-namespaces -o wide'
alias kgcmall='kubectl get configmap --all-namespaces'
alias kgcmallw='kubectl get configmap --all-namespaces -o wide'
alias kdcmall='kubectl describe configmap --all-namespaces'
alias kdcmallw='kubectl describe configmap --all-namespaces -o wide'
alias kgsecall='kubectl get secret --all-namespaces'
alias kgsecallw='kubectl get secret --all-namespaces -o wide'
alias kdsecall='kubectl describe secret --all-namespaces'
alias kdsecallw='kubectl describe secret --all-namespaces -o wide'
alias kgnsall='kubectl get namespaces --all-namespaces'
alias kgnsallw='kubectl get namespaces --all-namespaces -o wide'
alias kdnsall='kubectl describe namespaces --all-namespaces'
alias kdnsallw='kubectl describe namespaces --all-namespaces -o wide'

#alias klogs='kubectl get pods -o name | fzf --preview="kubectl logs {} | tail -100" --preview-window=up:80% --layout reverse'

alias knodes="kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, cap: .status.capacity}'"

alias kshell='kubectl run -it shell --image giantswarm/tiny-tools --restart Never --rm -- sh'

alias kexec='kubectl exec -it'

# view-utilization kubectl plugin that shows cluster resource utilization.
alias kvu='kubectl view-utilization -h'
alias kvuall='kubectl view-utilization namespaces -h'
alias kvun='kubectl view-utilization nodes -h'

alias kimages="
kubectl get pods --all-namespaces -o jsonpath="{..image}" |\
tr -s '[[:space:]]' '\n' |\
sort |\
uniq -c
"

# functions
function kebash() {
	kubectl exec --stdin --tty $@ -- /bin/bash
}

function kesh() {
	kubectl exec --stdin --tty $@ -- /bin/sh
}

function kListContainersInPod() {
	for pod in $(kgp | ignoreFirstLine | c1); do
		echo "\nPOD: $pod"
		kubectl get pod $pod -o=jsonpath='{.spec.containers[*].name}'
		echo "\n"
	done
}

function kLogAllContainersInPod() {
	for container in $(kubectl get pod $1 -o=jsonpath='{.spec.containers[*].name}'); do
		kubectl logs $1 --container $container | tail -100
	done
}

# function kLogAllContainersInPod() { for container in $(kubectl get pod $1 -o=jsonpath='{.spec.containers[*].name}'); do kubectl logs $1 --container $container | tail -20; done }

function kLogsAllContainers() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf --preview='echo {} | xargs kubectl logs --tail=100 --timestamps=true -n' --preview-window=up:wrap:80% | xargs kubectl logs
}
alias klogs=kLogsAllContainers

#function kLogsContainer() {
#kubectl get pods -o name | fzf --preview="kubectl logs {} --container $1 | tail -100" --preview-window=up:80% --layout reverse
#}
#alias klogs=kLogsContainer

# function kShContainer() {
#   export KPOD=$(kubectl get pods -o name | fzf)
#   kubectl exec --stdin --tty $KPOD --container $1 -- /bin/sh
# }

function kexSHContainer() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf | xargs -o -n 2 bash -c 'kubectl exec -n "$0" --stdin --tty "$1" --container node -- /bin/sh'
}
function kexSH() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf | xargs -o -n 2 bash -c 'kubectl exec -n "$0" --stdin --tty "$1" -- /bin/sh'
}

function kexBASHContainer() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf | xargs -o -n 2 bash -c 'kubectl exec -n "$0" --stdin --tty "$1" --container node -- /bin/bash'
}
function kexBASH() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf | xargs -o -n 2 bash -c 'kubectl exec -n "$0" --stdin --tty "$1" -- /bin/bash'
}

function kBashContainer() {
	export KPOD=$(kubectl get pods -o name | fzf)
	kubectl exec --stdin --tty $KPOD --container $1 -- /bin/bash
}

function getAllPodsNamespaceAndName() {
	kubectl get pods --all-namespaces -o jsonpath='{range .items[*]} {.metadata.namespace}   {.metadata.name} {"\n"}'
}

function kdpods() {
	getAllPodsNamespaceAndName | fzf --preview='echo {} | xargs kubectl describe pod -n' | xargs kubectl describe pod -n
}
function kdelpods() {
	getAllPodsNamespaceAndName | fzf --preview='echo {} | xargs kubectl describe pod -n' | xargs kubectl delete pod -n
}

function getAllServicesNamespaceAndName() {
	kubectl get services --all-namespaces -o jsonpath='{range .items[*]} {.metadata.namespace}   {.metadata.name} {"\n"}'
}

function kdservices() {
	getAllServicesNamespaceAndName | fzf --preview='echo {} | xargs kubectl describe service -n' | xargs kubectl describe service -n
}

function kdelservice() {
	getAllServicesNamespaceAndName | fzf --preview='echo {} | xargs kubectl describe service -n' | xargs kubectl delete service -n
}

function kd() {
	kubectl get $1 --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}' | fzf --preview='echo '"'"'{}'"'"' | xargs kubectl describe pod -n' | xargs kubectl describe $1 -n
}

function kgevents() {
	kubectl get events --sort-by='.metadata.creationTimestamp'
}
alias kgev=kgevents

# enable/disable debug mode
# set -x

# colors
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'
NC='\033[0m' # No Color

# Changes default namespace current k8s context.
# Usage e.g.:
# $ change_ns kube-system
change_ns() {
	if [ -z "$1" ]; then
		echo "No namespace specified"
	else
		k config set-context --current --namespace=$1
		local context=$(kubectl config current-context)
		echo "[INFO]${green} $1 ${NC}${yellow}is set as default namespace in context ${context} ${NC}"
	fi
}

# Exec's into a pod. You can pass any number of arguments which kubectl supports, like namespace, container name
# Usage e.g.:
# 1. getin your-pod
# 2. getin my-k8s-pod -n my-namespace -c my-container
getin() {
	k exec -it "$@" -- sh -c '(bash || sh)'
}

# Shows current default namespace and k8s context.
ctx_info() {
	local namespace=$(k config view --minify --output 'jsonpath={..namespace}')
	local context=$(kubectl config current-context)
	echo "${yellow}[INFO] Current Default Namespace: ${green}${namespace:-'No Namespace is set as default.'}${NC}${NC}"
	echo "${yellow}[INFO] Current Context: ${green}${context:-'No context found!'}${NC}${NC}"
}

# List, get or watch pod or get their yaml.
# Usage e.g.:
# 1. pods
# 2. pods -w
# 3. pods -l app=some-app -n my-namespace -oyaml
pods() {
	k get pod $@
}

# List, get or watch pod or get their yaml/json or any thing that kubectl supports.
# Usage e.g.:
# 1. deploy
# 2. deploy -w
# 3. deploy -l app=some-app -n my-namespace -oyaml
deploy() {
	k get deploy $@
}

# Describe a k8s resource.
des() {
	k describe $@
}

# Watch, stream logs of a pod/svc.
# Usage e.g.:
# 1. plogs pod-name
# 2. plogs pod-name -f
# 3. plogs -l app=some-app --since=5m -n my-namespace
# 4. plogs svc/my-service
plogs() {
	k logs $@
}

# Resource usage of pods
# Usage e.g.:
# 1. res_usage -n my-namespace
# 2. res_usage --sort-by='cpu'
res_usage() {
	k top pod ${@}
}

# List all containers(including initContainers) name & image of a pod.
# Usage e.g.:
# 1. pc my-pod
# 2. pc my-pod -n my-namespace
pc() {
	kubecolor get pod $@ --output=json | jq '.spec | (.containers[] | "container: " + .name + "   " + .image),(.initContainers[]? | "init-container: " + .name + "   " + .image)'
}

# List all containers(including initContainers) name & image of a Deployment.
# Usage e.g.:
# 1. dc my-deployment
# 2. dc my-deployment -n my-namespace
dc() {
	k get deploy $@ --output=json | jq '.spec.template.spec.containers[] | .name + " " + .image'
}
