# omarchy-dlms

**Early local prototype.** A small Omarchy Quattro bar widget for an existing DLMS server. It shows the server's due-question count, up to two titles from Today's Review, and links that open DLMS in your browser. DLMS continues to own all study and quiz behavior.

The initial count, panel, links, and remote polling were live-tested on Omarchy Quattro. A later icon/settings version exposed runtime regressions; the fixes in this checkout still need a live test. This plugin is not available in a plugin marketplace.

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
```

The symlink is for local development only. Check that the destination does not already exist before creating it. Click the bar widget, open **Settings**, enter the **DLMS URL**, and select **Save**. The URL is stored as the widget's inline `serverUrl` setting in Omarchy's `shell.json`; there is no separate plugin config file. The same HTTP/HTTPS setting works for a local server (`http://127.0.0.1:9001`) or a remote server (`http://dlms-server:9001`, `https://dlms.example.com`). A trailing slash is fine. Set the server **origin**, without a page path. No server address is included in this repository.

After updating a development install, confirm that `~/.config/omarchy/plugins/drakahari.dlms` points to this checkout and restart the shell with `omarchy-restart-shell`. If the bar still shows the old literal `DLMS · setup`, the shell is running an older widget copy: this version has no such bar text.

**Test Connection** checks the typed URL against DLMS's existing `GET /api/daily-review-plan` endpoint before saving. It only reads the endpoint and reports success or failure. For advanced setup or recovery, the terminal command remains available:

```sh
omarchy bar set drakahari.dlms serverUrl "http://YOUR-DLMS-SERVER:9001"
```

## Use

The bar shows the DLMS app icon and current due count. Hover for a textual DLMS label. Click it to see the count, up to two recommendation titles, **Open Today's Review**, **Open DLMS**, and **Settings**. When no valid URL is configured, clicking opens the settings field directly. The links open the browser; they do not create quizzes or submit answers. The main panel supports Up/Down and Enter, plus Escape to close.

The bundled `dlms-icon.png` is a 64 px copy scaled from DLMS's existing `static/favicon.ico` PNG artwork. It does not depend on the DLMS checkout at runtime.

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
- The current icon and in-panel settings fixes need validation on an Omarchy installation before release.

The implementation follows the current [Omarchy plugin contract](https://github.com/omacom/omarchy/blob/quattro/docs/omarchy-shell.md) and its [first-party popup widget pattern](https://github.com/omacom/omarchy/blob/quattro/shell/plugins/panels/clock/BarWidget.qml).
