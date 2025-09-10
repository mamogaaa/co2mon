# Home Assistant Add-on: CO2 Monitor

## About

This Home Assistant add-on runs the CO2 Monitor daemon to read data from USB CO2 sensors compatible with the TFA AIRCO2NTROL MINI and similar devices.

The add-on provides CO2 monitoring capabilities by interfacing directly with USB CO2 sensors that identify as:
- Vendor ID: 0x04d9 (Holtek Semiconductor, Inc.)
- Product ID: 0xa052 (USB-zyTemp)

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "CO2 Monitor" add-on
3. Connect your USB CO2 sensor to your Home Assistant device
4. Start the add-on

## Configuration

```yaml
device_path: "auto"
```

### Option: `device_path`

The device path for your CO2 sensor. Use "auto" for automatic detection, or specify a specific path like "/dev/hidraw0" if needed.

## Hardware Requirements

- USB CO2 sensor compatible with TFA AIRCO2NTROL MINI
- USB port available on your Home Assistant device
- Proper USB device permissions (handled automatically by the add-on)

## Supported Devices

- TFA AIRCO2NTROL MINI CO2 Monitor (EAN 4009816027351)
- Other compatible USB CO2 sensors with VID:PID 04d9:a052

## Troubleshooting

1. **Device not found**: Ensure your CO2 sensor is properly connected and recognized by the system
2. **Permission issues**: The add-on runs with the necessary privileges to access HID devices
3. **Multiple devices**: If you have multiple hidraw devices, you may need to specify the exact device path

## Support

For issues specific to this add-on, please check the Home Assistant community forums.
For issues with the underlying CO2 monitor software, see: https://github.com/dmage/co2mon