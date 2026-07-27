#!/usr/bin/env bash
set -euo pipefail

# Run a command in a temporary worktree; uncommitted changes never persist.
# Usage: git run-in-worktree <ref> -- <command> [args...]
#        git run-in-worktree <branch> --branch -- <command> [args...]

usage() {
  printf 'Usage: %s <ref> -- <command> [args...]\n' "$0" >&2
  printf '       %s <branch> --branch -- <command> [args...]\n' "$0" >&2
}

if [[ $# -lt 2 ]]; then
  usage
  exit 2
fi

BRANCH="$1"
shift
MODE=detached
COMMAND=()

if [[ "$1" == "--branch" ]]; then
  MODE=branch
  shift
  if [[ "${1:-}" != "--" ]]; then
    usage
    exit 2
  fi
  shift
  COMMAND=("$@")
elif [[ "$1" == "--" ]]; then
  shift
  COMMAND=("$@")
else
  # Preserve git run-in-worktree <branch> <git-subcommand> [args...].
  MODE=branch
  COMMAND=(git "$@")
fi

if [[ "${#COMMAND[@]}" -eq 0 ]]; then
  usage
  exit 2
fi

# Ensure we're inside a git repository.
git rev-parse --git-dir >/dev/null || exit 1

CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
CURRENT_REF="$(git symbolic-ref --quiet HEAD 2>/dev/null || true)"
TARGET_REF="$(git rev-parse --symbolic-full-name --verify "$BRANCH" 2>/dev/null || true)"
ORIGINAL_TARGET_OID=""
WORKTREE_DIR=""
DETACHED=0
COMMAND_STARTED=0

cleanup() {
  status=$?
  trap - EXIT INT TERM

  if [[ "$MODE" == branch && "$COMMAND_STARTED" -eq 1 && "$status" -ne 0 &&
    -n "$ORIGINAL_TARGET_OID" ]]; then
    current_target_oid="$(git rev-parse --verify "$TARGET_REF" 2>/dev/null || true)"
    if [[ -n "$current_target_oid" && "$current_target_oid" != "$ORIGINAL_TARGET_OID" ]] &&
      ! git update-ref "$TARGET_REF" "$ORIGINAL_TARGET_OID" "$current_target_oid"; then
      echo "Failed to restore branch '$BRANCH'." >&2
      status=1
    fi
  fi

  if [[ -n "$WORKTREE_DIR" && -d "$WORKTREE_DIR" ]]; then
    git worktree remove --force "$WORKTREE_DIR" >/dev/null || rm -rf "$WORKTREE_DIR"
  fi

  if [[ "$DETACHED" -eq 1 ]]; then
    if ! git checkout --quiet "$CURRENT_BRANCH"; then
      echo "Failed to restore branch '$CURRENT_BRANCH'." >&2
      status=1
    fi
  fi

  exit "$status"
}
trap cleanup EXIT INT TERM

# Branch mode permits ref-changing commands.
if [[ "$MODE" == branch ]]; then
  if [[ -n "$CURRENT_REF" && "$TARGET_REF" == "$CURRENT_REF" ]]; then
    if [[ -n "$(git status --porcelain)" ]]; then
      echo "Cannot operate on the current branch with uncommitted changes." >&2
      exit 1
    fi
    DETACHED=1
    git checkout --detach --quiet
  fi

  if [[ "$TARGET_REF" == refs/heads/* ]]; then
    ORIGINAL_TARGET_OID="$(git rev-parse --verify "$TARGET_REF")"
  fi
fi

WORKTREE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/git-worktree.XXXXXX")"
if [[ "$MODE" == branch ]]; then
  git worktree add --quiet "$WORKTREE_DIR" "$BRANCH"
else
  git worktree add --detach --quiet "$WORKTREE_DIR" "$BRANCH"
fi

set +e
COMMAND_STARTED=1
(
  cd "$WORKTREE_DIR"
  "${COMMAND[@]}"
)
STATUS=$?
set -e

exit "$STATUS"
