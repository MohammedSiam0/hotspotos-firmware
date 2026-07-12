#!/bin/bash
# Rename firmware images to HotspotOS branding

VERSION="${1:-1.0.0}"
OUTPUT_DIR="${2:-$(pwd)/bin}"

cd "${OUTPUT_DIR}"

for f in *.bin *.img; do
    [ -f "$f" ] || continue
    if echo "$f" | grep -q "openwrt"; then
        newname=$(echo "$f" | sed "s/openwrt/hotspotos-v${VERSION}/g")
        mv "$f" "$newname"
        echo "Renamed: $f -> $newname"
    fi
done

echo "Image renaming complete."
