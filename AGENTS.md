# RemVibe CLI Menu — Repository Rules

Before planning or changing code, read `docs/WORKING_RULES.md`, `README.md`, `docs/continuity/README.md`, and `docs/continuity/CURRENT_TARGET.md`.

This is a **reusable Dart CLI menu package**. It must not depend on Update Center, GitHub APIs, project-specific update state, Flutter, RemVibe Remote, or a custom terminal framework. The consuming application owns menu items, markers, availability, input validation and actions.

Implement only bounded, approved checkpoints on a feature branch. Review the actual diff; run analyzer, tests and the real example on the target platform before claiming success. No squash merge, release or branch cleanup without separate explicit approval. Keep continuity current with actual evidence; do not invent test results. Do not run `dart format` on pure Dart sources without explicit user authorization.

Use small, responsibility-focused files and explicit errors; no silently swallowed failures, speculative abstractions or unrelated refactors.
