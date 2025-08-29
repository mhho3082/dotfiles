#!/usr/bin/env bash

# Diff display options
#
# range: $# = 0 is staged + unstaged
#        $# = 1 is revision (is revision specifier)
#        $# = 1 is n commits before HEAD (is integer)
#        $# = 2 is revision / commits-before range
# For checking against index (staged), use `--cached`, it will be passed to Git
#
# style: ``  is normal (patch + compact summary)
#        `w` is diff-words
#        `t` is difftool
#        `s` is summary
#        `n` is name only
# https://stackoverflow.com/a/25634420
# https://stackoverflow.com/a/1587952

is_rev() {
  git rev-parse --verify --quiet "$1" &>/dev/null
}

modify_specifiers() {
  case $# in
    0) echo "HEAD" ;;
    1) echo "$(is_rev "$1" && echo "$1~1 $1" || echo "HEAD~$1")" ;;
    2) echo "$(is_rev "$1" && echo "$1" || echo "HEAD~$1") $(is_rev "$2" && echo "$2" || echo "HEAD~$2")" ;;
    *) echo $@ ;;
  esac
}

main() {
  local s="$1"
  shift 1
  local range="" style="" separator=0 specifiers=()

  # Find first $@ that is not is_rev nor integer
  for arg in "$@"; do
    if is_rev "$arg" || [[ "$arg" =~ ^[0-9]+$ ]]; then
      ((separator++))
    else
      break
    fi
  done

  specifiers=("${@:1:separator}")
  rest=("${@:((separator + 1))}")

  range="$(modify_specifiers "${specifiers[@]}")"
  case "$s" in
    _) style="diff --patch-with-stat --compact-summary" ;;
    w) style="diff --patch-with-stat --compact-summary --color-words='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'" ;;
    t) style="difftool --patch-with-stat --compact-summary" ;;
    s) style="diff --compact-summary" ;;
    n) style="diff --name-status" ;;
  esac

  local command="git $style $range ${rest[@]}"
  printf "> %s\n\n" "$command"
  eval "$command"
}
main "$@"
