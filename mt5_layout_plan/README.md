# ASC MT5 Root

This folder is the new active MT5 build surface for ASC.

Archive product code lives in `archives/`.
This folder is for the clean rebuild only.

## Purpose

The `mt5/` root exists to hold the future product code structure in a clean, meaning-based layout.

## Current state

This folder currently stores structure blueprints and ownership boundaries.
It is not yet the finished EA implementation.

## Rules

- use meaning-based module names
- do not name product parts after build steps
- keep internal mechanics separate from human-facing wording
- keep discovery, runtime, layers, publication, and presentation separated
- carry a clean menu/input plan early so the future EA properties surface does not become retrofit clutter
- preserve explicit placeholders for Layers 2 through 5 even while Layer 1 remains the only implemented layer
