# Development notes

DLMS Companion is a thin Omarchy client. DLMS owns scheduling, recommendations,
quizzes, attempts, and Learning Intelligence; keep that logic in DLMS.

## Plugin development

- Use current official Omarchy plugin APIs and patterns, and keep the UI compatible
  with Omarchy themes.
- Keep polling conservative. Treat unreachable or malformed DLMS responses as an
  unavailable state, and never present a stale count as current.
- Keep server addresses, credentials, and local secrets out of the source tree.
- Avoid unrelated dependencies, daemons, frameworks, and broad changes.
- Make DLMS changes in its own repository, outside this plugin project.

## Validation and release

Validate the plugin and test it on Omarchy before a release. Commits, pushes,
tags, and releases should be made only for an explicitly requested change.
