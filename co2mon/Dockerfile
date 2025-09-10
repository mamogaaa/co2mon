ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# Install dependencies using apk (Alpine Linux)
RUN apk add --no-cache \
    eudev-dev \
    libusb-dev \
    cmake \
    pkgconfig \
    hidapi-dev \
    build-base \
    git \
    usbutils \
    bash \
    nginx

# Set working directory
WORKDIR /usr/src

# Copy source code
COPY . .

# Copy web interface
COPY index.html /usr/src/index.html

# Since hidapi-dev package is available, we don't need git submodules

# Build co2mon main project
RUN mkdir -p build && \
    cd build && \
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

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

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