# UI BOUNDARY

## Rule
UI is presentation only. Internal scanner logic must remain independent from HUD, menu, and on-chart display concerns.

## UI Owns
- HUD
- menu
- display panels
- trader-visible labels

## UI Must Not Own
- ranking
- calculations
- persistence
- symbol identity
- file writing
- module orchestration

## Dependency Direction
UI may read prepared state. Internal modules must not depend on UI.
