#!/bin/bash


# Works on Linux (getent/groupadd/useradd) and macOS (dseditgroup/sysadminctl).
#Write script that will make sure user sysop belonging to group sysop exists on system. If the user already exists, print information.
# Script to ensure user sysop (group sysop) exists
set -eo pipefail

USER_NAME="sysop"
GROUP_NAME="sysop"

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)." >&2
    exit 1
  fi
}

print_info() {
  echo "User info:"
  if is_linux; then
    id "$USER_NAME"
    getent passwd "$USER_NAME" || true
    echo "Groups: $(id -nG "$USER_NAME")"
  else
    # macOS
    id "$USER_NAME" || true
    dscl . read "/Users/$USER_NAME" 2>/dev/null || true
    echo "Groups: $(id -nG "$USER_NAME" 2>/dev/null || true)"
  fi
}

require_root

if is_linux; then
  # --- Linux path ---
  # Some distros need full path to /usr/sbin if sudo doesn't pass PATH
  GETENT="${GETENT:-$(command -v getent || true)}"
  GROUPADD="${GROUPADD:-$(command -v groupadd || true)}"
  USERADD="${USERADD:-$(command -v useradd || true)}"
  # Fallback to common sbin paths
  [[ -z "$GROUPADD" && -x /usr/sbin/groupadd ]] && GROUPADD=/usr/sbin/groupadd
  [[ -z "$USERADD"  && -x /usr/sbin/useradd  ]] && USERADD=/usr/sbin/useradd

  if [[ -z "$GETENT" || -z "$GROUPADD" || -z "$USERADD" ]]; then
    echo "Required Linux tools not found (getent/groupadd/useradd). Check PATH or install shadow-utils." >&2
    exit 2
  fi

  if ! "$GETENT" group "$GROUP_NAME" >/dev/null; then
    echo "Group $GROUP_NAME not found. Creating..."
    "$GROUPADD" "$GROUP_NAME"
  fi

  if "$GETENT" passwd "$USER_NAME" >/dev/null; then
    echo "User '$USER_NAME' already exists."
    print_info
  else
    echo "User $USER_NAME not found. Creating..."
    "$USERADD" -m -g "$GROUP_NAME" -s /bin/bash "$USER_NAME"
    echo "User '$USER_NAME' created."
    print_info
  fi

elif is_macos; then
  # --- macOS path ---
  # Create group if missing
  if ! dscl . list /Groups | grep -qx "$GROUP_NAME"; then
    echo "Group $GROUP_NAME not found. Creating..."
    dseditgroup -o create "$GROUP_NAME"
  fi

  # Check user exists
  if dscl . list /Users | grep -qx "$USER_NAME"; then
    echo "User '$USER_NAME' already exists."
    print_info
    # Ensure membership in group
    if ! dsmemberutil checkmembership -U "$USER_NAME" -G "$GROUP_NAME" | grep -q "is a member"; then
      echo "Adding '$USER_NAME' to group '$GROUP_NAME'..."
      dseditgroup -o edit -a "$USER_NAME" -t user "$GROUP_NAME"
    fi
  else
    echo "User $USER_NAME not found. Creating..."
    # sysadminctl (10.13+): creates local user; you will be prompted for a password unless specified.
    # To set a password non-interactively, pass -password 'somepass' (handle securely in real use).
    sysadminctl -addUser "$USER_NAME" -shell /bin/zsh -home "/Users/$USER_NAME" -admin false
    # Add to the group
    dseditgroup -o edit -a "$USER_NAME" -t user "$GROUP_NAME"
    echo "User '$USER_NAME' created and added to '$GROUP_NAME'."
    print_info
  fi
else
  echo "Unsupported OS: $(uname -s)" >&2
  exit 3
fi