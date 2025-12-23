# 🔧 ESP-Hosted Firmware

Pre-built ESP-Hosted firmware binaries for Arduino boards.

## 📦 Supported Targets

| Target | ESP Chip | ESP-Hosted Version | ESP-IDF Version |
|--------|----------|-------------------|-----------------|
| portenta_c33 | ESP32-C3 | v1.0.0.0.0 | v5.4 |
| portenta_c33 | ESP32-C3 | v0.0.5 | v5.1 |

### CI/CD

The GitHub Actions workflow automatically builds firmware for all targets on:
- Push to `main` branch
- Pull requests to `main`
- Tag pushes (creates a release with binaries)

## 📁 Structure

```
├── tools/
│   └── combine.py
└── <target>/
    │
    ├── patches/
    │      └── <version>/
    │          └── *.patch
    └── sdkconfig.defaults.<chip>
```

## 🚀 Flashing

```bash
espflash write-bin 0x0 <target>-<version>.bin
```

Or with esptool:

```bash
esptool.py --chip esp32c3 -p /dev/ttyACM0 -b 230400 \
  --before=default_reset --after=hard_reset --no-stub \
  write_flash --flash_mode dio --flash_freq 80m 0x0 <target>-<version>.bin
```
