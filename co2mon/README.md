# Home Assistant Add-on: CO2 Monitor

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

CO2 Monitor daemon for USB CO2 sensors compatible with TFA AIRCO2NTROL MINI and similar devices.

## About

This add-on runs the CO2 Monitor daemon to read data from USB CO2 sensors that identify as Holtek Semiconductor USB-zyTemp devices (VID:PID 04d9:a052).

## Installation

1. Add this repository to your Home Assistant: `https://github.com/nordikafiles/co2mon`
2. Install the "CO2 Monitor" add-on
3. Connect your USB CO2 sensor
4. Start the add-on

## Configuration

```yaml
device_path: "auto"
```

### Option: `device_path` (required)

The device path for your CO2 sensor. Use "auto" for automatic detection, or specify a path like "/dev/hidraw0".

## Hardware Requirements

- USB CO2 sensor compatible with TFA AIRCO2NTROL MINI
- USB port on Home Assistant device

## Support

- [GitHub Repository][github]
- [Community Forum][forum]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[github]: https://github.com/nordikafiles/co2mon
[forum]: https://community.home-assistant.io