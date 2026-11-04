# RemVibe CLI Menu — Working Rules

Adapted from `remvibe_flutter_ui` and `remvibe_networking` standards for this standalone Dart package.

## Scope and ownership
- The package owns only generic menu representation, rendering, navigation, terminal IO and action dispatch. The application owns project lists, update statuses, releases, persistence and GitHub operations.
- Work in small approved checkpoints: inspect real repository, set goal/non-goals and acceptance criteria, branch, implement, test, review diff, Draft PR. Keep explicit **user approval separate for squash merge**.
- Keep architecture minimal. No Flutter, terminal UI framework, custom input event loop, DI container, service registries, global singleton or extra packages unless a concrete need is approved.

## API and behavior
- Dynamic menu items and detail lines are built on each render, including after asynchronous actions. Do not cache mutable domain state in the library.
- Number non-shortcut visible items automatically; explicit alphabetic shortcuts are case-insensitive. Reserve B (back in child menu) and X (exit).
- Visible/disabled state and display markers are application-supplied. The package does not infer availability from a marker.
- Separate generic terminal input/output from navigation logic so scripted tests can exercise the same behavior as a real terminal.
- Handle malformed choices, action exceptions and builder errors predictably; EOF ends the session. Never treat an invalid command as success.

## Engineering
- Use explicit APIs and responsible file boundaries. Do not force inheritance or create multiple layers that merely forward calls.
- Avoid duplicate state/dispatch logic and hidden mutable globals. Preserve reasonable error messages; no swallowed exceptions.
- Preserve secrets and filesystem safety where relevant; this menu package must not handle credentials itself.
- Document behavior changes, toolchain requirements and real validation results.
- For pure Dart: do **not** run `dart format` without explicit authorization. Use `dart analyze`, `dart test` and run the interactive Example for acceptance.
- Do not commit generated `.dart_tool`, `build/`, coverage or machine-specific files. Keep package manifests and source under version control.

## Review and continuity
- Do not refactor completed contracts without an approved checkpoint.
- Report the exact commands and outcomes, distinguishing code review from actual test execution.
- Maintain `docs/continuity/CURRENT_TARGET.md` and `PROJECT_STATUS.md`; update README/API examples when signatures change.
- Do not merge or delete feature branches without separate user authorization.

**Question before adding code:** Does this belong in a generic CLI menu, or should the consuming application own it?
