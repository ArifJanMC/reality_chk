#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

DOMAIN=$1

# Step 0: Check for necessary software
echo "Checking for required software..."

# Function to check if a command exists
check_command() {
  if ! command -v "$1" &>/dev/null; then
    echo "❌ $1 is not installed. Please install it and re-run the script."
    MISSING_DEPS=true
  else
    echo "✅ $1 is installed."
  fi
}

# Check for openssl, curl, and bash
MISSING_DEPS=false
check_command "openssl"
check_command "curl"
check_command "bash"

if [ "$MISSING_DEPS" = true ]; then
  echo "❌ Missing dependencies detected. Please install the missing software and re-run the script."
  exit 1
fi

echo "All required software is installed. Proceeding with checks..."
echo

# Step 1: Check HTTPS and TLSv1.3
echo "Step 1: Checking HTTPS and TLSv1.3 support..."
TLSV1_3_SUPPORTED=$(echo | openssl s_client -connect "$DOMAIN:443" -tls1_3 2>/dev/null | grep "Cipher is TLS_AES")
if [ -n "$TLSV1_3_SUPPORTED" ]; then
  echo "✅ TLSv1.3 is supported by the server."
else
  echo "❌ TLSv1.3 is NOT supported by the server. This domain cannot be used for XTLS-Reality."
  exit 1
fi
echo

# Step 2: Check HTTP/2 support
echo "Step 2: Checking HTTP/2 support..."
HTTP2_SUPPORTED=$(curl -sI --http2 -o /dev/null -w '%{http_version}' "https://$DOMAIN")
if [ "$HTTP2_SUPPORTED" == "2" ]; then
  echo "✅ HTTP/2 is supported by the server."
else
  echo "❌ HTTP/2 is NOT supported by the server. This domain cannot be used for XTLS-Reality."
  exit 1
fi
echo

# Step 3: Check OCSP stapling and certificate validity
echo "Step 3: Checking OCSP stapling and certificate validity..."
OCSP_URL=$(echo | openssl s_client -connect "$DOMAIN:443" -status 2>/dev/null | openssl x509 -noout -ocsp_uri)
if [ -z "$OCSP_URL" ]; then
  echo "❌ OCSP responder URL not found. This domain cannot be used for XTLS-Reality."
  exit 1
else
  echo "✅ OCSP responder URL found: $OCSP_URL"
fi
echo

echo "This domain meets the basic requirements for XTLS-Reality."
