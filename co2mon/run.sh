#!/bin/bash
# ==============================================================================
# Home Assistant Add-on: CO2 Monitor
# Runs the CO2 Monitor daemon
# ==============================================================================

# Temporarily disable exit-on-error for configuration parsing
set +e

# Source Home Assistant helper functions if available
DEVICE_PATH="auto"
if [ -f /usr/bin/bashio ]; then
    # Try to source bashio functions
    source /usr/bin/bashio 2>/dev/null
    # Try to get config, fallback to default if it fails
    DEVICE_PATH=$(bashio::config 'device_path' 2>/dev/null || echo "auto")
else
    # Fallback to environment variables or defaults
    DEVICE_PATH=${DEVICE_PATH:-"auto"}
fi

# Re-enable exit-on-error
set -e

echo "Starting CO2 Monitor daemon..."
echo "Device Path: ${DEVICE_PATH}"

# Build command arguments
ARGS=""

# Add device path if not auto
if [ "${DEVICE_PATH}" != "auto" ] && [ -n "${DEVICE_PATH}" ]; then
    ARGS="${ARGS} -f ${DEVICE_PATH}"
    echo "Using specific device path: ${DEVICE_PATH}"
fi

# Handle signals gracefully
cleanup() {
    echo "Received signal, shutting down CO2 Monitor daemon"
    if [ ! -z "$CO2MON_PID" ]; then
        kill -TERM "$CO2MON_PID" 2>/dev/null || true
        wait "$CO2MON_PID" 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT SIGHUP
trap '' PIPE

# Check for USB device
echo "Checking for CO2 sensor device..."
if command -v lsusb >/dev/null 2>&1; then
    if ! lsusb | grep -q "04d9:a052"; then
        echo "WARNING: CO2 sensor (04d9:a052) not found via lsusb"
        echo "Continuing anyway - device might still be accessible via hidraw"
    fi
else
    echo "lsusb not available, skipping USB device check"
fi

# List available hidraw devices for debugging
echo "Available hidraw devices:"
ls -la /dev/hidraw* 2>/dev/null || echo "No hidraw devices found"

# Start co2mond daemon
echo "Starting co2mond with arguments: ${ARGS}"
/usr/local/bin/co2mond ${ARGS} &
CO2MON_PID=$!

# Wait for the process to finish or receive a signal
wait "$CO2MON_PID"