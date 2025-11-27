#!/bin/bash

# Ensure script is run as root or via sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root (use sudo)."
  exit 1
fi

usage() {
  echo "Usage: $0 {create|lock|unlock|delete} username"
  exit 1
}

ACTION="$1"
USER="$2"

# Validate arguments
if [[ -z "$ACTION" || -z "$USER" ]]; then
  usage
fi

case "$ACTION" in
  create)
    if id "$USER" &>/dev/null; then
      echo "User '$USER' already exists."
      exit 0
    fi

    useradd -m -s /bin/bash "$USER"
    echo "User '$USER' created. Please set a password:"
    passwd "$USER"
    ;;

  lock)
    if ! id "$USER" &>/dev/null; then
      echo "User '$USER' does not exist."
      exit 1
    fi

    passwd -l "$USER"
    echo "User '$USER' locked."
    ;;

  unlock)
    if ! id "$USER" &>/dev/null; then
      echo "User '$USER' does not exist."
      exit 1
    fi

    passwd -u "$USER"
    echo "User '$USER' unlocked."
    ;;

  delete)
    if ! id "$USER" &>/dev/null; then
      echo "User '$USER' does not exist."
      exit 1
    fi

    userdel -r "$USER"
    echo "User '$USER' deleted (with home directory)."
    ;;

  *)
    usage
    ;;
esac


