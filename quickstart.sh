#!/bin/bash
# HotspotOS Quick Start Script
# Run this after extracting the project

echo "=========================================="
echo "  HotspotOS v1.0.0 - Quick Start"
echo "=========================================="

# Check if we're in the right directory
if [ ! -f "Makefile" ] || [ ! -d "package" ]; then
    echo "ERROR: Please run this script from the hotspotos directory"
    exit 1
fi

echo ""
echo "Step 1: Initialize Git repository"
git init
git add .
git commit -m "HotspotOS v1.0.0 - Initial commit"

echo ""
echo "Step 2: Add GitHub remote"
echo "Run: git remote add origin https://github.com/YOUR_USERNAME/hotspotos-firmware.git"
echo "Then: git push -u origin main"

echo ""
echo "Step 3: Go to GitHub and trigger the build"
echo "  1. https://github.com/YOUR_USERNAME/hotspotos-firmware/actions"
echo "  2. Click 'Build HotspotOS Firmware'"
echo "  3. Click 'Run workflow'"

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
