@echo off
set WSL_PATH=/mnt/d/sandbox/lite-dock
echo ==============================================
echo DEBUGGING SEARXNG IMAGE CONTENTS
echo ==============================================

echo Reading entrypoint.sh...
wsl -u root -e bash -c "cat /root/.litedock/images/searxng_searxng_latest/usr/local/searxng/entrypoint.sh"

pause
