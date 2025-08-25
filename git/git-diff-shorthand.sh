#!/usr/bin/env bash

# Diff display options
# range: ``  is staged + unstaged ($# = 0), or revision ($# = 1), or revision range ($# = 2)
#        `i` is staged (ie in index)
#        `u` is unstaged
#        `c` is commit ($# = 1), or commit range ($# = 2)
# style: ``  is normal
#        `w` is diff-words
#        `t` is difftool
#        `s` is stat only
#        `n` is name only
# https://www.reddit.com/r/commandline/comments/wf7oju/comment/iitrsgy
# https://stackoverflow.com/a/1587952

main() {
  local r="$1" s="$2"
  shift 2
  local range="" style=""

  case "$r" in
    _) case $# in 0) range="HEAD" ;; 1) range="HEAD~$1" ;; 2) range="HEAD~$1 HEAD~$2" ;; esac ;;
    i) range="--cached" ;;
    u) range="" ;;
    c) case $# in 1) range="$1~1 $1" ;; 2) range="$1 $2" ;; esac ;;
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
main $@
