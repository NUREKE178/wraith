#!/bin/bash
# WRAITH installer by nu4lan
set -e
command -v wget >/dev/null || { echo "[x] wget missing"; exit 1; }
echo "[*] downloading WRAITH binary..."
wget -qO /tmp/wraith "https://github.com/NUREKE178/wraith/raw/main/wraith" || { echo "[x] download failed"; exit 1; }
chmod +x /tmp/wraith
if ! command -v aircrack-ng >/dev/null 2>&1; then
  echo "[*] installing tools (aircrack-ng hcxtools hashcat screen)..."
  sudo apt update -qq
  sudo apt install -y -qq aircrack-ng hcxtools hashcat screen >/dev/null
fi
sudo mv /tmp/wraith /usr/local/bin/wraith
echo "[+] WRAITH installed. Run:  sudo wraith"
