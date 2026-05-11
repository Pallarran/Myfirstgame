# Vision PRD — *Working Title: Hearthstead*

> **Status:** Living document. This captures the long-term vision for the full game. It is *not* what we build first. See `VERTICAL_SLICE_PRD.md` for the actual near-term scope.
>
> **Last updated:** 2026-05-11 (v2 — lineage system + emergent tiers + magic split)

---

## 1. Elevator Pitch

An **incremental cozy citybuilder** with magical realism, set in a stylized medieval world. The player guides a single settlement from a humble camp into a vibrant magic-touched kingdom by balancing convergent resource production chains, upgrading buildings level by level, and tending to a small population of named villagers.

The settlement evolves *organically* — buildings level up in place, then transform into their next-tier form when ready. The five visual stages (Camp → Settlement → Town → City → Fortified City) emerge as natural descriptions of the settlement's current state rather than gated tiers.

**Reference game (primary):** Hearth & Hamlet.
**Adjacent references:** Foundation, Banished (gentle pacing), Tiny Glade (visual coherence), Against the Storm (settlement growth feel).
**Magic touchstone:** Studio Ghibli-style folk magic — gentle, benevolent, atmospheric. Never combat.

---

## 2. Design Pillars (DO NOT VIOLATE)

1. **Chill, not stressful.** Failure is recoverable; pressure is gentle; the game never punishes a 10-minute break.
2. **Incremental progression as core dopamine loop.** Constant small improvements: level-ups, evolutions, new buildings, slowly accumulating crystals. Players should always have something small they're working toward.
3. **Visual progression as headline reward.** Settlement evolution from camp to kingdom is the big payoff, achieved through dozens of small in-place evolutions, not gated tier jumps.
4. **Balance over placement.** Players decide *what* to build and *when*. Locations are pre-designed; spatial coherence is guaranteed.
5. **Cozy aliveness.** Visible haulers, diegetic audio, named villagers, day/night and seasonal shifts.
6. **Engagement through optimization, not action.** Click-to-boost gathering, convergent production chains, gentle resource pressure. Never reaction-time.
7. **Magical realism, never high fantasy.** Magic is gentle, slow-acting, benevolent. Folk magic and rare spirits, not wizards, dragons, or combat spells.

---

## 3. Player Experience Goals

When a player closes the game after an hour, they should feel:

- **Relaxed** — like they've just done a satisfying creative activity.
- **Proud** — of how their settlement has grown.
- **Curious** — about what the next building evolution unlocks.
- **Attached** — to specific villagers, specific moments.
- **Enchanted** — touched by a small wonder (a fae visitor, a spell cast, the grove waking).

**Target session length:** Player-chosen. 20-minute relaxation sessions and 2-hour deep dives should both feel good.

---

## 4. Core Loops

### Minute-to-minute
1. Observe resource flows.
2. Notice imbalance, surplus, or a building near its next level.
3. Take a small action: activate a plot, upgrade a building, click-to-boost gathering, reassign workers.
4. Watch the consequence — level-up animation, new villager arriving, building evolving.
5. Repeat.

### Session-to-session
1. Approach a signature evolution moment.
2. The moment fires — camera swoops, music swells, settlement visibly transforms.
3. New buildings, policies, or magical capabilities unlock as consequences.
4. Settle into the new flow.

### End state
Settlement reaches "Fortified City" descriptive state. Endless sandbox continues with optional soft ambitions. No hard win screen.

---

## 5. Emergent Tier Model

Tiers are **descriptive labels**, not gates. Five tier names: Camp, Settlement, Town, City, Fortified City.

Current tier is **derived** from the state of signature plots:
- **Camp:** starting state.
- **Settlement:** central plot evolved to Communal Hearth.
- **Town:** central plot evolved to Market Square AND first processing chain operational.
- **City:** central plot evolved to Civic Plaza AND faith plot at Church.
- **Fortified City:** defensive perimeter exists AND Manor/Keep present.

Tier label is displayed in UI ("Your settlement: a thriving Town") but no "TIER UP!" modal interrupts play. Evolutions happen continuously and organically; signature ones get celebrated.

---

## 6. Plot Lineage System

The map contains predetermined **plots**, each tied to a **lineage** — a sequence of building forms across progression. Players activate plots by building; buildings level up in place; when a building reaches a threshold level, it **auto-evolves** to the next form.

### Anatomy of a building

- **Current form** (tier-appropriate identity, e.g., "Mayor's House")
- **Current level** (1–5 within that form)
- **Production output** (scales with level)
- **Visual appearance** (changes meaningfully at each level)
- **Evolution threshold** (e.g., level 5 of "Chief's House" auto-evolves to "Mayor's House" level 1)

### Anatomy of a plot

- **Fixed location** on the map.
- **A lineage** it belongs to.
- **Activation state** (dormant / activatable / built).
- **Optional dormancy condition** (magical plots stay hazy until conditions are met elsewhere).

### Two-axis progression

1. **In-place levels (incremental):** Player-driven, costs resources. Levels 1 → 5 within current form. Each level brings visible improvement and ~+25% output. This is the *incremental* loop.

2. **Form evolution (transformative):** Auto-triggered at threshold level (typically 5). Building transforms into the next form, returning to level 1 of the new form. These are the dramatic moments.

### Signature evolution moments

Of dozens of evolutions, ~10–15 are "signature moments" — camera focus, music swell, particle flourish, achievement-style notification. Most evolutions happen quietly with just a small chime.

Signature moments include:
- Campfire → Communal Hearth (first major evolution)
- Communal Hearth → Market Square (Town begins)
- Small Chapel → Shrine (faith deepens; magic hints intensify)
- Whispering Grove → Wise One's Cottage (magic awakens; crystals appear)
- Chief's House → Mayor's House → Town Hall (governance moments)
- Shrine → Church (Blessings significantly strengthen)
- Wise One's Cottage → Mage's Tower (Spells unlock)
- First defensive wall completion
- Mage's Tower → Arcane Sanctum (magical capstone)
- Church → Cathedral (faith capstone, often the visual centerpiece)

---

## 7. The 14 Plot Lineages

See `PLOT_LINEAGES.md` for full details. Summary:

| # | Lineage | Role | Plot count |
|---|---------|------|------------|
| 1 | **The Heart** (central plot) | Mood, gathering, civic identity | 1 |
| 2 | **The Chief's Seat** (governance) | Policies, late-game centerpiece | 1 |
| 3 | **The Sacred Height** (faith / Blessings) | Faith comfort, area buffs | 1 |
| 4 | **The Grove** (arcane / crystals) | Magic resource, Spells | 1 |
| 5 | **Forest Edge — Wood** | Wood → planks → furniture | 1 |
| 6 | **Forest Edge — Foraging/Hunting** | Food/meat/hides → leather | 1 |
| 7 | **Stream — Water/Mill/Bath** | Water, flour, hygiene | 1 |
| 8 | **Fields** | Vegetables, wheat | 2–3 instances |
| 9 | **Mountain — Stone** | Stone → masonry | 1 |
| 10 | **Mountain — Iron** | Iron → tools → weapons | 1 |
| 11 | **Housing** | Population capacity | 5–7 instances |
| 12 | **Storage** | Resource storage, haulers | 1–2 instances |
| 13 | **Trade** | Caravan interface | 1 |
| 14 | **Defense** (perimeter) | Raid protection | Multiple instances |

---

## 8. Magic System

Magic is split into **two separate subsystems**.

### Subsystem A: Blessings (effect-based)

- **Source:** The Sacred Height lineage (Standing Stone → Chapel → Shrine → Church → Cathedral).
- **Mechanic:** Passive area-of-effect buff emitted while staffed with clergy. Not a resource; not stockpiled.
- **Effects scale with form:**
  - Chapel: small mood bonus nearby.
  - Shrine: mood + occasional minor heal.
  - Church: settlement-wide mood + faster illness recovery + reduced attacker morale.
  - Cathedral: powerful settlement-wide package; possible passive crystal generation.
- **Theme:** communal, ambient, comforting.

### Subsystem B: Crystals + Spells (resource-based)

- **Source:** The Grove lineage (Ancient Stones [dormant] → Whispering Grove [dormant] → Wise One's Cottage → Mage's Tower → Arcane Sanctum).
- **Resource:** **Magic Crystals** — single type, stockpiled, slowly produced. Visually beautiful, glowing.
- **Production:**
  - Wise One's Cottage: 1 crystal per ~5 minutes when staffed and supplied with herbs.
  - Mage's Tower: faster production, can convert mundane resources (stone + herbs + time) into crystals.
  - Arcane Sanctum: significant passive production plus possibility of "Wonder" spells.
- **Crystals as luxury sink:** late-game economies have surplus mundane resources; converting them into crystals provides a meaningful sink.

### Spells

Cast at the Mage's Tower or above via a **Spellbook UI** — a simple menu listing known spells, crystal costs, and effects. Player triggers manually.

Initial catalog (~5–8 total, unlocked progressively):
- **Verdant Bloom:** Next harvest yields +100%.
- **Warding:** Next bandit raid significantly weaker, or skipped.
- **Beacon:** Doubles immigration chance for next month.
- **Gentle Rain:** Resolves drought event; small mood bonus.
- **Hearthlight:** All villagers gain mood for one week.
- **Forge-Fire:** All crafting buildings +200% for one day.
- **Awakening (late-game):** Triggers a magical creature visitor event.
- **Long-Sight (late-game):** Reveals upcoming events for next season.

Spells are **rare big moments**, not constant utility.

### Magical creatures and events

- Appear only in late tiers (City onwards).
- Always benevolent or neutral; never hostile.
- Examples: fae traveler asking for shelter (rewards with permanent small buff); spirit of the forest visiting when Grove reaches max (boosts forest yields); rare atmospheric sightings.

---

## 9. Resources

**Mundane (~15):**
- **Raw:** wood, stone, iron ore, coal, wheat, vegetables, fish, water, wool, herbs, hides, meat.
- **Processed:** planks, cut stone, iron ingots, flour, bread, ale, cloth, tools, weapons, leather, clothing.
- **Luxury (late game):** fine garments, books, decorative goods, fine furniture.

**Magical:**
- **Magic Crystals** — single type.

**Soft/effect (not in inventory):**
- **Blessings** — area buff from faith lineage.
- **Mood** — per-villager metric.
- **Comfort** — collective settlement metric.

**Storage:** physical storehouses with hauler villagers. Visible sacks/barrels carried around the settlement.

---

## 10. Villagers

- **Named individuals with light traits.** Name, portrait, age, 1–2 traits.
- **Needs scale with tier descriptor:**
  - Camp: food, shelter.
  - Settlement: + warmth, water.
  - Town: + variety in food, ale, Blessings access.
  - City: + faith/culture, decoration, social spaces.
  - Fortified City: + safety, full comfort, optional luxuries.
- **Growth:** primarily births; immigration as event/spell-driven bonus.
- **Lifecycle:** age, die of old age. Children become workers.
- **No deep simulation.**

---

## 11. Policies

Settlement-wide toggles unlocked progressively as the Chief's Seat lineage evolves. ~10–12 total across the game.

- **Settlement (Chief's House):** Rationing, Communal Work.
- **Town (Mayor's House):** Trade Priority, Apprenticeship, Crop Rotation.
- **City (Town Hall):** Public Feast Days, Sanitation Laws, Faith Observance.
- **Fortified City (Manor/Keep):** Standing Army, Open Gates, Royal Patronage.

---

## 12. Combat & Threats

- **Scaled with settlement state:** wolves early → bandit raids mid → small warbands late.
- **Always telegraphed and seasonal.**
- **Fully automated combat.** Build defenses, assign guards, ring alarm.
- **Recoverable consequences.**
- **Defense is one of the 14 lineages.**
- **Spells like Warding** offer magical alternatives.

---

## 13. Map & World

- **Single handcrafted map**, identical every playthrough.
- **All plots pre-designed.** Players activate, never place.
- **Plots evolve in-place** through their lineage.
- **Tier-locked plots visible but dormant** early — overgrown, hazy, with subtle hints (ancient stones, peculiar grove).
- **Fixed geographic features:** central clearing, stream, forest edges, mountain access, fertile patches, high ground (faith), magical grove/stones (arcane), caravan entry road.
- **Seasons:** spring, summer, autumn, winter with mechanical rhythm.
- **Weather:** rare and gentle.
- **Outside world:** travelling merchants when Trade lineage activates.
- **Post-launch:** additional handcrafted maps with distinct biomes.

---

## 14. Art & Audio Direction

### Visual

- **Stylized low-poly 3D**, warm storybook palette.
- **Rotatable fixed-angle camera with zoom.**
- **Each building has 5 visual levels within each form.** Significant work, but the headline reward.
- **Day/night cycle** with warm interior lighting.
- **Asset strategy:** Kenney.nl, Quaternius, Synty placeholders during development. Custom art for signature evolution moments and visual capstones.
- **Magic crystals** get distinct visual personality — soft glow, animated facets, colored light.

### Audio

- **Layered adaptive music**, acoustic folk evolving toward choral/ensemble at higher tiers. Magical chimes layer in as the Grove awakens.
- **Signature evolutions get bespoke musical cues.**
- **Heavy diegetic audio.** Positional.
- **Magical audio:** crystal chimes, Grove whispers, Spells have signature sounds.

---

## 15. UI & UX

- **Tutorial:** embedded through Camp tier. Tooltips + searchable codex thereafter.
- **Information density:** moderate (H&H level).
- **Persistent UI:**
  - Top bar: resources (mundane + crystals), tier descriptor, date/season.
  - Side: collapsible build menu, notification feed, policy menu (when unlocked).
  - **Spellbook:** accessed at Mage's Tower or above. Lists known spells with crystal costs and effects.
  - Camera shortcuts: jump-to-notification, recenter, jump-to-signature-moment.
- **Notifications:** gentle. Signature evolutions get richer notifications with "view it now" option.
- **Codex:** searchable, auto-unlocks entries.
- **Accessibility:** colorblind-friendly, scalable text, pause-anywhere, future "extra chill" toggle.

---

## 16. Time & Pacing

- **No game speed controls.** Click-to-boost only.
- **Pause anytime.**
- **Day/night cycle** continuous.
- **Seasons:** roughly equal length.
- **Autosave every 10 minutes** + manual save + multiple slots.

---

## 17. Platforms & Technology

- **Launch:** PC, Windows + Linux, Mac if free.
- **Distribution:** Steam, likely Early Access.
- **Engine:** **Godot 4** with GDScript.
- **Localization:** English-only at launch; architecture supports localization day one.
- **Saves:** local + Steam Cloud.
- **Achievements:** ~30 at launch.

---

## 18. Explicitly Out of Scope

- Multiplayer (permanent).
- Tactical / player-controlled combat.
- Combat magic.
- Free building placement.
- Procedural maps at launch.
- Deep villager psychology.
- Mod support at launch.
- Mobile or web.
- Switch port at launch.
- Megastructure gameplay beyond Cathedral/Manor/Sanctum.
- High fantasy elements (dragons, monsters, hostile creatures).
- Player-controlled wizards.

---

## 19. Open Questions

- Exact level thresholds for auto-evolution per lineage.
- Crystal production rates and spell costs (significant tuning needed).
- Whether Spellbook is tied to one building or accessible from anywhere once unlocked.
- Magical creature event design and frequency.
- Whether Blessings and Crystals ever interact (e.g., Cathedral generating crystals passively).
- Number of housing plot instances on the map.
- Whether Storage capacity is per-plot or global.

---

## 20. Success Criteria

- Reviews use "cozy," "chill," "incremental," "satisfying," "magical."
- Players post screenshots of their settlements at different evolutionary states.
- "I just want to upgrade one more building" is a sentiment players express.
- Signature evolution moments are noticed and remarked on, not skipped.
- Steam wishlist grows organically during Early Access.

---

*This document is the north star. See `VERTICAL_SLICE_PRD.md` for what to build first and `PLOT_LINEAGES.md` for full building catalog.*
