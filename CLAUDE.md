# CLAUDE.md

This file gives Claude Code the context it needs to work effectively in this repo. Keep it under ~200 lines. Update it as the project evolves.

---

## Project: Hearthstead (working title)

A chill, single-player medieval city-builder. The player guides one settlement through five visual tiers (Camp → Settlement → Town → City → Fortified City). Inspired by Hearth & Hamlet.

**Current scope:** Vertical Slice 1 — Camp tier only. See `docs/VERTICAL_SLICE_PRD.md` for full slice spec, and `docs/VISION_PRD.md` for the long-term vision.

**Developer experience level:** No prior coding experience. Learning Godot and game development through this project. Claude Code is the primary development partner. Explanations should be friendly and assume nothing, but not condescending.

---

## Tech Stack

- **Engine:** Godot 4 (latest stable on 4.x).
- **Language:** GDScript.
- **Version control:** Git, hosted on GitHub.
- **Target platforms (slice 1):** Windows desktop, exported as a single executable. Linux/Mac later.
- **Asset sources:** Placeholder art from Kenney.nl, Quaternius, and Synty Studios. No custom art during slice 1.
- **Audio sources:** Royalty-free libraries (Freesound, Pixabay) for slice 1.

---

## Design Pillars (DO NOT VIOLATE)

These are the rules that keep the game *chill*. If a feature contradicts them, push back before implementing it.

1. **Chill, not stressful.** No fail states that erase progress. No timers that punish breaks. Imbalance creates a soft nudge, not a crisis.
2. **No spatial puzzle.** Players choose *what* and *when* to build. Building locations are pre-designed by the developer; players never decide *where*.
3. **Visual progression is the headline reward.** Tier transitions are real moments with visual and audio celebration.
4. **Engagement through optimization, not action.** Click-to-boost gathering and balancing chains are the engagement loop. Never reaction-time, never twitch.
5. **Cozy aliveness.** Visible activity (haulers, workers walking, animals, smoke from chimneys), diegetic audio, named villagers. The settlement must feel alive.

If asked to add a feature like "fail state on missing food," "free building placement," "real-time combat the player controls," or "fast-paced events": stop and ask. These violate pillars.

---

## Project Structure

```
/
├── CLAUDE.md                    # This file
├── README.md                    # How to run, build, contribute
├── docs/
│   ├── VISION_PRD.md            # Long-term vision (the north star)
│   ├── VERTICAL_SLICE_PRD.md    # Current scope (what we're building)
│   └── decisions/               # Decision log entries (one .md per decision)
├── project/                     # Godot project root
│   ├── project.godot
│   ├── scenes/                  # All .tscn scene files
│   ├── scripts/                 # All .gd script files
│   ├── assets/
│   │   ├── models/              # 3D models (placeholder + final)
│   │   ├── textures/
│   │   ├── audio/
│   │   │   ├── music/
│   │   │   └── sfx/
│   │   └── fonts/
│   ├── data/                    # JSON or .tres resources defining buildings, villagers, etc.
│   └── ui/                      # UI scenes and themes
└── builds/                      # Local export targets (gitignored)
```

This structure is a starting point. Adjust as needed and update this file when you do.

---

## Coding Conventions

- **File naming:** `snake_case.gd` for scripts, `PascalCase.tscn` for scenes.
- **Class names:** `PascalCase`.
- **Variables and functions:** `snake_case`.
- **Constants:** `SCREAMING_SNAKE_CASE`.
- **Signals:** named as past-tense verbs (`building_completed`, `villager_hungry`).
- **Comment policy:** every script starts with a one-paragraph comment explaining what it does and why. Inline comments for any non-obvious logic. Assume future-developer is a beginner.
- **Function size:** keep functions short. If a function is over ~30 lines, consider splitting it.
- **No magic numbers.** Use named constants (`MAX_VILLAGERS = 8`, not `if villagers.size() >= 8`).
- **Data over code.** Building costs, villager traits, resource rates live in `.tres` resource files or JSON in `project/data/`, not hardcoded in scripts.
- **Strings.** Even in slice 1, route player-visible strings through a single `Strings` autoload or constants file. Makes localization possible later.

---

## Architectural Guidance

- **Use Godot's node-and-scene model idiomatically.** Don't try to build a "framework" on top of it. Scenes are the building blocks.
- **Autoload singletons** for: `GameState` (current resources, time of day, etc.), `EventBus` (signals between unrelated systems), `SaveSystem`, `AudioManager`. Keep autoloads thin.
- **Signals over direct references** when systems don't naturally own each other. A Woodcutter doesn't reach into `GameState.wood += 1`; it emits `wood_produced(amount)` on the EventBus.
- **Saves:** JSON-based. Each system serializes its own state. Save format must be versioned from day one.
- **Performance:** the slice has a max of 8 villagers and ~10 buildings. Premature optimization is not a concern. Write the clearest code, then profile if something stutters.

---

## How to Run

(Fill in as setup is completed. Until then:)

1. Install Godot 4.x from [godotengine.org](https://godotengine.org).
2. Clone this repo: `git clone <repo-url>`.
3. Open `project/project.godot` in Godot.
4. Press F5 to run, or click the play button.

To export a Windows build: see `README.md` (TBD).

---

## Currently Working On

> **Update this section every session.** This is the single most useful thing for Claude Code.

**Current milestone:** Milestone B — First building (per VERTICAL_SLICE_PRD.md).

**Most recent task:** Milestone A complete (2026-05-11) — verified end-to-end by user: F5 boots to main menu, New Game loads world, camera orbit/pan/zoom work, Esc returns to menu, Quit exits. Starting Milestone B with the foundations: `GameState` and `EventBus` autoloads, plus a `TopBar` HUD showing the wood count.

**Next task:** After this commit lands, F5-verify that the top bar appears in the world scene showing "Wood: 25". Then: clickable building plots on the map.

---

## Working With Claude Code — Notes for the Developer

- **Be specific in requests.** "Add a Woodcutter building" is vague. "In `scripts/buildings/woodcutter.gd`, create a building that has a worker slot and produces 1 wood per 10 seconds when staffed" is actionable.
- **Use plan mode** for anything touching multiple files or systems.
- **Commit often.** Every working change. Claude Code can help write commit messages.
- **When something breaks, share the exact error.** Copy/paste the full Godot console output. Don't paraphrase.
- **If Claude Code suggests a feature that violates a design pillar, push back.** Reference the pillar by name.
- **Don't be afraid to say "I don't understand."** Stop and ask for an explanation before continuing.

---

## Glossary (for the developer's reference)

- **Scene (Godot):** A reusable bundle of nodes saved as a `.tscn` file. Like a prefab in Unity. The basic unit of game content.
- **Node:** A single element in a scene (a sprite, a sound, a script container, etc.).
- **Script:** A `.gd` file attached to a node, giving it behavior.
- **Signal:** Godot's event system. One node emits a signal; others can listen and respond.
- **Autoload (singleton):** A scene or script that's always loaded and globally accessible. Used for game-wide state.
- **Resource (.tres):** Godot's data container. Used here for storing config like building costs.
- **Vertical slice:** A small but complete cross-section of the game — every core system present, but minimal content. Proves the loop works.

---

*Last updated: 2026-05-11. Update this file whenever a significant decision or structural change happens.*
