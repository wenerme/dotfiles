#!/usr/bin/env bash

bashdoc zh <<'DOC-HERE'

## rc_my_tools
* 添加运维命令补全
* kubectl
  * alias k
* vault, terraform, consul, nomad

DOC-HERE

# ops command
# ============
iscmd kubectl && ! iscmd __start_kubectl && {
  log_info Detect kubectl add completion
  source <(kubectl completion bash)

  [ -d $HOME/.krew/bin ] && export PATH="${PATH}:${HOME}/.krew/bin"
}

iscmd kubectl && iscmd __start_kubectl && {
  alias k=kubectl
  complete -F __start_kubectl k
}

# self complete
for i in terraform consul vault nomand; do
  log_info Detect self complete $i
  iscmd $i && complete -C $(which $i) $i
done
