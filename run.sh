#!/bin/bash
# ==============================================================================
# Home Assistant Add-on: CO2 Monitor
# Runs the CO2 Monitor daemon
# ==============================================================================

set -e

# Source Home Assistant helper functions if available
if [ -f /usr/bin/bashio ]; then
    source /usr/bin/bashio
    # Parse configuration using bashio
    PROMETHEUS_PORT=$(bashio::config 'prometheus_port' 2>/dev/null || echo "8080")
    DATA_DIR=$(bashio::config 'data_dir' 2>/dev/null || echo "/data")
    LOG_LEVEL=$(bashio::config 'log_level' 2>/dev/null || echo "info")
    PRINT_UNKNOWN=$(bashio::config 'print_unknown' 2>/dev/null || echo "false")
    DEVICE_PATH=$(bashio::config 'device_path' 2>/dev/null || echo "")
else
    # Fallback to environment variables or defaults
    PROMETHEUS_PORT=${PROMETHEUS_PORT:-8080}
    DATA_DIR=${DATA_DIR:-"/data"}
    LOG_LEVEL=${LOG_LEVEL:-"info"}
    PRINT_UNKNOWN=${PRINT_UNKNOWN:-"false"}
    DEVICE_PATH=${DEVICE_PATH:-""}
fi

echo "Starting CO2 Monitor daemon..."
echo "Prometheus port: ${PROMETHEUS_PORT}"
echo "Data directory: ${DATA_DIR}"
echo "Log level: ${LOG_LEVEL}"

# Ensure data directory exists
mkdir -p "${DATA_DIR}"

# Build command arguments (no -d flag for containers)
ARGS="-P 0.0.0.0:${PROMETHEUS_PORT} -D ${DATA_DIR}"

# Add optional arguments
if [ "${PRINT_UNKNOWN}" = "true" ]; then
    ARGS="${ARGS} -u"
    echo "Unknown values printing enabled"
fi

if [ -n "${DEVICE_PATH}" ]; then
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