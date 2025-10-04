#!/bin/bash

dependency_check() {
  local exitcode=0

  for cmd in rbw fzf jq fx; do
    if ! command -v "$cmd" >/dev/null; then
      echo "${RED}✗${RESET} Required command ${BOLD}${cmd}${RESET} is not installed." >&2
      exitcode=1
    fi
  done

  clips=(
    'wl-copy'
    'xclip -selection clipboard'
    'pbcopy'
    'clip.exe'
  )

  for clip in "${clips[@]}"; do
    set -- "$clip"
    if command -v "$1" >/dev/null; then
      clipboard="$clip"
      break
    fi
  done

  if [[ -z "$clipboard" ]]; then
    echo "${RED}✗${RESET} No ${BOLD}clipboard utility${RESET} found." >&2
    exitcode=1
  fi

  [[ "$exitcode" -ne 0 ]] && return 1

  return 0
}
