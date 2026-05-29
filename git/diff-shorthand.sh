#!/usr/bin/env bash

# Styles:
#   _ : patch + compact summary
#   f : difftool
#   w : word diff + compact summary
#   s : compact summary
#   n : name-status
#
# Leading rev/int args only; put paths after `--`.
#
#   <none>   : working tree vs index (unstaged)
#   --cached : index vs HEAD (staged)
#   <rev>    : changes introduced by commit / tag / branch <rev>
#   <n>      : same, but <n> means HEAD~n (0 == HEAD; HEAD~0 also works)
#   <a> <b>  : compare two endpoints directly; ints are resolved as HEAD~n
#
# If you want to use an integer that collides with a commit, tag, or branch name,
# use explicit syntax like HEAD~<n> to disambiguate.

is_commit() {
  git rev-parse --verify --quiet --end-of-options "$1^{commit}" >/dev/null 2>&1
}

is_int() {
  [[ $1 =~ ^[0-9]+$ ]]
}

is_spec() {
  is_commit "$1" || is_int "$1"
}

to_commit() {
  if is_commit "$1"; then
    printf '%s\n' "$1"
  elif is_int "$1"; then
    printf 'HEAD~%s\n' "$1"
  else
    return 1
  fi
}

empty_tree() {
  git hash-object -t tree /dev/null
}

resolve_range() {
  RANGE=()

  case $# in
    1)
      local c
      c=$(to_commit "$1") || return 1

      if git rev-parse --verify --quiet --end-of-options "${c}^" >/dev/null 2>&1; then
        RANGE=("${c}^" "$c")
      else
        RANGE=("$(empty_tree)" "$c") # root commit
      fi
      ;;
    2)
      RANGE=("$(to_commit "$1")" "$(to_commit "$2")")
      ;;
    *)
      return 1
      ;;
  esac
}

main() {
  [[ $# -ge 1 ]] || {
    printf 'usage: %s <style> [spec ...] [-- paths...]\n' "$0" >&2
    return 2
  }

  local style=$1
  shift

  local -a args=()
  local -a specs=()

  case "$style" in
    _) args=(diff --patch-with-stat --compact-summary) ;;
    f) args=(difftool --patch-with-stat --compact-summary) ;;
    w) args=(diff --word-diff=color --patch-with-stat --compact-summary) ;;
    s) args=(diff --compact-summary) ;;
    n) args=(diff --name-status) ;;
    *) printf 'unknown style: %s\n' "$style" >&2 && return 2 ;;
  esac

  while (($#)) && is_spec "$1"; do
    specs+=("$1")
    shift
  done

  case ${#specs[@]} in
    0)
      ;;
    1 | 2)
      resolve_range "${specs[@]}" || return 1
      args+=("${RANGE[@]}")
      ;;
    *)
      printf 'expected at most 2 leading revisions/integers\n' >&2
      return 2
      ;;
  esac

  args+=("$@")

  printf '> git'
  printf ' %q' "${args[@]}"
  printf '\n\n'

  exec git "${args[@]}"
}

main "$@"
