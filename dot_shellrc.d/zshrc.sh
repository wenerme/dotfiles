#!/bin/env bash
# check do not support zsh https://github.com/koalaman/shellcheck/issues/809

command -v trypath >/dev/null 2>&1 || . ~/.shellrc.d/profile.sh

setopt autocd

# Up & Down search history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up
bindkey "^[[B" down-line-or-beginning-search # Down

bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line       # End
bindkey "^[[3~" delete-char      # Delete

#region History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

setopt CORRECT

setopt AUTO_CD
setopt AUTO_PUSHD

setopt NO_NOMATCH
#endregion

#region Prompt
setopt PROMPT_SUBST
autoload -Uz vcs_info
precmd() {
  vcs_info
}

zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git

# 不需要 hostname @%m
# user ~/project (BRANCH) ERRNO [12:34:56]
# %
PS1='%F{green}%n %F{blue}%~%F{yellow} ${vcs_info_msg_0_}%F{reset} %F{reset}%(?..%F{red} %?%f) %F{cyan}[%*]%f'$'\n''%# '
#endregion

trysource ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
trysource ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

osis Darwin && {
  HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
}

trysource ~/.zsh/zsh-histdb/sqlite-history.zsh

iscmd histdb && {
  autoload -Uz add-zsh-hook

  _zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
  }

  ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here
}

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi
