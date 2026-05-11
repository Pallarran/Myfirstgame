# Vision PRD — *Working Title: Hearthstead*

> **Status:** Living document. This captures the long-term vision for the full game. It is *not* what we build first. See `VERTICAL_SLICE_PRD.md` for the actual near-term scope.
>
> **Last updated:** 2026-05-11

---

## 1. Elevator Pitch

A chill medieval city-builder where the player guides a single settlement through five distinct visual tiers — **Camp → Settlement → Town → City → Fortified City** — by balancing convergent resource production chains and tending to a small population of named villagers. No spatial puzzle, no harsh failure states, no tactical combat. The pleasure is in the rhythm: activating the next building, watching the next chain hum into balance, and seeing the settlement visibly bloom around you.

**Reference game (primary):** Hearth & Hamlet (demo).
**Adjacent references:** Foundation, Banished (gentle pacing), Tiny Glade (visual coherence), Against the Storm (settlement growth feel).

---

## 2. Design Pillars

These are the non-negotiables. Every feature decision is judged against them.

1. **Chill, not stressful.** Failure is recoverable; pressure is gentle; the game never punishes a 10-minute break. Imbalance creates a soft nudge, not a crisis.
2. **Visual progression as core reward.** The five-tier transformation (camp → fortified city) is the headline feature, not flavor. Every tier-up is a real visual moment.
3. **Balance over placement.** Players decide *what* to build and *when*. They never decide *where* — every building's location is pre-designed for visual coherence with the terrain.
4. **Cozy aliveness.** Visible haulers, diegetic audio, named villagers, day/night and seasonal shifts. The settlement should feel lived-in, not abstract.
5. **Engagement through optimization, not action.** Click-to-boost gathering, convergent production chains, gentle resource pressure. The fun is in tuning the system, not reacting to threats.

---

## 3. Player Experience Goals

When a player closes the game after an hour, they should feel:

- **Relaxed** — like they've just done a satisfying creative activity, not a job.
- **Proud** — of what they built, however small the progress.
- **Curious** — about what the next tier unlocks, what the next building does, what's around the corner.
- **Attached** — to specific villagers, specific moments ("the winter Bram saved us by stockpiling firewood").

**Target session length:** Player-chosen. 20-minute relaxation sessions and 2-hour deep dives should both feel good. Save anytime, autosave every 10 minutes.

---

## 4. Core Loop

**The minute-to-minute loop:**
1. Observe current resource flows (visible in top bar and at each building).
2. Notice imbalance or surplus.
3. Activate next building OR adjust worker assignments OR click-to-boost a gathering site.
4. Watch the chain rebalance, villagers haul goods, the settlement evolve visually.
5. Repeat.

**The session-to-session loop:**
1. Approach tier-up requirements (population, key buildings, resource stockpiles).
2. Trigger tier-up — visual celebration, new mechanics unlock.
3. New buildings appear as available; new villager needs unlock; settlement aesthetic upgrades.
4. Settle into the new tier's rhythm. Repeat.

**End state:** Fortified City tier reached. Game continues as endless sandbox with optional soft "ambitions" (sustain 200 villagers through 10 winters, etc.). No hard win screen.

---

## 5. Tier Progression

Five tiers, each a meaningful gameplay gate, not just a graphical change.

| Tier | Unlock Condition (placeholder) | New Mechanics | Visual Identity |
|------|-------------------------------|----------------|-----------------|
| **Camp** | Starting state | Basic gathering (wood, food, water). Tents. Assigned workers. | Dirt paths, canvas tents, campfire, trampled grass. |
| **Settlement** | Pop. 15 + storehouse + 30-day survival | Farming, basic crafting, storage buildings, hauler villagers. | Wooden cabins, fenced gardens, packed-earth roads, woodsmoke. |
| **Town** | Pop. 50 + processed-goods chain + market | Specialized crafts (smithy, mill, bakery), travelling merchants, comfort needs (ale, cloth). | Timber-framed houses, cobbled paths, market square, banners. |
| **City** | Pop. 120 + luxury goods + faith building | Faith/culture buildings, luxury production, light combat threat begins. | Stone townhouses, plazas, lamp posts, church bells. |
| **Fortified City** | Pop. 250 + walls + garrison | Full defensive layer, military buildings, large-scale events. | Stone walls, gates, bastions, manor, paved streets. |

*Exact thresholds will be tuned during development.*

---

## 6. Resource & Economy System

- **~15–18 resources** across three layers:
  - **Raw:** wood, stone, iron ore, wheat, vegetables, fish, water, wool, herbs
  - **Processed:** planks, cut stone, iron ingots, flour, bread, ale, cloth, tools, weapons
  - **Luxury (late tiers):** fine garments, books, decorative goods
- **Production chains:** mostly convergent (a bakery needs flour + firewood + water), with some branching in late game (iron → tools OR weapons OR decoration).
- **Worker model:** assigned workers. Click a building → set worker count → they work there permanently until reassigned.
- **Click-to-boost:** key gathering buildings (woodcutter, quarry, well, fishery) can be clicked by the player to produce a small bonus burst. Light engagement, not required.
- **Storage:** physical storage buildings with hauler villagers. Resources exist in warehouses; haulers carry sacks across the settlement. (This is a core "cozy aliveness" mechanic.)
- **Failure mode:** imbalance creates soft consequences (villagers hungry → unhappy → slower work; firewood out in winter → comfort drops). No permanent loss of progress. Recovery is always possible within a few in-game days.

---

## 7. Villagers

- **Named individuals with light traits.** Each villager has a name, portrait, age, and 1–2 traits (e.g., "hardy," "skilled woodcutter") that subtly affect their work.
- **Needs scale with tier:**
  - Camp: food, shelter.
  - Settlement: + warmth, water.
  - Town: + variety in food, ale or comfort goods.
  - City: + faith/culture, decoration.
  - Fortified City: + safety, full comfort suite.
- **Population growth:** primarily births (couples form naturally when housing is available); immigration as a tier-unlocked bonus event.
- **Lifecycle:** villagers age, eventually die of old age. Children grow up and become workers. Light, narrative — not heavy simulation.
- **No deep personality system.** No moods, no relationships beyond pairing, no mental breaks. Stay firmly out of Rimworld territory.

---

## 8. Combat & Threats

> **Pillar reminder:** Combat is a small addition for realism, NOT a core mechanic. If a design decision pulls combat toward "core," reject it.

- **Threat sources, scaled by tier:**
  - Camp/Settlement: wolves (atmospheric, low-stakes, attack livestock at edges).
  - Town: occasional bandit raids (telegraphed days in advance).
  - City/Fortified City: rare small warbands (big events, well-warned).
- **Telegraphed and seasonal.** Always at least a few in-game days' warning. Threats cluster in predictable seasons (wolves in winter, bandits after harvest).
- **Fully automated combat.** Player builds walls and towers and assigns guards. Combat resolves on its own. An alarm bell rallies guards to a point. No unit-level control.
- **Consequences:** building damage (repairable), occasional villager injury, very rare death only on deeply neglected defenses. Never devastating.
- **Defensive buildings as tier rewards:** palisade (Settlement) → stone walls (Town) → gates and bastions (City) → full castle aesthetic (Fortified City).

---

## 9. Map, World, and Environment

- **Single handcrafted map.** Identical every playthrough. Every building's location is pre-designed by the developer.
- **The player never places buildings.** Available plots light up as buildable; player chooses what to activate. Spatial coherence is guaranteed by design.
- **Tier-gated areas:** parts of the map are visually inactive (overgrown, wild) until the relevant tier unlocks, then become available with their predetermined plots revealed.
- **Terrain matters mechanically:** forests give wood, water enables fishing/mills, mountains have stone/ore, fertile patches grow better crops. But terrain interacts with predetermined plots, not free placement.
- **Seasons:** spring, summer, autumn, winter, with meaningful gameplay rhythm (planting window, harvest rush, winter food pressure). Visual and audio shifts at each.
- **Weather events:** rare and gentle (one harsh winter every several years, occasional storm). Variety, not punishment.
- **Outside world:** travelling merchants unlock at Town tier — caravans visit periodically, buy surplus, sell rare goods. No diplomacy, no off-map politics.
- **Post-launch expansions:** additional handcrafted maps with distinct biomes (coastal, highland, etc.). Launch with one polished map.

---

## 10. Art & Audio Direction

### Visual

- **Stylized low-poly 3D**, warm storybook palette. Hearth & Hamlet aesthetic.
- **Rotatable fixed-angle camera with zoom.** Diorama feel.
- **Tier visual progression** hits five layers simultaneously: building models, road surfaces, decoration density, ground textures, lighting richness.
- **Day/night cycle** with warm interior lighting at night (firelight, candles, lamps progressing by tier).
- **Asset strategy:** placeholder art from Kenney.nl, Quaternius, Synty Studios during development. Commission custom art for signature buildings and tier-transition moments only.

### Audio

- **Layered adaptive music**, acoustic folk palette evolving toward choral/full medieval ensemble in higher tiers.
- **Tier transitions** get a real musical "moment" — short cue with visual celebration.
- **Heavy diegetic audio investment:** chopping wood, hammers, sheep, market chatter, church bells, wind in trees, hauler footsteps. Positional. This is the cheapest immersion lever.
- **Day/night and seasonal audio shifts:** crickets at night, rain in autumn, muffled snow audio in winter, birdsong in spring.
- **Feedback sounds:** building completion chime, gentle resource-shortage warning, satisfying click-to-boost.

---

## 11. UI & UX

- **Tutorial:** embedded campaign-style through Camp tier. Tooltips + searchable in-game codex thereafter.
- **Information density:** moderate (H&H level). Resource counters visible; click-for-detail on everything. Optional advanced view for production rates (post-launch consideration).
- **Persistent UI:**
  - Top bar: resource counters, current tier badge, tier progress, date/season.
  - Side: collapsible build menu, notification feed.
  - Camera shortcuts: jump-to-notification, recenter, jump-to-tier-up.
- **Notifications:** gentle (soft sound, persistent icon, no flashing red alerts).
- **Codex:** searchable, auto-unlocks entries as buildings/resources/mechanics are discovered. Critical for players returning after a week away.
- **Accessibility:** colorblind-friendly palette, scalable text, pause-anywhere, future difficulty toggles ("extra chill" mode post-launch).

---

## 12. Time & Pacing

- **No game speed controls.** Single flowing pace. Click-to-boost is the only acceleration tool.
- **Pause anytime** for planning or breaks.
- **Day/night cycle** runs continuously.
- **Seasons:** ~roughly equal length, exact duration tuned during development.
- **Autosave every 10 minutes** + manual save-and-quit anytime + multiple manual save slots.

---

## 13. Platforms & Technology

- **Launch platform:** PC, Windows + Linux (Steam Deck verified target), Mac if effectively free given engine choice.
- **Distribution:** Steam, likely via Early Access.
- **Engine:** **Godot 4** with GDScript. (Rationale: free, lightweight, excellent docs, friendly to non-coders, capable for stylized 3D, well-supported by Claude Code.)
- **Localization:** English-only at launch. All strings externalized from day one so additional languages can be added based on traction.
- **Saves:** local files, multiple slots, Steam Cloud sync.
- **Achievements:** ~30 at launch, covering tier progressions and milestone moments.

---

## 14. Explicitly Out of Scope

These have been considered and rejected for the foreseeable future:

- **Multiplayer of any kind.** Single-player only. Permanent decision.
- **Tactical combat / unit control.** Combat stays automated.
- **Free building placement.** Spatial coherence comes from predetermined plots.
- **Procedural maps at launch.** One handcrafted map; additional maps as post-launch content.
- **Deep villager psychology** (moods, relationships, mental breaks).
- **Mod support at launch.** Possible post-launch consideration.
- **Mobile or web platforms.**
- **Switch port.** Stretch goal post-launch via publisher relationship.
- **Cathedral-builder / megastructure gameplay** beyond the Fortified City tier aesthetic.

---

## 15. Open Questions

To be resolved during development:

- Exact tier-up thresholds and pacing curve.
- Specific list of comfort needs per tier and how they're satisfied.
- Tuning of click-to-boost (cooldown? per-building limit? bonus magnitude?).
- Trader caravan economy balance.
- Whether seasons have variable length or are fixed.
- Music budget — commissioned composer vs. royalty-free library.
- Decision point on Mac support (depends on Godot export effort).

---

## 16. Success Criteria

This game succeeds if:

- A player can sit down with no instructions, follow the Camp tier tutorial, and reach Settlement tier without confusion.
- Players play in 20-minute sessions *and* in 2-hour sessions and both feel right.
- Reviews use the words "cozy," "chill," "satisfying," "beautiful."
- Players post screenshots of their settlements at different tiers.
- The Steam page wishlist count grows steadily during Early Access without requiring marketing spend, indicating organic word-of-mouth.

---

*This document is the north star, not the spec. Refer to `VERTICAL_SLICE_PRD.md` for what to actually build first.*
