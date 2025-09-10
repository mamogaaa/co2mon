#!/bin/bash
set -e

echo "DEBUG: Starting uninstaller script..."
echo "DEBUG: Current directory: $(pwd)"

cd $(dirname $0)
echo "DEBUG: Changed to script directory: $(pwd)"

echo "DEBUG: Stopping co2mond service..."
sudo systemctl stop co2mond || true
echo "DEBUG: co2mond service stopped"

echo "DEBUG: Disabling co2mond service..."
sudo systemctl disable co2mond || true
echo "DEBUG: co2mond service disabled"

echo "DEBUG: Removing systemd service file..."
sudo rm -f /etc/systemd/system/co2mond.service
echo "DEBUG: Service file removed"

echo "DEBUG: Reloading systemd daemon..."
sudo systemctl daemon-reload
echo "DEBUG: Systemd daemon reloaded"

echo "DEBUG: Removing co2mond binary..."
sudo rm -f /usr/local/bin/co2mond
echo "DEBUG: co2mond binary removed"

echo "DEBUG: Removing start_co2mond script..."
sudo rm -f /usr/local/bin/start_co2mond
echo "DEBUG: start_co2mond script removed"

echo "DEBUG: Removing build directory..."
rm -rf ./build
echo "DEBUG: Build directory removed"

echo "DEBUG: Uninstalling HIDAPI (if installed via cmake)..."
# Note: This will attempt to uninstall HIDAPI, but may not work if it was installed differently
sudo rm -f /usr/local/lib/libhidapi* || true
sudo rm -f /usr/local/include/hidapi* || true
sudo rm -rf /usr/local/lib/pkgconfig/hidapi* || true
echo "DEBUG: HIDAPI files removed (manual cleanup may be needed)"

echo "WARNING: The following packages were installed but will NOT be removed:"
echo "  - libudev-dev"
echo "  - libusb-1.0-0-dev" 
echo "  - cmake"
echo "  - pkg-config"
echo "  - libhidapi-libusb0"
echo "If you want to remove these packages, run:"
echo "  sudo apt-get remove libudev-dev libusb-1.0-0-dev cmake pkg-config libhidapi-libusb0"
echo "  sudo apt-get autoremove"

echo "DEBUG: Uninstallation completed successfully!"