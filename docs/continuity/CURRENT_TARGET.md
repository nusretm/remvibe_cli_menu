# RemVibe CLI Menu — Current Target

Updated: 2026-11-04
Repository: `nusretm/remvibe_cli_menu`
Feature branch: `feature/cli-menu-foundation`
Checkpoint: **CLI-1 dynamic menu foundation**

## Goal
Develop a reusable pure-Dart CLI menu with:
- dynamic item builders and display details;
- automatic numeric commands and explicit single-letter shortcuts;
- nested menu push/back and session exit;
- conditional visibility, disabled items and user-supplied markers (e.g., `*`);
- asynchronous actions, status refresh on next render and simple free-form prompting;
- replaceable terminal IO, tests and an example that demonstrates Update Center-like navigation without real publishing.

## Boundaries
No GitHub integration, archiver, package publishing, OS machine monitoring, Flutter, platform-native terminal UI, persistence or actual update business logic. Do not create a framework for hypothetical future needs.

## Acceptance
- `dart pub get`
- `dart analyze`
- `dart test` (nested navigation, dynamic U/R states, shortcuts, hidden/disabled, errors, free-form input, EOF)
- `dart run example/bin/main.dart` on Windows, with user confirmation of real terminal behavior
- Independent diff review and Draft PR; separate user approval before squash merge.

## Current evidence
**Validated / user accepted (2026-11-04).** GitHub Actions PR runs [41827340818](https://github.com/nusretm/remvibe_cli_menu/actions/runs/41827340818) and [41827518540](https://github.com/nusretm/remvibe_cli_menu/actions/runs/41827518540) passed on Ubuntu: `dart pub get` PASS, `dart analyze` — No issues found, `dart test` — 7/7 PASS. On user's actual Windows workstation (`D:\\development\\dart\\remvibe_cli_menu`) with feature branch checked out, `dart pub get` succeeded, `dart analyze` reported `No issues found!`, `dart test` reported `+7: All tests passed!`, and `dart run example/bin/main.dart` was interactively verified: AvukatPro submenu rendered, `s` triggered history, invalid `z` displayed rejection, `x` exited successfully. This is user-supplied terminal evidence, not a locally executed test by the assistant. User explicitly authorized squash merge and cleanup. A fresh PR CI run after this documentation update must be checked before merging.

## Next
After latest PR CI succeeds, execute the approved squash merge, verify `main`, and provide safe local cleanup commands. Follow-up: a separate, minimal real GitHub Actions build-smoke checkpoint in the source repositories; no custom runner infrastructure.
