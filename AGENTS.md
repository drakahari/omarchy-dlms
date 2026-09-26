# omarchy-dlms agent instructions

- Keep this plugin a thin client. DLMS owns scheduling, recommendations, quizzes, attempts, and Learning Intelligence; never duplicate that logic here.
- Never hard-code server addresses, credentials, or local secrets.
- Follow current official Omarchy plugin APIs and patterns; keep the UI compatible with Omarchy themes.
- Keep polling conservative and treat an unreachable or malformed DLMS response as a normal unavailable state. Never show stale counts as current.
- Avoid unrelated dependencies, daemons, frameworks, and broad changes.
- Do not modify the DLMS repository from this project.
- Validate the plugin and test it on Omarchy before release.
- Do not commit, push, tag, or release unless explicitly requested.
