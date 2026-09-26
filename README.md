# DLMS Companion for Omarchy

A small Omarchy Quattro bar widget for an existing DLMS instance. It shows the number of study questions due and opens Today's Review or DLMS in your browser. DLMS remains responsible for review scheduling and study activity. This plugin is not yet listed in the Omarchy Plugins marketplace.

## What is DLMS?

[DLMS](https://github.com/drakahari/DLMS_next) is a local-first study application for creating quizzes, reviewing material, and tracking learning progress through a browser interface. This companion does not include DLMS; you need a running instance reachable from your Omarchy desktop.

## Requirements

- Omarchy Quattro with the built-in bar
- A reachable local or remote DLMS instance
- `curl` and `xdg-open` on the Omarchy desktop

## Install

Install from this public repository, then enable the widget. It starts in the right section of the bar.

```sh
omarchy plugin add https://github.com/drakahari/omarchy-dlms.git
omarchy plugin enable drakahari.dlms
```

Click the DLMS icon in the bar. If no URL is configured, the panel opens Settings directly. Enter the **DLMS URL**, optionally select **Test Connection**, then select **Save**. Use the server's base URL, without a page path:

- Local: `http://127.0.0.1:9001`
- Remote: `http://dlms-server:9001`
- HTTPS: `https://dlms.example.com`

A trailing slash is accepted. The URL and appearance preference are stored in Omarchy's inline bar-widget settings, with no separate plugin config file. For troubleshooting, you can also set the URL with `omarchy bar set drakahari.dlms serverUrl "http://dlms-server:9001"`.

## Use

The bar shows a theme-colored DLMS icon and the due count. Hover for a textual label; click to see the compact panel and its **Open Today's Review**, **Open DLMS**, and **Settings** actions. Under **Appearance**, enable **Use color DLMS icon** to use the original full-color favicon instead. The setting updates the bar and persists across shell restarts.

The widget reads DLMS's `GET /api/daily-review-plan` endpoint on startup, when the panel opens, and every ten minutes. An unreachable or invalid response shows an unavailable state, never an old count as current. **Test Connection** checks the URL typed into Settings without saving it or changing DLMS data.

Drag the widget to another bar section, or use `omarchy bar move drakahari.dlms --section center` (replace `center` with `left` or `right`). The manifest's right-side placement is only the default.

## Update and remove

For a copy installed from Git:

```sh
omarchy plugin update drakahari.dlms
```

If the old QML remains visible after updating, run `omarchy-restart-shell`. For a local development symlink, update its source checkout and restart the shell if needed.

To disable the widget without deleting it, run `omarchy plugin disable drakahari.dlms`. To remove an installed copy, run:

```sh
omarchy plugin remove drakahari.dlms
```

Omarchy removes the bar entry; manual `shell.json` editing is not needed.

## Privacy and security

The plugin connects only to the DLMS URL you configure and retrieves review information from that instance, whether local or remote. It does not store credentials or learning history. Use a network or connection appropriate for your DLMS deployment; this plugin does not add authentication or TLS to DLMS itself.

## Current limits

- Review actions open DLMS in your browser; the panel does not answer quizzes.
- The panel shows up to two recommendation titles from DLMS and does not reproduce DLMS's review logic.
- No notifications or offline cache.

The bundled color icon comes from DLMS's `static/favicon.ico` artwork. The theme-aware monochrome icon is a one-color vector derived from the same favicon's badge, DLMS lettering, and swoosh. Neither icon needs the DLMS repository at runtime.
