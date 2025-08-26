#!/usr/bin/env bash

# Diff display options
# range: ``  is staged + unstaged ($# = 0)
#               or revision ($# = 1, is revision specifier)
#               or n commits before HEAD ($# = 1, is integer)
#               or revision / commits-before range ($# = 2)
#        `i` is staged (ie in index)
#        `u` is unstaged
# style: ``  is normal
#        `w` is diff-words
#        `t` is difftool
#        `s` is stat only
#        `n` is name only
# https://stackoverflow.com/a/25634420
# https://stackoverflow.com/a/1587952

is_rev() {
  git rev-parse --verify --quiet "$1" &>/dev/null
}

main() {
  local r="$1" s="$2"
  shift 2
  local range="" style=""

  case "$r" in
    _) case $# in
      0) range="HEAD" ;;
      1) range="$(is_rev "$1" && echo "$1~1 $1" || echo "HEAD~$1")" ;;
      2) range="$(is_rev "$1" && echo "$1" || echo "HEAD~$1") $(is_rev "$2" && echo "$2" || echo "HEAD~$2")" ;;
    esac ;;
    i) range="--cached" ;;
    u) range="" ;;
  esac

  case "$s" in
    _) style="diff --patch-with-stat" ;;
    w) style="diff --patch-with-stat --color-words='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'" ;;
    t) style="difftool --patch-with-stat" ;;
    s) style="diff --stat" ;;
    n) style="diff --name-only" ;;
  esac

  eval "git $style $range"
}
main "$@"
