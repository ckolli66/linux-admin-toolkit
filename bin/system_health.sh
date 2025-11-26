#!/usr/bin/bash

LOG_DIR="/opt/sys-admin-toolkit/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/system_health_$(date +%F).log"

{
  echo "===== System Health Check: $(date) ====="
  echo

  echo "[Uptime]"
  uptime
  echo

  echo "[Disk usage]"
  df -h
  echo

  echo "[Memory usage]"
  free -m
  echo

  echo "[Top 5 CPU-consuming processes]"
  ps aux --sort=-%cpu | head -n 6
  echo

 # echo "[Network interfaces]"
 # ip addr || ifconfig
 # echo

  echo "========================================"
  echo
} >> "$LOG_FILE"

