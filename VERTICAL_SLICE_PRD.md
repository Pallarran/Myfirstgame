# Vertical Slice PRD — *Hearthstead: Camp*

> **Status:** Active scope. This is what we are actually building first.
>
> **Timeline target:** 3–6 months of part-time solo development (after Phase 0 learning).
>
> **Last updated:** 2026-05-11

---

## 1. Purpose of This Document

This PRD describes the **minimum viable game** that proves the core loop is fun. It is intentionally tiny. The full game (see `VISION_PRD.md`) is a 2–4 year project; this slice is the first 3–6 months of it.

**The slice succeeds if:** the developer can hand the build to a friend, the friend plays for 15 minutes without instructions, and the friend says "this feels nice — what happens next?"

**The slice fails if:** building it teaches the developer they don't actually enjoy this kind of project. That's a valuable lesson too, and worth surfacing early before investing years.

---

## 2. What's In Scope

### Game content

- **One tier only: Camp.** No tier-up mechanic. No teaser of Settlement tier.
- **One small handcrafted scene.** ~30m × 30m of usable space. Forest on one side, a small stream, flat clearing for the camp itself.
- **Time of day:** day/night cycle, fully cosmetic + a lighting shift. No mechanical effect.
- **No seasons. No weather. No combat. No threats of any kind.**

### Buildings (4 total)

1. **Campfire** (starting structure, pre-placed, cannot be removed). The center of the camp. Villagers gather here at night. Provides warmth at night.
2. **Tent** (housing). Houses 2 villagers. Player can activate 3–4 tent plots over the course of the game.
3. **Woodcutter's lean-to.** 1 worker. Produces wood from nearby trees. Click-to-boost enabled.
4. **Forager's hut.** 1 worker. Produces food from the surrounding area. Click-to-boost enabled.

That's it. Four building types. Maybe 8–10 total building plots on the map.

### Resources (3 total)

- **Wood** — produced by Woodcutter. Consumed by tent construction and as nightly campfire fuel.
- **Food** — produced by Forager. Consumed daily by every villager.
- **Population** — count of villagers, capped by tent housing.

No storage buildings yet. Resources go to a global stockpile. (Storage buildings + haulers come in the next slice.)

### Villagers

- **Start with 3 villagers**, pre-named with light traits.
- **Maximum population in slice: 8.** New villagers arrive when a new tent is built (immigration model — births come later).
- Each villager has: name, age, one trait, assigned job (or "idle").
- Click a villager to see their info card.
- Villagers visibly walk between their workplace and the campfire/tent.
- **One need only:** food. A villager with no food for several days becomes "hungry" (gentle UI indicator, slower work). Cannot die in this slice.

### Player actions

- Pan and rotate camera, zoom in/out.
- Click an available building plot → confirm to build (consumes resources, takes time).
- Click an existing building → see info + assign/unassign workers.
- Click a worker building (Woodcutter, Forager) → click-to-boost button → small wood/food bonus + satisfying feedback.
- Click a villager → see info card.
- Open build menu, codex, settings.
- Save game, load game, save-and-quit.

### UI

- Top bar: wood count, food count, population (current/max), time-of-day indicator.
- Side: collapsible build menu showing the 3 buildable types (Tent, Woodcutter, Forager) with cost and current availability.
- Bottom corner: small notification feed.
- Settings menu: volume, fullscreen toggle, save/load, quit.
- **Tutorial:** very light. Three or four prompt cards that appear as triggered by progress ("welcome to your camp — try clicking the woodcutter plot to build one").

### Audio

- One ambient music loop (forest/camp acoustic folk).
- Diegetic loops: chopping wood, walking footsteps, campfire crackle, occasional bird, wind in trees.
- Feedback sounds: building complete, click-to-boost, button hover/click, notification.

### Save/Load

- Autosave every 10 minutes.
- Manual "save and quit" from settings menu.
- Single save slot in this slice. (Multiple slots come later.)
- Local files only. No cloud, no Steam integration in this slice.

---

## 3. What's Explicitly NOT In Scope

Naming these explicitly so they don't sneak in:

- Tier progression beyond Camp
- Seasons, weather
- Combat, wolves, bandits, any threats
- Storage buildings, haulers
- Births, deaths, aging mechanics
- Comfort needs beyond food
- Trading, merchants
- Multiple maps
- Achievements, Steam integration
- Localization (English only, hardcoded strings okay in this slice but use string constants for easy refactor later)
- Polished art (use Kenney/Quaternius placeholder assets throughout)
- Cinematic intro, menu beauty, main menu beyond a simple "New Game / Continue / Quit"

---

## 4. Definition of Done

The slice is "done" when **all** of the following are true:

1. A new player can launch the game, see a main menu, click "New Game," and arrive in the camp scene with no errors.
2. The four building types can all be built, staffed, and operate correctly.
3. Click-to-boost works and feels satisfying (sound + small visible feedback).
4. Villagers visibly move between work and rest with believable pathing.
5. Day/night cycle runs smoothly without performance issues.
6. The player can play continuously for 30 minutes with no crashes or game-breaking bugs.
7. Save and load work reliably — closing the game and reopening returns to the same state.
8. Autosave fires every 10 minutes without interrupting play.
9. The game ships as a single executable for Windows that runs on a clean machine without installing dependencies.
10. A non-developer playing for 15 minutes reaches "I built a few tents and have 6 villagers" without consulting anything outside the game.

---

## 5. Out-of-Game Deliverables

By the end of the slice:

- Working Godot 4 project in a Git repository hosted on GitHub.
- `README.md` explaining how to run from source and how to export builds.
- `CLAUDE.md` (already provided) kept current with the project state.
- This PRD updated with lessons learned, ready to inform Slice 2 (Settlement tier).
- One playable Windows build in the repo's Releases tab.

---

## 6. Recommended Build Order

Sequenced so you have a playable thing as early as possible, even if it's ugly:

**Milestone A — Empty world (Week 1–3)**
- Godot project set up, Git initialized, GitHub remote configured.
- Camera that pans, rotates, zooms.
- Flat terrain with placeholder trees and a stream.
- Main menu → New Game → empty scene → quit.

**Milestone B — First building (Week 3–5)**
- Building plot system: predetermined plots on the map.
- One building type (Tent) can be built by clicking a plot and confirming.
- Wood resource exists. Building costs wood. Starting wood stockpile is enough to build one tent.
- Top bar shows wood count.

**Milestone C — Villagers (Week 5–8)**
- Villagers exist, visible, walk around.
- Starter villagers spawn at game start.
- Building a tent attracts a new villager.
- Villager info card on click.

**Milestone D — Production loop (Week 8–11)**
- Woodcutter and Forager buildings.
- Worker assignment UI.
- Wood and food production over time.
- Food consumption by villagers.
- Click-to-boost on gathering buildings.

**Milestone E — Polish & feel (Week 11–14)**
- Day/night cycle.
- Diegetic audio.
- Ambient music.
- Notification feed.
- Save/load.
- Tutorial prompts.

**Milestone F — Ship-able build (Week 14–18)**
- Bug fixes.
- Settings menu.
- Windows export tested on a clean machine.
- Friend playtest.

*Weeks are deliberately wide ranges. Solo + learning + life = unpredictable.*

---

## 7. Lessons-Learned Log

*To be filled in during development. Each entry: what was tried, what happened, what to do differently next slice.*

(Empty for now.)

---

## 8. Decision Log

*Record significant decisions made during development so future-you understands why.*

(Empty for now.)

---

*When this slice is complete and playable, write `SLICE_2_SETTLEMENT_PRD.md` covering the jump to Settlement tier — adding storage, haulers, farming, basic seasons, births. Do not start Slice 2 until Slice 1 is shippable.*
