_nem() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(nem commands --no-color)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(nem completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _nem nem
