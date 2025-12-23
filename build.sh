#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Introduced protocol important changes to protocol (connect events)
# 0e980d8e0f53ff8e6416af1b134bbc5daf3feb40
# 81bb7dd is quite interesting, shows where all fixes to host stuff are made.

# NOTE: There's a setup-idf.sh
ESP_HOSTED_REF="release/fg-1.0.0.0.0"
ESP_IDF_REF="release/v5.4"

# Clone esp-hosted if not present
if [ ! -d "esp-hosted" ]; then
    echo "Cloning esp-hosted..."
    git clone https://github.com/espressif/esp-hosted.git --recursive
fi

# Clone esp-idf if not present
if [ ! -d "esp-idf" ]; then
    echo "Cloning esp-idf..."
    git clone --branch "$ESP_IDF_REF" --depth 1 --recursive https://github.com/espressif/esp-idf.git
fi

cd esp-hosted

# Checkout specific commit
echo "Checking out commit $ESP_HOSTED_REF..."

# TODO remove if moved to CI
git checkout .
git checkout "$ESP_HOSTED_REF"

# Apply patch
echo "Applying patch..."
patch -p1 < ../0001-Defaults-for-C33-BLE.patch

cd esp_hosted_fg/esp/esp_driver

# Setup esp-idf
echo "Setting up ESP-IDF..."
export IDF_PATH="$SCRIPT_DIR/esp-idf"
"$IDF_PATH/install.sh" esp32c3
source "$IDF_PATH/export.sh"

cd network_adapter

# Set target
echo "Configuring for ESP32-C3..."
idf.py set-target esp32c3

# Copy our custom defaults and regenerate sdkconfig
echo "Applying custom defaults..."
cp "$SCRIPT_DIR/sdkconfig.defaults.esp32c3" sdkconfig.defaults.esp32c3
rm -f sdkconfig

# Build (will regenerate sdkconfig from defaults)
echo "Building firmware..."
idf.py build

# Combine binaries
cd "$SCRIPT_DIR"
echo "Combining binaries..."
python3 combine.py

echo ""
echo "Build complete! Output: ESP32-C3.bin"
echo ""
echo "To flash the firmware:"
echo "  espflash write-bin 0x0 ESP32-C3.bin"
echo "or:"
echo "  esptool.py --chip esp32c3 -p /dev/ttyACM0 -b 230400 --before=default_reset --after=hard_reset --no-stub write_flash --flash_mode dio --flash_freq 80m 0x0 ESP32-C3.bin"
