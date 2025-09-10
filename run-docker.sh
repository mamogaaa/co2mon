#!/bin/bash
# Simple script to run CO2 Monitor Docker container interactively

# Exit on any error
set -e

# Unset proxy variables to avoid connection issues
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

IMAGE_NAME="co2mon-addon"
HOST_PORT="8989"
CONTAINER_PORT="8080"

# Build the Docker image first from co2mon subdirectory
echo "Building Docker image: ${IMAGE_NAME}"
cd co2mon
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY && docker build -t ${IMAGE_NAME} .
cd ..

# Build device arguments for CO2 sensor
DEVICE_ARGS=""
if ls /dev/hidraw* >/dev/null 2>&1; then
    for device in /dev/hidraw*; do
        DEVICE_ARGS="$DEVICE_ARGS --device=$device"
    done
fi
DEVICE_ARGS="$DEVICE_ARGS --device=/dev/bus/usb"

# Run the container interactively in foreground
docker run -it --rm \
    --privileged \
    ${DEVICE_ARGS} \
    -p ${HOST_PORT}:${CONTAINER_PORT} \
    -e PROMETHEUS_PORT=8080 \
    -e DATA_DIR=/data \
    -e LOG_LEVEL=info \
    -e PRINT_UNKNOWN=false \
    ${IMAGE_NAME} /run.sh
