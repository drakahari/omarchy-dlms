# omarchy-dlms

**Early local prototype.** A small Omarchy Quattro bar widget for an existing, reachable DLMS server. It shows the server's due-question count, up to two titles from Today's Review, and links that open DLMS in your browser. DLMS continues to own all study and quiz behavior.

This project has not yet been tested in a running Omarchy shell and is not available in a plugin marketplace.

## Requirements

- Omarchy Quattro with its Quickshell plugin system and built-in bar
- An existing DLMS server reachable from this desktop
- `curl` and `xdg-open` on the desktop (standard Omarchy tools)

## Local development install

From this checkout on an Omarchy machine:

```sh
omarchy plugin validate "$PWD"
qmllint -I "$OMARCHY_PATH/shell" BarWidget.qml Panel.qml
mkdir -p "$HOME/.config/omarchy/plugins"
ln -s "$PWD" "$HOME/.config/omarchy/plugins/drakahari.dlms"
omarchy-shell shell rescanPlugins
omarchy plugin enable drakahari.dlms --section right
omarchy bar set drakahari.dlms serverUrl "http://YOUR-DLMS-SERVER:9001"
```

The symlink is for local development only. Check that the destination does not already exist before creating it. The plugin uses the widget's inline `serverUrl` setting in Omarchy's `shell.json`; it does not create a separate config file. An `https://` URL is also accepted, and a trailing slash is fine. Set the address to the DLMS server **origin**, without a page path. No server address is included in this repository.

## Use

The bar shows `DLMS · N` when a current response is available. Click it to see the count, up to two recommendation titles, **Open Today's Review**, and **Open DLMS**. The links open the browser; they do not create quizzes or submit answers. The panel supports Up/Down and Enter, plus Escape to close.

The widget checks `GET /api/daily-review-plan` on start and every ten minutes. Opening the panel requests a fresh response. During a check, it shows a checking state; a failed, malformed, or unreachable response shows an unavailable state rather than an old count. If a response ages past ten minutes (for example, after sleep), the count is hidden. An unset or invalid server URL shows a setup state.

## Removal

```sh
omarchy plugin disable drakahari.dlms
omarchy plugin remove drakahari.dlms
```

For the local symlink installation above, removal should unlink the installed plugin reference. The checkout remains separate.

## Privacy and security

The plugin contacts only the configured DLMS server and opens its pages through the desktop's browser handler. It stores no credentials or learning history. The server URL is stored in the user's Omarchy bar configuration. DLMS LAN mode itself has no built-in authentication or TLS; use a trusted, appropriately protected network. Avoid putting credentials in the URL.

## Current limits

- It reads only the server's Today’s Review plan. Browser-local Resume sessions are absent.
- It shows recommendation titles only, without reproducing DLMS's decision or action controls.
- It has no notifications, offline cache, or quiz controls.
- Omarchy runtime behavior and the official manifest validation still need checking on an Omarchy installation.

The implementation follows the current [Omarchy plugin contract](https://github.com/omacom/omarchy/blob/quattro/docs/omarchy-shell.md) and its [first-party popup widget pattern](https://github.com/omacom/omarchy/blob/quattro/shell/plugins/panels/clock/BarWidget.qml).
