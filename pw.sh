#!/bin/bash

dir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")
cd "$dir" || exit 1

RESET=$(tput sgr0)
BOLD=$(tput bold)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)

source "./depcheck.sh"
if ! dependency_check; then
  exit 1
fi

# parse args
profile=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--profile)
      profile="$2"
      shift 2
      ;;
    *)
      echo "${RED}✗${RESET} Unknown option: ${BOLD}${1}${RESET}" >&2
      echo "Usage: pw [-p|--profile PROFILE]" >&2
      exit 1
      ;;
  esac
done

# set RBW_PROFILE environment variable if profile specified
if [[ -n "$profile" ]]; then
  export RBW_PROFILE="$profile"
fi

# set prompt according to profile
prompt="Bitwarden"
[[ -n "$profile" ]] && prompt="${profile}"
prompt="${prompt} > "

preview_cmd="rbw get {} --raw | jq -C -f './filter.jq'"

if ! list=$(rbw list); then
  exit 1
fi

fzf_output=$(printf '%s' "$list" | fzf \
  --height=~50% \
  --layout=reverse \
  --info=inline-right \
  --border=rounded \
  --prompt="${prompt}" \
  --preview="${preview_cmd}" \
  --preview-window="right:50%" \
  --preview-border=left \
  --expect=enter,ctrl-u,ctrl-t,ctrl-p \
)

# fzf with --expect returns key on first line, selection on second line
read -r key <<< "$fzf_output"
read -r item <<< "$(echo "$fzf_output" | tail -n +2)"

# if no item was selected, exit
if [[ -z "$item" ]]; then
  exit 0
fi

case "$key" in
  enter|"")
    action_label="password"
    value_to_copy=$(rbw get "$item" 2>&1)
    regex="^entry for '(.+?)' had no (.+?)$" # rbw doesn't exit with non-zero when `get` fails :(
    [[ "$value_to_copy" =~ $regex ]] && value_to_copy="null"
    ;;
  ctrl-u)
    action_label="username"
    value_to_copy=$(rbw get "$item" -f "username" 2>&1)
    ;;
  ctrl-t)
    action_label="TOTP"
    value_to_copy=$(rbw code "$item" 2>&1) || value_to_copy="null"
    ;;
  ctrl-p)
    rbw get "$item" --full --raw | fx 2>&1
    exit 0
    ;;
esac

# copy the retrieved value to the clipboard and provide feedback.
if [[ -n "$value_to_copy" && "$value_to_copy" != "null" ]]; then
  printf "%s" "$value_to_copy" | "$clipboard" > /dev/null 2>&1 & disown
  echo "${GREEN}✓${RESET} Copied ${BOLD}${action_label}${RESET} for ${CYAN}${item}${RESET}."
else
  echo "${RED}✗${RESET} No ${BOLD}${action_label}${RESET} found for ${CYAN}${item}${RESET}." >&2
  exit 1
fi

