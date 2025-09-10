ARG BUILD_FROM=ubuntu:22.04
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies (based on installer.sh)
RUN apt-get update && apt-get install -y \
    libudev-dev \
    libusb-1.0-0-dev \
    cmake \
    pkg-config \
    libhidapi-libusb0 \
    build-essential \
    git \
    usbutils \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src

# Copy source code
COPY . .

# Initialize git submodules and build HIDAPI (following installer.sh)
RUN git submodule update --init --recursive

# Build HIDAPI from source
RUN rm -rf build && \
    mkdir -p build/hidapi && \
    cd build/hidapi && \
    cmake ../../contrib/hidapi \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    cmake --build . && \
    cmake --build . --target install

# Build co2mon main project
RUN cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j$(nproc)

# Install binaries
RUN cp build/co2mond/co2mond /usr/local/bin/ && \
    chmod +x /usr/local/bin/co2mond

# Copy udev rules for device access
RUN mkdir -p /etc/udev/rules.d && \
    cp udevrules/99-co2mon.rules /etc/udev/rules.d/

# Copy startup script
COPY run.sh /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="CO2 Monitor" \
    io.hass.description="CO2 Monitor daemon for USB CO2 sensors" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Home Assistant Community Add-ons" \
    org.opencontainers.image.title="CO2 Monitor" \
    org.opencontainers.image.description="CO2 Monitor daemon for USB CO2 sensors" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Home Assistant Community Add-ons" \
    org.opencontainers.image.licenses="GPL-3.0" \
    org.opencontainers.image.url="https://github.com/dmage/co2mon" \
    org.opencontainers.image.source="https://github.com/dmage/co2mon"

CMD [ "/run.sh" ]