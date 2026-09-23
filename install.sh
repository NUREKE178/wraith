#!/bin/bash
# WRAITH installer by nu4lan
set -e
BIN="/usr/local/bin/wraith"
REPO_URL="https://github.com/NUREKE178/wraith/raw/main/wraith"
if [ -x "${BIN}" ]; then
  echo "[=] WRAITH already installed at ${BIN}"
  echo "    run: sudo wraith"
  echo "    force reinstall: wget -qO- https://github.com/NUREKE178/wraith/raw/main/install.sh | sudo bash -s -- --force"
  [ "${1:-}" = "--force" ] || exit 0
fi
command -v wget >/dev/null || { echo "[x] wget missing"; exit 1; }
echo "[*] downloading WRAITH binary..."
wget -qO /tmp/wraith "${REPO_URL}" || { echo "[x] download failed"; exit 1; }
chmod +x /tmp/wraith
if ! command -v aircrack-ng >/dev/null 2>&1; then
  echo "[*] installing tools (aircrack-ng hcxtools hashcat screen)..."
  sudo apt update -qq && sudo apt install -y -qq aircrack-ng hcxtools hashcat screen >/dev/null
fi
sudo mv /tmp/wraith "${BIN}"
echo "[+] WRAITH installed. Run:  sudo wraith"
