# XTLS-Reality Compatibility Checker

A simple Bash script to check if a domain meets the basic requirements for **XTLS-Reality**. It verifies:

- **TLSv1.3** support.
- **HTTP/2 (H2)** support.
- **OCSP stapling** and certificate validity.

This tool is ideal for ensuring that a domain can be used with XTLS-Reality configurations.

---

## Features

1. **TLSv1.3 Check:** Ensures the server supports the modern TLS protocol.
2. **HTTP/2 Check:** Verifies HTTP/2 (H2) support, required for optimal performance.
3. **OCSP Stapling Check:** Confirms the presence of OCSP stapling and validates the certificate.

---

## Requirements

The script depends on the following tools:
- **Bash**
- **OpenSSL (1.1.1 or higher)** for TLS and OCSP checks.
- **Curl** for HTTP/2 detection.

---

## Quick Start

Run the script directly without downloading:
```bash
bash <(curl -s https://raw.githubusercontent.com/ArifJanMC/reality_chk/main/reality_chk.sh)
```

## Installation

### 1. Install Required Software

#### Debian/Ubuntu:
```bash
sudo apt update
sudo apt install -y openssl curl bash
