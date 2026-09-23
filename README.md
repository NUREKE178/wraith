# WRAITH

Silent WiFi security audit tool for your own networks.

Passive-first wireless auditing: it listens, escalates only when you allow it, and never touches your own connection.

$ sudo wraith

██╗    ██╗██████╗  █████╗ ██╗████████╗██╗  ██╗
██║    ██║██╔══██╗██╔══██╗██║╚══██╔══╝██║  ██║
██║ █╗ ██║██████╔╝███████║██║   ██║   ███████║
██║███╗██║██╔══██╗██╔══██║██║   ██║   ██╔══██║
╚███╔███╔╝██║  ██║██║  ██║██║   ██║   ██║  ██║
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝
   silent wifi recon ═ passive-first ═ GPU crack ═ v1.6 ═ by nu4lan

## Install

wget -qO- https://github.com/NUREKE178/wraith/raw/main/install.sh | sudo bash

Requirements: Ubuntu / Kali, x86-64. Tools (aircrack-ng, hcxtools, hashcat, screen)
are installed automatically if missing. An NVIDIA GPU makes cracking dramatically
faster but is not required.

## Usage

sudo wraith            # interactive
sudo wraith --help     # full manual

## Modes

1  AUTO SMART    passive 5 min, then gentle single-client nudge, then deauth
                 bursts - each stage only with your consent
2  PURE PASSIVE  30 min of pure listening, sends nothing, catches natural joins
3  ACTIVE        immediate deauth rounds - fast, louder
4  PMKID         clientless "door knock", needs an external adapter
                 (AR9271 / RT3070 / RTL8812AU)

## How it works

1. Scan     lists nearby networks with signal bars and security mode.
            Your own WiFi stays connected the whole time.
2. Capture  waits for a WPA handshake; escalation only if you allowed it.
3. Gate     incomplete handshakes (M1-M4 check) are rejected - no fake cracks.
4. Crack    hashcat on GPU: wordlist, best64 rules, digit masks, live progress.
5. Report   passwords land in ~/wifi-hunter-found.txt, hashes kept in
            /tmp/ultimate-*/ for later reuse.

## Notes

- Ctrl+C exits cleanly at any point: children killed, monitor interface
  removed, terminal left looking untouched
- Runs survive a closed terminal window (screen session): detach with
  Ctrl+A then D, re-attach with sudo wraith
- Handshakes only exist when a device connects/reconnects - patience or a
  consenting client is part of the job
- External pentest adapters (0cf3:9271 / 148f:3070 / 0bda:8812) are detected
  automatically and unlock PMKID mode

## Legal

Use only on networks you own or have explicit written permission to test.
Unauthorized access to computer networks is a crime.
The author is not responsible for misuse.

---

nu4lan
EOF
head -5 ~/README.md
