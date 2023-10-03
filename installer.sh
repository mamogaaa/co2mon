#!/bin/bash
set -e
cd $(dirname $0)

git submodule update --init --recursive

sudo apt-get update
sudo apt-get install -y libudev-dev libusb-1.0-0-dev cmake pkg-config libhidapi-libusb0

SOURCE_DIR=$(pwd)
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

sudo cp $SOURCE_DIR/start_co2mond /usr/local/bin/start_co2mond
sudo cp $SOURCE_DIR/co2mond.service /etc/systemd/system/co2mond.service
sudo chmod 664 /etc/systemd/system/co2mond.service
sudo systemctl daemon-reload
sudo systemctl start co2mond
