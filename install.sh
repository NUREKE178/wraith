#!/bin/bash
# WRAITH installer by nu4lan
set -e

BIN="/usr/local/bin/wraith"
REPO="NUREKE178/wraith"
BRANCH="main"
WORKDIR="/tmp/wraith-install"

# clean up temp workdir on exit (success or failure)
cleanup() { rm -rf "${WORKDIR}"; }
trap cleanup EXIT

# must be root: we install into /usr/local/bin and (optionally) system packages
if [ "$(id -u)" != "0" ]; then
  echo "[x] run as root:  wget -qO- https://github.com/${REPO}/raw/${BRANCH}/install.sh | sudo bash"
  exit 1
fi

# already installed? (the managed binary already exists and is executable)
if [ -x "${BIN}" ]; then
  echo "[=] WRAITH already installed at ${BIN}"
  echo "    run: sudo wraith"
  if [ "${FORCE:-0}" != "1" ]; then exit 0; fi
  echo "[*] FORCE=1 - reinstalling..."
fi

command -v curl >/dev/null || command -v wget >/dev/null || { echo "[x] need curl or wget"; exit 1; }
echo "[*] downloading WRAITH release (tarball via codeload)..."

# start from a clean workdir so stale files can't be picked up later
rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}" && cd "${WORKDIR}"
if command -v curl >/dev/null 2>&1; then
  curl -4 -fsSL "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}" -o repo.tgz || { echo "[x] download failed"; exit 1; }
else
  wget -4 -qO repo.tgz "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}" || { echo "[x] download failed"; exit 1; }
fi
[ -s repo.tgz ] || { echo "[x] empty download"; exit 1; }

tar xzf repo.tgz || { echo "[x] bad tarball (not a gzip archive?)"; exit 1; }
BINPATH=$(find . -name wraith -type f | head -n1)
[ -n "${BINPATH}" ] || { echo "[x] wraith binary not in tarball"; exit 1; }
chmod +x "${BINPATH}"

# install missing audit tools; a failure here must not abort the whole install
for tool in aircrack-ng hcxtools hashcat screen; do
  command -v "$tool" >/dev/null 2>&1 || MISSING=1
done
if [ "${MISSING:-0}" = "1" ]; then
  echo "[*] installing tools (aircrack-ng hcxtools hashcat screen)..."
  if command -v apt >/dev/null 2>&1; then apt update -qq && apt install -y -qq aircrack-ng hcxtools hashcat screen >/dev/null || echo "[!] tool install had errors - continuing"
  elif command -v dnf >/dev/null 2>&1; then dnf install -y -q aircrack-ng hcxtools hashcat screen || echo "[!] tool install had errors - continuing"
  elif command -v pacman >/dev/null 2>&1; then pacman -Sy --noconfirm aircrack-ng hcxtools hashcat screen >/dev/null || echo "[!] tool install had errors - continuing"
  else echo "[!] no supported package manager - install aircrack-ng hcxtools hashcat screen manually"
  fi
fi

mkdir -p "$(dirname "${BIN}")"
mv "${BINPATH}" "${BIN}"
echo "[+] WRAITH installed. Run:  sudo wraith"
