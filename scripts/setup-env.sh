#!/bin/bash
# HotspotOS Build Environment Setup
# Run this first on a fresh Ubuntu/Debian system

set -e

echo "=========================================="
echo "  HotspotOS Build Environment Setup"
echo "=========================================="

# Update system
echo "[1/5] Updating system packages..."
sudo apt-get update -qq

# Install build dependencies
echo "[2/5] Installing build dependencies..."
sudo apt-get install -y -qq \
    build-essential \
    clang \
    flex \
    bison \
    g++ \
    gawk \
    gcc-multilib \
    g++-multilib \
    gettext \
    git \
    libncurses5-dev \
    libssl-dev \
    python3 \
    python3-distutils \
    rsync \
    unzip \
    zlib1g-dev \
    file \
    wget \
    curl \
    subversion \
    libelf-dev \
    ecj \
    fastjar \
    java-propose-classpath \
    libncursesw5-dev \
    libpython3-dev \
    locales \
    qemu-utils \
    time \
    xsltproc \
    || true

# Set locale
echo "[3/5] Setting locale..."
sudo locale-gen en_US.UTF-8 || true
export LANG=en_US.UTF-8

# Create directories
echo "[4/5] Creating project directories..."
mkdir -p build dl bin

# Check disk space
echo "[5/5] Checking disk space..."
AVAILABLE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE" -lt "20" ]; then
    echo "WARNING: Less than 20GB free space available. Build may fail."
    echo "Available: ${AVAILABLE}GB"
else
    echo "Available space: ${AVAILABLE}GB - OK"
fi

echo ""
echo "=========================================="
echo "  Environment setup complete!"
echo "  Next step: make setup"
echo "=========================================="
