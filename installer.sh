#!/bin/bash
set -e
cd $(dirname $0)

git submodule update --init --recursive

sudo apt-get update
sudo apt-get install -y libudev-dev libusb-1.0-0-dev cmake pkg-config libhidapi-libusb0

BUILD_DIR=$(pwd)/build
HIDAPI_BUILD_DIR=$(pwd)/build/hidapi
HIDAPI_SOURCE_DIR=$(pwd)/contrib/hidapi

mkdir -p $HIDAPI_BUILD_DIR
cd $HIDAPI_BUILD_DIR
cmake $HIDAPI_SOURCE_DIR
cmake --build .
sudo cmake --build . --target install


cd $BUILD_DIR
cmake ..
make
sudo make install
