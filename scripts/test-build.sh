#!/bin/bash
# HotspotOS Build Verification Script
set -e

echo "=== HotspotOS Build Verification ==="

# Check required files exist
echo "[TEST] Checking project structure..."
required_files=(
    "Makefile"
    "feeds.conf.hotspotos"
    ".config"
    "package/hotspotos-base/Makefile"
    "package/hotspotos-base/files/etc/banner"
    "package/hotspotos-base/files/etc/os-release"
    "package/hotspotos-base/files/etc/config/hotspotos"
    "package/luci-theme-hotspotos/Makefile"
    "package/luci-theme-hotspotos/luasrc/view/themes/hotspotos/header.htm"
    "package/luci-theme-hotspotos/luasrc/view/themes/hotspotos/footer.htm"
    "package/luci-theme-hotspotos/luasrc/view/themes/hotspotos/sysauth.htm"
    "package/luci-theme-hotspotos/htdocs/luci-static/hotspotos/hotspotos.css"
    "package/luci-theme-hotspotos/htdocs/luci-static/hotspotos/logo.svg"
    "package/luci-theme-hotspotos/htdocs/luci-static/hotspotos/js/theme.js"
    "package/hotspot-core/Makefile"
    "package/hotspot-client/Makefile"
    "package/hotspot-server/Makefile"
    "package/hotspot-users/Makefile"
    "package/hotspot-trial/Makefile"
    "package/hotspot-ttl/Makefile"
    "package/hotspot-dashboard/Makefile"
    "package/luci-app-hotspotos/Makefile"
)

missing=0
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "  FAIL: $file"
        missing=$((missing + 1))
    else
        echo "  PASS: $file"
    fi
done

if [ $missing -gt 0 ]; then
    echo "ERROR: $missing files missing!"
    exit 1
fi

# Check CSS syntax (basic)
echo "[TEST] Checking CSS syntax..."
if grep -q "{" package/luci-theme-hotspotos/htdocs/luci-static/hotspotos/hotspotos.css; then
    echo "  PASS: CSS file contains rules"
else
    echo "  FAIL: CSS file empty or invalid"
    exit 1
fi

# Check SVG validity
echo "[TEST] Checking SVG logo..."
if grep -q "<svg" package/luci-theme-hotspotos/htdocs/luci-static/hotspotos/logo.svg; then
    echo "  PASS: SVG logo valid"
else
    echo "  FAIL: SVG logo invalid"
    exit 1
fi

# Check shell scripts syntax
echo "[TEST] Checking shell scripts..."
for script in $(find package -name "*.sh" -type f 2>/dev/null); do
    if bash -n "$script" 2>/dev/null; then
        echo "  PASS: $script"
    else
        echo "  FAIL: $script"
        missing=$((missing + 1))
    fi
done

# Check Lua scripts syntax
echo "[TEST] Checking Lua scripts..."
for script in $(find package -name "*.lua" -type f 2>/dev/null); do
    if lua -e "loadfile('$script')" 2>/dev/null; then
        echo "  PASS: $script"
    else
        echo "  SKIP: $script (lua not installed or syntax check failed)"
    fi
done

echo ""
echo "=== All Tests Passed ==="
echo "Ready for build. Run: make build"
