zstyle ':vcs_info:git*' formats "%b"

precmd () {
    vcs_info

    # from https://stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt
    local zero='%([BSUbfksu]|([FK]|){*})'

    local CANDY=""
    local RANDY=""
    [[ ! -z ${IN_NIX_SHELL} ]]    && CANDY+=" ❄" # check inserting the emoji again if in kitty does not work
    [[ ! -z ${vcs_info_msg_0_} ]] && RANDY+="${vcs_info_msg_0_} שׂ"

    local PROMPTL="%BΓ,%b %(4~|%-1~/.../%2~|%~)$CANDY"
    local PROMPTR=$RANDY

    local PROMPTW # White space
    (( PROMPTW = ${COLUMNS} - ${#${(S%%)PROMPTL//$~zero/}} - ${#${(S%%)PROMPTR//$~zero/}} ))

    PROMPT=$'\n'$PROMPTL${(pl:PROMPTW:: :)}$PROMPTR$'\n'"%Bλ.%b "
}
