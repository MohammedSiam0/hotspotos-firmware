# HotspotOS v1.0.0

Professional Hotspot Management Firmware based on OpenWrt 23.05

## Target
- **Platform**: lantiq/xrx200
- **Base**: OpenWrt 23.05.6

## Features
- Custom branding and theme
- Internet Client (Auto-login, Auto-reconnect)
- Hotspot Server (Captive Portal with nftables)
- User Manager (Time/Speed/Device limits)
- Free Trial System (Per-MAC, Daily reset)
- TTL Manager (ISP bypass)
- Status Dashboard
- LuCI Web Interface

## Quick Start

```bash
# 1. Setup build environment
sudo ./scripts/setup-env.sh

# 2. Build firmware
make build

# 3. Flash to device
make flash
```

## Project Structure
```
hotspotos/
├── Makefile              # Root build orchestration
├── .config               # OpenWrt configuration
├── feeds.conf.hotspotos  # Package feeds
├── package/              # Custom packages
│   ├── hotspotos-base/   # System branding
│   ├── luci-theme-hotspotos/  # Custom theme
│   ├── hotspot-core/     # Database & core services
│   ├── hotspot-client/   # Internet client
│   ├── hotspot-server/   # Captive portal
│   ├── hotspot-users/    # User management
│   ├── hotspot-trial/    # Free trial
│   ├── hotspot-ttl/      # TTL manager
│   ├── hotspot-dashboard/ # Status dashboard
│   └── luci-app-hotspotos/ # LuCI application
└── scripts/              # Build & flash utilities
```

## License
GPL-2.0
