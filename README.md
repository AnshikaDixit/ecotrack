# EcoTrack

EcoTrack is a carbon footprint tracker designed for individuals to understand, track, and reduce their environmental impact.

## Vertical
Individual carbon footprint tracking, specifically targeted towards a persona named Riya, living in a mid-size Indian city. The app aims to provide low-friction logging and specific, incremental recommendations.

## Core Logic
The application uses an illustrative set of emission factors (defaulting to India) to calculate CO2e.
The recommendation engine is a deterministic, rule-based system that suggests actionable tips based on the user's logged activities and baseline.

## Assumptions
- Single local accounts (no social login).
- SQLite database for zero external dependencies.
- Emission factors are illustrative MV defaults.
- Deterministic, rule-based assistant for explainability and reliability.
- Local run instructions only (no cloud deployment in scope).
