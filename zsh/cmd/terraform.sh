alias tf='terraform'
alias tfp='terraform plan'
alias tfv='terraform validate'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfo='terraform output'
alias tfd='terraform destroy'

# https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache
# [[ -d "$HOME/.terraform.d/plugin-cache" ]] || mkdir -p "$HOME/.terraform.d/plugin-cache"
# export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
#
# Terraform autocomplete
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform
