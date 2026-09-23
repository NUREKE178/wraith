cat > /tmp/install.sh << 'EOF'
#!/bin/bash
# WRAITH installer by nu4lan
set -e

REPO_URL="https://github.com/NUREKE178/wraith/raw/main/wraith"
BIN="/usr/local/bin/wraith"

# already installed and runnable?
if [ -x "${BIN}" ] && "${BIN}" --help >/dev/null 2>&1; then
  echo "[=] WRAITH already installed (${BIN})"
  echo "    run it now:      sudo wraith"
  echo "    force reinstall: wget -qO- https://github.com/NUREKE178/wraith/raw/main/install.sh | sudo bash -s -- --force"
  exit 0
fi

command -v wget >/dev/null || { echo "[x] wget missing"; exit 1; }
echo "[*] downloading WRAITH binary..."
wget -qO /tmp/wraith "${REPO_URL}" || { echo "[x] download failed"; exit 1; }
chmod +x /tmp/wraith

if ! command -v aircrack-ng >/dev/null 2>&1; then
  echo "[*] installing tools (aircrack-ng hcxtools hashcat screen)..."
  sudo apt update -qq
  sudo apt install -y -qq aircrack-ng hcxtools hashcat screen >/dev/null
fi

sudo mv /tmp/wraith "${BIN}"
echo "[+] WRAITH installed. Run:  sudo wraith"
EOF
bash -n /tmp/install.sh && echo READY
