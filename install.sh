#!/bin/bash
# WRAITH installer by nu4lan
set -e

BIN="/usr/local/bin/wraith"
REPO="NUREKE178/wraith"
BRANCH="main"

# already installed? (binary contains WRAITH banner string)
if [ -x "${BIN}" ] && grep -q "WRAITH" "${BIN}" 2>/dev/null; then
  echo "[=] WRAITH already installed at ${BIN}"
  echo "    run: sudo wraith"
  if [ "${FORCE:-0}" != "1" ]; then exit 0; fi
  echo "[*] FORCE=1 - reinstalling..."
fi

command -v curl >/dev/null || command -v wget >/dev/null || { echo "[x] need curl or wget"; exit 1; }
echo "[*] downloading WRAITH release (tarball via codeload)..."

mkdir -p /tmp/wraith-install && cd /tmp/wraith-install
if command -v curl >/dev/null 2>&1; then
  curl -4 -sL "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}" -o repo.tgz || { echo "[x] download failed"; exit 1; }
else
  wget -4 -qO repo.tgz "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}" || { echo "[x] download failed"; exit 1; }
fi
[ -s repo.tgz ] || { echo "[x] empty download"; exit 1; }

tar xzf repo.tgz
find . -name wraith -type f | grep -q . || { echo "[x] wraith binary not in tarball"; exit 1; }
BINPATH=$(find . -name wraith -type f | head -n1)
chmod +x "${BINPATH}"

if ! command -v aircrack-ng >/dev/null 2>&1; then
  echo "[*] installing tools (aircrack-ng hcxtools hashcat screen)..."
  if command -v apt >/dev/null 2>&1; then apt update -qq && apt install -y -qq aircrack-ng hcxtools hashcat screen >/dev/null
  elif command -v dnf >/dev/null 2>&1; then dnf install -y -q aircrack-ng hcxtools hashcat screen
  elif command -v pacman >/dev/null 2>&1; then pacman -Sy --noconfirm aircrack-ng hcxtools hashcat screen >/dev/null
  fi
fi

mv "${BINPATH}" "${BIN}"
echo "[+] WRAITH installed. Run:  sudo wraith"
