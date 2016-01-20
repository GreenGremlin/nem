if [[ ! -o interactive ]]; then
    return
fi

compctl -K _nem nem

_nem() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(nem commands)"
  else
    completions="$(nem completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
