#!/usr/bin/bash
# → Shebang: tells the system to execute this script using /usr/bin/bash

LOG_DIR="/opt/sys-admin-toolkit/logs" 
# → Variable assignment + double quotes (to preserve literal string)

mkdir -p "$LOG_DIR"
# → mkdir command + -p option (create directory if not exists)
# → Variable expansion "$LOG_DIR"
# → Quoting to handle spaces safely

LOG_FILE="$LOG_DIR/system_health_$(date +%F).log"
# → Variable assignment
# → Command substitution $(date +%F) to dynamically generate filename
# → String concatenation in shell variable

{
  # → Start of a command group block ({}). All output will be redirected together.

  echo "===== System Health Check: $(date) ====="
  # → echo command
  # → Command substitution to print current date/time

  echo
  # → echo to print a blank line

  echo "[Uptime]"
  # → Section header text

  uptime
  # → uptime command to show system running time and load average

  echo
  # → blank line

  echo "[Disk usage]"
  # → Section header

  df -h
  # → df command + -h (human readable) to show disk usage

  echo
  # → blank line

  echo "[Memory usage]"
  # → Section header

  free -m
  # → free command + -m to show memory usage in MB

  echo
  # → blank line

  echo "[Top 5 CPU-consuming processes]"
  # → Section header

  ps aux --sort=-%cpu | head -n 6
  # → ps command with aux flags (list all processes)
  # → Sort using --sort=-%cpu (descending order)
  # → Pipe (|) to head to take first 6 lines (header + top 5 processes)

  echo
  # → blank line

 # echo "[Network interfaces]"
 # → Commented-out code (shell comment using #)
 # ip addr || ifconfig
 # → ip addr command OR ifconfig (|| logical OR operator)
 # echo
 # → blank line

  echo "========================================"
  # → Echo footer line

  echo
  # → blank line
} >> "$LOG_FILE"
# → End of command group
# → Redirection operator >> to append all grouped output into log file
# → Variable expansion "$LOG_FILE" for log path
