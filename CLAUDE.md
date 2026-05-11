# CLAUDE.md

This file gives Claude Code the context it needs to work effectively in this repo. Keep it under ~200 lines. Update it as the project evolves.

---

## Project: Hearthstead (working title)

A chill, single-player, **incremental** medieval citybuilder with **magical realism**. The player guides one settlement from camp to fortified city through dozens of small **in-place building evolutions** rather than gated tier-up events. Inspired by Hearth & Hamlet.

**Reference docs (in order of authority):**
- `docs/VISION_PRD.md` — long-term vision, the north star.
- `docs/PLOT_LINEAGES.md` — authoritative catalog of all 14 plot lineages and their buildings.
- `docs/VERTICAL_SLICE_PRD.md` — current near-term scope. **This is what we're building now.**

**Developer experience level:** No prior coding experience. Learning Godot and game development through this project. Claude Code is the primary development partner. Explanations should be friendly and assume nothing, but not condescending.

---

## Tech Stack

- **Engine:** Godot 4 (latest stable on 4.x).
- **Language:** GDScript.
- **Version control:** Git, hosted on GitHub.
- **Target platforms (slice 1):** Windows desktop. Linux/Mac later.
- **Asset sources:** Kenney.nl, Quaternius, Synty Studios placeholders. No custom art during slice 1.
- **Audio sources:** Royalty-free libraries (Freesound, Pixabay) for slice 1.

---

## Design Pillars (DO NOT VIOLATE)

If a feature contradicts these, push back before implementing.

1. **Chill, not stressful.** No fail states that erase progress. Imbalance creates a soft nudge, not a crisis.
2. **Incremental progression as core dopamine.** Constant small improvements. Players should always have something small to work toward.
3. **No spatial puzzle.** Players choose *what* and *when* to build. Building locations are pre-designed; players never decide *where*.
4. **Visual progression through in-place evolution.** Buildings level up in their existing location, then auto-evolve into their next-form when ready. Tiers (Camp/Settlement/Town/City/Fortified City) are descriptive labels emerging from the state of signature plots, not gates.
5. **Engagement through optimization, not action.** Click-to-boost gathering and balancing chains. Never reaction-time.
6. **Cozy aliveness.** Visible activity (haulers, workers, animals, smoke), diegetic audio, named villagers.
7. **Magical realism, never high fantasy.** Magic is gentle, slow-acting, benevolent. Folk magic and rare spirits. No combat magic. No dragons or monsters.

If asked to add a feature like "fail state on missing food," "free building placement," "real-time combat the player controls," "battle spells," or "fast-paced events": stop and ask. These violate pillars.

---

## Key Concepts (Glossary)

- **Plot:** A predetermined location on the map where buildings can exist. Plots are designed, not placed by the player.
- **Lineage:** A sequence of building forms a plot progresses through across the game (e.g., Campfire → Communal Hearth → Market Square → Civic Plaza → Grand Plaza). There are 14 lineages total — see PLOT_LINEAGES.md.
- **Form:** A specific building identity within a lineage (e.g., "Mayor's House" is form 3 of the Chief's Seat lineage).
- **Level:** A progression step within a form, 1–5. Each level brings visible upgrade + ~+25% output.
- **Evolution:** Auto-transition from one form to the next when a building reaches its threshold level (typically 5). Returns to level 1 of the new form.
- **Signature evolution:** A celebrated evolution moment (camera focus, music swell, particle effect). ~10–15 of these across the full game.
- **Tier descriptor:** The current state of the settlement (Camp/Settlement/Town/City/Fortified City), derived from the state of signature plots. Displayed in UI but not a gate.
- **Blessings:** Area-of-effect buff produced by the Sacred Height lineage (Chapel → Cathedral). NOT a resource. Just an effect.
- **Magic Crystals:** A stockpiled resource produced by the Grove lineage. Used to cast Spells.
- **Spells:** Player-triggered settlement-wide effects, cast from the Spellbook UI at the Mage's Tower or above. Cost crystals.
- **Policies:** Settlement-wide toggles unlocked by the Chief's Seat lineage. Set-and-forget decisions.

---

## Project Structure

```
/
├── CLAUDE.md                    # This file
├── README.md                    # How to run, build, contribute
├── docs/
│   ├── VISION_PRD.md
│   ├── PLOT_LINEAGES.md
│   ├── VERTICAL_SLICE_PRD.md
│   ├── JOURNAL.md               # Dev journal (your notes)
│   └── decisions/               # One .md per significant decision
├── project/                     # Godot project root
│   ├── project.godot
│   ├── scenes/                  # All .tscn scene files
│   ├── scripts/                 # All .gd script files
│   ├── assets/
│   │   ├── models/
│   │   ├── textures/
│   │   ├── audio/
│   │   │   ├── music/
│   │   │   └── sfx/
│   │   └── fonts/
│   ├── data/                    # .tres / JSON for buildings, lineages, etc.
│   └── ui/                      # UI scenes and themes
└── builds/                      # Local export targets (gitignored)
```

---

## Coding Conventions

- **File naming:** `snake_case.gd` for scripts, `PascalCase.tscn` for scenes.
- **Class names:** `PascalCase`.
- **Variables and functions:** `snake_case`.
- **Constants:** `SCREAMING_SNAKE_CASE`.
- **Signals:** past-tense verbs (`building_completed`, `villager_hungry`, `evolution_triggered`).
- **Comments:** every script starts with a paragraph explaining what it does and why. Inline comments for non-obvious logic. Assume future-developer is a beginner.
- **Function size:** keep functions short. Over ~30 lines → consider splitting.
- **No magic numbers.** Use named constants.
- **Data over code.** Lineage definitions, building stats, level costs, etc. live in `.tres` resource files or JSON in `project/data/`, not hardcoded in scripts.
- **Strings.** Route player-visible strings through a `Strings` autoload or constants file from day one. Makes localization possible later.

---

## Architectural Guidance

- **Use Godot's node-and-scene model idiomatically.** Don't build frameworks on top of it.
- **Autoload singletons** for: `GameState` (resources, time of day, tier descriptor), `EventBus` (signals between unrelated systems), `SaveSystem`, `AudioManager`, `Strings`. Keep them thin.
- **Signals over direct references** when systems don't naturally own each other.
- **Lineages are data, not code.** Each lineage is a `.tres` resource describing its forms, level thresholds, and outputs. The same building logic class handles all buildings; the resource tells it how to behave.
- **Saves:** JSON-based. Each system serializes its own state. Save format versioned from day one.
- **Performance:** the slice has ~8 villagers and ~10 buildings. Premature optimization not a concern.

---

## How to Run

(Fill in as setup is completed.)

1. Install Godot 4.x from [godotengine.org](https://godotengine.org).
2. Clone this repo: `git clone <repo-url>`.
3. Open `project/project.godot` in Godot.
4. Press F5 to run.

To export a Windows build: see `README.md` (TBD).

---

## Currently Working On

> **Update this section every session.** Highest-leverage habit for working with Claude Code.

**Current milestone:** Milestone A — Empty world (per VERTICAL_SLICE_PRD.md).

**Most recent task:** Design documents updated to v2 (lineage system, emergent tiers, magic split).

**Next task:** Phase 0 — install Godot 4, complete official 3D tutorial, set up Git and GitHub repo.

---

## Working With Claude Code — Notes for the Developer

- **Be specific in requests.** "Add a Woodcutter building" is vague. "Create a building scene `Woodcutter.tscn` in `scenes/buildings/` that follows the lineage data pattern (load level/output from a `.tres` resource), implements click-to-boost, and emits signals via EventBus when production occurs" is actionable.
- **Reference docs by name.** "Per PLOT_LINEAGES.md, the Forest Edge — Wood lineage starts as a Woodcutter's Lean-to..." gives Claude Code the exact spec.
- **Use plan mode** for anything touching multiple files or systems.
- **Commit often.** Every working change.
- **When something breaks, share the exact error.** Copy/paste full console output.
- **If Claude Code suggests something that violates a design pillar, push back.** Reference the pillar by name or number.
- **Don't be afraid to say "I don't understand."** Stop and ask before continuing.

---

## Godot Concepts Glossary (for the developer's reference)

- **Scene:** A reusable bundle of nodes saved as `.tscn`. Like a prefab. The basic unit of game content.
- **Node:** A single element in a scene (sprite, sound, script container).
- **Script:** A `.gd` file attached to a node, giving it behavior.
- **Signal:** Godot's event system. Emit / connect.
- **Autoload (singleton):** Always-loaded, globally accessible. Used for game-wide state.
- **Resource (.tres):** Godot's data container. Used here for storing lineage configs, building stats.
- **Vertical slice:** A small but complete cross-section of the game.

---

*Last updated: 2026-05-11 (v2 — lineage system).*
