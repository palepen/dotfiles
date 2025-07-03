autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %b'
setopt PROMPT_SUBST

# Ayu Color Mapping
AYU_SUCCESS="%F{114}"   # green ✓
AYU_ERROR="%F{196}"     # red ✗
AYU_ACCENT="%F{214}"    # orange
AYU_USER="%F{81}"       # blue
AYU_PATH="%F{108}"      # greenish
AYU_NIX="%F{45}"        # NixOS ❄
AYU_RESET="%f"

PS1='${AYU_NIX}❄ ${AYU_RESET} $(if [[ $? == 0 ]]; then echo "'$AYU_SUCCESS'✓'$AYU_RESET'"; else echo "'$AYU_ERROR'✗'$AYU_RESET'"; fi) '$AYU_USER'%n@%m'$AYU_RESET' '$AYU_PATH'%~'$AYU_RESET' '$AYU_ACCENT'${vcs_info_msg_0_}'$AYU_RESET' ➤ '

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

