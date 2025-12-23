# 🔧 ESP-Hosted Firmware

Pre-built ESP-Hosted firmware binaries for Arduino boards.

## 📦 Supported Targets

| Target | ESP Chip | ESP-Hosted Version | ESP-IDF Version |
|--------|----------|-------------------|-----------------|
| portenta_c33 | ESP32-C3 | v1.0.0.0.0 | v5.4 |
| portenta_c33 | ESP32-C3 | v0.0.5 | v5.1 |

## 🏗️ Building

### Local Build

```bash
./build.sh
```

### CI/CD

The GitHub Actions workflow automatically builds firmware for all targets on:
- Push to `main` branch
- Pull requests to `main`
- Tag pushes (creates a release with binaries)

## 📁 Structure

```
├── <target>/
│   ├── sdkconfig.defaults.<chip>
│   └── patches/
│       └── <version>/
│           └── *.patch
├── tools/
│   └── combine.py
└── build.sh
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
