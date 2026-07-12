#!/bin/bash
# HotspotOS Build Script
set -e

HOTSPOTOS_VERSION="1.0.0"
OPENWRT_VERSION="23.05.6"
TARGET="lantiq"
SUBTARGET="xrx200"
BUILD_DIR="$(pwd)/build"
OUTPUT_DIR="$(pwd)/bin"
DL_DIR="$(pwd)/dl"

echo "=========================================="
echo "  HotspotOS v${HOTSPOTOS_VERSION} Build System"
echo "  Target: ${TARGET}/${SUBTARGET}"
echo "  Base: OpenWrt ${OPENWRT_VERSION}"
echo "=========================================="

# Create directories
mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}" "${DL_DIR}"

# Clone OpenWrt if not exists
if [ ! -d "${BUILD_DIR}/openwrt" ]; then
    echo "[1/6] Cloning OpenWrt ${OPENWRT_VERSION}..."
    git clone --depth 1 --branch "v${OPENWRT_VERSION}" \
        https://git.openwrt.org/openwrt/openwrt.git \
        "${BUILD_DIR}/openwrt"
fi

cd "${BUILD_DIR}/openwrt"

# Update and install feeds
echo "[2/6] Updating feeds..."
cp ../../feeds.conf.hotspotos feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a

# Copy HotspotOS packages
echo "[3/6] Installing HotspotOS packages..."
cp -r ../../package/* package/ 2>/dev/null || true

# Apply configuration
echo "[4/6] Applying configuration..."
cp ../../.config .config
make defconfig

# Download sources
echo "[5/6] Downloading sources..."
make download -j$(nproc)

# Build firmware
echo "[6/6] Building firmware..."
make -j$(nproc) V=s 2>&1 | tee "${OUTPUT_DIR}/build.log"

# Copy output
echo "[Done] Copying firmware images..."
mkdir -p "${OUTPUT_DIR}/packages"
cp "bin/targets/${TARGET}/${SUBTARGET}"/*.bin "${OUTPUT_DIR}/" 2>/dev/null || true
cp "bin/targets/${TARGET}/${SUBTARGET}"/*.img "${OUTPUT_DIR}/" 2>/dev/null || true
cp "bin/targets/${TARGET}/${SUBTARGET}"/sha256sums "${OUTPUT_DIR}/" 2>/dev/null || true
cp bin/packages/*/hotspotos/*.ipk "${OUTPUT_DIR}/packages/" 2>/dev/null || true

# Rename images
echo "[Done] Renaming images..."
for f in "${OUTPUT_DIR}"/*.bin; do
    [ -f "$f" ] || continue
    basename=$(basename "$f")
    newname=$(echo "$basename" | sed "s/openwrt/hotspotos-v${HOTSPOTOS_VERSION}/g")
    mv "$f" "${OUTPUT_DIR}/${newname}"
done

for f in "${OUTPUT_DIR}"/*.img; do
    [ -f "$f" ] || continue
    basename=$(basename "$f")
    newname=$(echo "$basename" | sed "s/openwrt/hotspotos-v${HOTSPOTOS_VERSION}/g")
    mv "$f" "${OUTPUT_DIR}/${newname}"
done

echo ""
echo "=========================================="
echo "  Build Complete!"
echo "  Output: ${OUTPUT_DIR}"
echo "=========================================="
ls -lh "${OUTPUT_DIR}/"
