#!/usr/bin/env bash
set -euo pipefail

# Run a git subcommand in a worktree of the target branch, without having to switch to it.
# If the command fails, the worktree is cleaned up, and the repo directory is unaffected.
# Usage: git run-in-worktree <target-branch> <git-subcommand> [args...]

if [[ $# -lt 2 ]]; then
  echo "Usage: %s <target-branch> <git-command> [args...]" "$0" >&2
  exit 2
fi

BRANCH="$1"
shift
GIT_COMMAND="$1"
shift

# Ensure we're inside a git repository.
git rev-parse --git-dir >/dev/null || exit 1

CURRENT_BRANCH="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || echo HEAD)"
WORKTREE_DIR=""
DETACHED=0

cleanup() {
  status=$?
  trap - EXIT INT TERM

  if [[ -n "$WORKTREE_DIR" && -d "$WORKTREE_DIR" ]]; then
    git worktree remove --force "$WORKTREE_DIR" >/dev/null || rm -rf "$WORKTREE_DIR"
  fi

  if [[ "$DETACHED" -eq 1 ]]; then
    echo "You are currently in a detached HEAD state."
    echo "Please run 'git checkout $CURRENT_BRANCH' to return to the previous branch."
  fi

  exit "$status"
}
trap cleanup EXIT INT TERM

# If the target branch is currently checked out in the main worktree, detach it temporarily
# so the branch can be checked out in the temporary worktree.
if [[ "$BRANCH" == "$CURRENT_BRANCH" ]]; then
  DETACHED=1
  git checkout --detach --quiet
fi

WORKTREE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/git-worktree.XXXXXX")"
git worktree add "$WORKTREE_DIR" "$BRANCH" --quiet

set +e
git -C "$WORKTREE_DIR" "$GIT_COMMAND" "$@"
STATUS=$?
set -e

exit "$STATUS"
