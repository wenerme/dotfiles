#!/usr/bin/env bash

bashdoc <<'DOC-HERE'

## rc_my_tools

DOC-HERE

# ops command
# ============
# Kubernetes
bashdoc en <<'DOC-HERE'

### Kubernetes integration
* alias k=kubectl
* detect krew
* completion - kubectl, helm

DOC-HERE

iscmd kubectl && {
  log_info Detect kubectl

  [ -d $HOME/.krew/bin ] && {
    log_info Detect krew
    try-path ${KREW_HOME:-$HOME/.krew/bin}
  }

  ! iscmd __start_kubectl && {
    log_info kubectl add completion  
    source <(kubectl completion bash)
  }

  iscmd __start_kubectl && {
    log_info Add k for kubectl
    alias k=kubectl
    complete -F __start_kubectl k
  }

  iscmd helm && {
    source <(helm completion bash)
  }
}

bashdoc <<'DOC-HERE'

### Self complete command
* vault, terraform, consul, nomad
* minio mc

DOC-HERE

# self complete
for i in terraform consul vault nomad; do
  log_info Detect self complete $i
  iscmd $i && complete -C $(which $i) $i
done

#
for i in mc; do
  log_info Detect self complete $i
  iscmd $i && complete -C $(which $i) $i
done
