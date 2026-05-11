# Hearthstead

A chill, single-player medieval city-builder. One settlement, five visual tiers, no spatial puzzle, no stress.

> **Status:** Pre-alpha. Currently building Vertical Slice 1 — Camp tier only. See [`VERTICAL_SLICE_PRD.md`](VERTICAL_SLICE_PRD.md) for what's actually being built; [`VISION_PRD.md`](VISION_PRD.md) for the long-term vision.

## Tech

- **Engine:** Godot 4 (latest stable 4.x)
- **Language:** GDScript
- **Target (slice 1):** Windows desktop, single executable

## How to run (from source)

1. Install **Godot 4.x** (standard build, not the .NET build) from [godotengine.org](https://godotengine.org).
2. Clone this repo.
3. Open `project/project.godot` in Godot.
4. Press **F5** to run. (Once a main scene exists — Milestone A.)

## How to build

Windows export instructions land in Milestone F of the vertical slice. Not ready yet.

## Repo layout

```
/
├── CLAUDE.md                    # Context for the Claude Code AI assistant
├── README.md                    # This file
├── VISION_PRD.md                # Long-term vision (the north star)
├── VERTICAL_SLICE_PRD.md        # Current scope (what we're building first)
└── project/                     # Godot project root
    ├── project.godot
    ├── scenes/                  # .tscn scene files
    ├── scripts/                 # .gd script files
    ├── assets/
    │   ├── models/              # 3D models
    │   ├── textures/
    │   ├── audio/
    │   │   ├── music/
    │   │   └── sfx/
    │   └── fonts/
    ├── data/                    # JSON / .tres resource files
    └── ui/                      # UI scenes and themes
```

## Contributing

This is a solo learning project, not currently accepting contributions. The author is a first-time game developer using Claude Code as a collaborator.
