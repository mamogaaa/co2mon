#!/bin/bash
# Simple script to run CO2 Monitor Docker container interactively

# Unset proxy variables to avoid connection issues
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

IMAGE_NAME="co2mon-addon"
PORT="8989"

# Build the Docker image first
echo "Building Docker image: ${IMAGE_NAME}"
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY && docker build -t ${IMAGE_NAME} .

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
    -p ${PORT}:8080 \
    -e PROMETHEUS_PORT=8080 \
    -e DATA_DIR=/data \
    -e LOG_LEVEL=info \
    -e PRINT_UNKNOWN=false \
    ${IMAGE_NAME} /run.sh
