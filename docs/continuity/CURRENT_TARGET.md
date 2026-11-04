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
Source, example, tests, and documentation authored on feature branch via GitHub. **No Dart SDK available in this assistant's container to execute analyzer/tests or interactive Windows demo.** A GitHub Actions CI workflow is included for automatic test evidence, which must be checked after PR creation. No checks should be claimed green without actual workflow results.

## Next
Verify CI outcome, fix any failures, present user with Windows PowerShell clone/checkout/test commands, collect real acceptance, then request separate approval for squash merge/cleanup.
