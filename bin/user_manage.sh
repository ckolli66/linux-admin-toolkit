#!/bin/bash
# → Shebang: tells system to execute the script with Bash shell.

# Ensure script is run as root or via sudo
if [[ "$EUID" -ne 0 ]]; then
  # → Condition using [[ ]] test expression.
  # → $EUID is a special variable containing effective user ID.
  # → Checks if current user is NOT root (root = 0).
  echo "This script must be run as root (use sudo)."
  exit 1
  # → exit with non-zero code for failure.
fi

usage() {
  # → Function definition in Bash.
  echo "Usage: $0 {create|lock|unlock|delete} username"
  # → $0 = script name; shows correct usage format.
  exit 1
  # → Exits when arguments are incorrect.
}

ACTION="$1"
USER="$2"
# → Positional parameters: $1 = first argument, $2 = second argument.
# → Assigning them to variables for readability.

# Validate arguments
if [[ -z "$ACTION" || -z "$USER" ]]; then
  # → -z checks if string is empty.
  # → || (OR) operator in conditional expression.
  usage
  # → Call usage() function if missing args.
fi

case "$ACTION" in
  # → case…esac: multi-branch selection based on user input.

  create)
    if id "$USER" &>/dev/null; then
      # → id command checks whether the user exists.
      # → &>/dev/null redirects both stdout & stderr to null (suppress output).
      echo "User '$USER' already exists."
      exit 0
    fi

    useradd -m -s /bin/bash "$USER"
    # → useradd command
    # → -m creates home directory
    # → -s sets default shell

    echo "User '$USER' created. Please set a password:"
    passwd "$USER"
    # → passwd prompts for password for the new user.
    ;;

  lock)
    if ! id "$USER" &>/dev/null; then
      # → ! negates condition (user does NOT exist)
      echo "User '$USER' does not exist."
      exit 1
    fi

    passwd -l "$USER"
    # → Lock account: disables password by adding '!' in /etc/shadow.
    echo "User '$USER' locked."
    ;;

  unlock)
    if ! id "$USER" &>/dev/null; then
      echo "User '$USER' does not exist."
      exit 1
    fi

    passwd -u "$USER"
    # → Unlock account: removes '!' from /etc/shadow.
    echo "User '$USER' unlocked."
    ;;

  delete)
    if ! id "$USER" &>/dev/null; then
      echo "User '$USER' does not exist."
      exit 1
    fi

    userdel -r "$USER"
    # → Deletes user + home directory (-r flag)
    echo "User '$USER' deleted (with home directory)."
    ;;

  *)
    # → Default case: runs if action is invalid.
    usage
    ;;
esac
# → End of case statement and script.


