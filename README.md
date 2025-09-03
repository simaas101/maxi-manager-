# mikrotik_manager_flutter

Flutter app for managing MikroTik hotspot users over the native RouterOS binary API
using [`router_os_client`](https://pub.dev/packages/router_os_client).

## Features
- Connect to RouterOS using IP, username, password, SSL toggle.
- List hotspot users (`/ip/hotspot/user/print`) with name, profile, uptime, **comment**.
- Enable/disable, add, edit comment, remove user.
- List active sessions (`/ip/hotspot/active/print`).
- Local storage of last-used connection.

## Router prerequisites
- API service enabled: `/ip service enable api` (port 8728) or `api-ssl` (8729 for SSL).
- For SSL: install proper certificate and enable `api-ssl`.
- User account with permissions to read/write hotspot.

## Security
Credentials are stored locally on-device using SharedPreferences in plain form. Consider
not saving passwords on shared devices, or add your own secure storage.
