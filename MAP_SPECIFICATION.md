# Map Specification

> **Status:** Living reference. The authoritative spec for map layout, plot positions, and how buildings occupy their plots across their lineage.
>
> **Purpose:** When implementing the map scene or placing any building, refer here first. Read alongside `PLOT_LINEAGES.md`.
>
> **Last updated:** 2026-05-11

---

## 1. Map Overview

**Shape:** Rectangular.

**Size:** ~200m × 200m at full vision (placeholder for tuning during development). The vertical slice can use a smaller area (~80m × 80m) covering just the camp zone.

**Camera:** Rotatable fixed-angle camera with zoom. Players can pan and orbit but always view the map from above at a diorama angle.

**Coordinate convention used in this doc:** A simple **letter-number grid** (A–J columns, 1–10 rows), where each cell represents roughly 20m × 20m. This grid is for design reference only — actual Godot positions are decided when the map scene is built.

```
        A    B    C    D    E    F    G    H    I    J
      +----+----+----+----+----+----+----+----+----+----+
   1  |              FOREST           |    MOUNTAIN     |
      +              +    +    +    + +    +    +    + +
   2  |  FOREST  Wood  FOREST  GROVE* | MOUNT  Stone  M |
      +    +    +    +    +    +    + +    +    +    + +
   3  |  FOREST  FOREST  FOREST FOREST| MOUNT  Iron   M |
      +    +    +    +    +    +    + +    +    +    + +
   4  | Forage  ........................... ~ STREAM ~ |
      +    +    +    +    +    +    + +    +    +    + +
   5  | .........  Sacred*  ............ ~          ~  |
      +    +    +    +    +    +    + +    +    +    + +
   6  | .... House  Chief  HEART  ......~~          ~  |
      +    +    +    +    +    +    + +    +    +    + +
   7  | House  Storage  House  House  ..~ Trade  LAKE ⟶
      +    +    +    +    +    +    + +    +    +    + +
   8  | ........  Field   Field   ......~~        LAKE |
      +    +    +    +    +    +    + +    +    +    + +
   9  | House    ............... Field ~~  Stream      |
      +    +    +    +    +    +    + +    +    +    + +
  10  |  ==== DEFENSE PERIMETER ============= GATE ==== |
      +----+----+----+----+----+----+----+----+----+----+
                            ↓ caravan road south
```

This is a rough placement sketch — not pixel-perfect. The actual Godot scene will refine exact positions.

---

## 2. Geographic Features (Fixed)

These features define the map's character and constrain where certain plots can be:

### The Forest (top-left, ~rows 1–4, cols A–E)
A mixed deciduous forest with old growth. Provides cover for the Grove plot. Trees can be felled by the Wood lineage but the forest as a whole never depletes (lore: it's a vast wood beyond what's visible). Light filters through leaves; animals occasionally visible.

### The Mountain (top-right, ~rows 1–3, cols H–J)
A rocky peak forming the map's northern-right backdrop. Visually dominant — defines the skyline. The mountain is **not traversable**; it's a visual wall and a geographic anchor for the Stone and Iron lineages.

### The Stream (right-center, flowing south from mountain)
Originates from the mountain (~col I/J, row 3), flows southward along the right side of the map, and feeds into the lake at row 7. Provides water access for the Stream lineage plot, the Mill, and the Fishing potential. The stream is shallow and clear; wildlife visible at the banks.

### The Lake (right-center, partially off-map)
Sits at the base of the mountain, centered roughly on row 7, col J. **Approximately half of the lake extends off-map to the east**, suggesting it connects to a larger body of water. This is intentional — it's the **window onto the wider world**. Trading boats arrive from the eastern outflow and depart the same way. At higher Trade lineage forms, sailing ships become visible.

### The Sacred Hill (south-center, ~col D/E, row 5)
A gentle rise in the otherwise flat terrain. Hosts the Sacred Height lineage. Designed to give the Chapel/Church/Cathedral a strong silhouette visible from the central settlement. The hill is modest (perhaps 5m of elevation gain) — not a mountain, just a meaningful rise.

### The Central Clearing (center, ~cols D–G, rows 5–8)
The main developable area. Mostly flat, with grass and scattered light vegetation that disappears as the settlement grows. This is where the Heart, Chief's Seat, most Housing, Storage, and Fields are placed.

### The Caravan Road (south edge)
A dirt road enters from the south of the map (around col F, row 10), running into the settlement. Trading caravans arrive from here. Eventually evolves with the path system. The road is the player's land link to the outside world.

### Fertile Patches (scattered, south-center)
Plots of darker, richer soil where Fields can be placed. Mostly in the southern half of the map (rows 7–9), avoiding the forest and mountain.

---

## 3. Zone Definitions

The map is mentally divided into seven zones for design purposes:

| Zone | Region | Plots it contains |
|------|--------|-------------------|
| **Forest Edge — West** | Cols A–C, rows 2–4 | Wood, Forage/Hunt |
| **Deep Forest** | Cols B–D, row 3 (interior) | Grove (magical, dormant) |
| **Mountain Slope** | Cols H–J, rows 2–4 | Stone, Iron |
| **Stream Corridor** | Cols I–J, rows 4–9 | Stream lineage (water/mill/bath) |
| **Lake Edge** | Cols I–J, rows 7–8 | Trade (with maritime evolution) |
| **Settlement Core** | Cols C–G, rows 5–8 | Heart, Chief's Seat, Storage, several Housing plots |
| **Southern Fields** | Cols C–G, rows 8–9 | Field plots, additional Housing |
| **Sacred Approach** | Cols D–E, row 5 | Sacred Height (Chapel→Cathedral) |
| **Perimeter** | Outer edge of buildable area | Defense plots, main southern gate |

---

## 4. Full Plot Layout Table

All plot instances on the map (~25 total). Each row is one buildable plot.

| Plot ID | Lineage | Zone | Grid (approx) | Footprint (largest form) | Orientation | Geographic constraint | Notes |
|---------|---------|------|---------------|--------------------------|-------------|----------------------|-------|
| `plot_heart_01` | Heart | Settlement Core | F6 | 30m × 30m (Grand Plaza) | radial (no facing) | Center of buildable area | Pre-built (Campfire L1). Expands outward across forms (B2 model). |
| `plot_chief_01` | Chief's Seat | Settlement Core | E6 | 16m × 16m (Manor/Keep) | faces SE toward Heart | Slightly elevated ground preferred | Activatable from start. |
| `plot_sacred_01` | Sacred Height | Sacred Approach | D5 | 24m × 18m (Cathedral) | faces E toward Heart | Must be on Sacred Hill | Dormant (Standing Stone) at start. |
| `plot_grove_01` | Grove | Deep Forest | C3 | 18m × 18m (Arcane Sanctum) | faces S | Must be in forest interior | Dormant (Ancient Stones) at start. |
| `plot_wood_01` | Forest Edge — Wood | Forest Edge West | B2 | 14m × 10m (Master Carpenter's Guild) | faces E (toward settlement) | Must border forest | Activatable from start. |
| `plot_forage_01` | Forest Edge — Forage/Hunt | Forest Edge West | A4 | 12m × 10m (Master Huntsman's Lodge) | faces E | Must border forest | Activatable from start. |
| `plot_stream_01` | Stream — Water/Mill/Bath | Stream Corridor | I5 | 14m × 14m (Ornamental Fountain) | faces W toward settlement | Must be on stream | Activatable from start. |
| `plot_stone_01` | Mountain — Stone | Mountain Slope | H2 | 16m × 12m (Master Mason's Guild) | faces SW | Must border mountain | Activatable from start. |
| `plot_iron_01` | Mountain — Iron | Mountain Slope | I3 | 16m × 12m (Master Smith's Guild) | faces W | Must border mountain | Activatable from Settlement tier. |
| `plot_trade_01` | Trade | Lake Edge | I7 | 18m × 14m + dock | faces E toward lake | Must be at lake edge with water access | Dormant at start. **Maritime evolution: dock appears at form 3.** |
| `plot_housing_01` | Housing | Settlement Core | E7 | 10m × 8m (Manor Wing) | faces SE | None | Activatable from start. |
| `plot_housing_02` | Housing | Settlement Core | G7 | 10m × 8m (Manor Wing) | faces SW | None | Activatable from start. |
| `plot_housing_03` | Settlement Core | D7 | 10m × 8m | faces E | None | Locked. Unlocks at pop. 10. |
| `plot_housing_04` | Housing | Settlement Core | C6 | 10m × 8m | faces E | None | Locked. Unlocks at pop. 15. |
| `plot_housing_05` | Housing | Southern Fields | C9 | 10m × 8m | faces N | None | Locked. Unlocks at pop. 25. |
| `plot_housing_06` | Housing | Settlement Core | G8 | 10m × 8m | faces N | None | Locked. Unlocks at pop. 40. |
| `plot_housing_07` | Housing | Settlement Core | F8 | 10m × 8m | faces N | None | Locked. Unlocks at pop. 60. |
| `plot_storage_01` | Storage | Settlement Core | D7 | 14m × 10m (Vaulted Storehouse) | faces E | Near production buildings | Activatable in late Camp tier. |
| `plot_storage_02` | Storage | Settlement Core | F8 | 14m × 10m | faces N | Near production | Locked. Unlocks at Town tier. |
| `plot_field_01` | Fields | Southern Fields | E8 | 20m × 16m (Manor Farm) | radial (field) | Must be on fertile patch | Activatable from Settlement tier. |
| `plot_field_02` | Fields | Southern Fields | F8 | 20m × 16m | radial | Fertile patch | Activatable from Settlement tier. |
| `plot_field_03` | Fields | Southern Fields | H9 | 20m × 16m | radial | Fertile patch | Locked. Unlocks at Town tier. |
| `plot_defense_01` to `plot_defense_08` | Defense | Perimeter | Outer ring | 6m × 4m segments | faces outward | Perimeter only | Dormant. Activate when first raid telegraphed. |
| `plot_defense_gate_01` | Defense (Gate) | Perimeter — South | F10 | 10m × 4m | faces S | South perimeter, on caravan road | Dormant. Special gate plot. |

**Total: ~25 plots** across all lineages.

> **Note on collisions in the grid:** A few plots show overlapping grid cells (e.g., `plot_housing_03` and `plot_storage_01` both note D7). This is fine — the grid is approximate and each plot's actual Godot position will be slightly offset. Use the grid for "rough zone" and footprint sizes for actual reservation.

---

## 5. Per-Form Placement Rules (Model 3 — Anchor-and-Grow with Camouflage)

Every plot has a fixed **anchor point** at its center. Buildings always grow outward from this anchor.

### How a building occupies its plot at each form

**The anchor is sacred.** No matter what form a building takes, its origin remains the anchor point. The campfire is at the anchor. The Communal Hearth is at the anchor. The Market Square is centered on the anchor. The Civic Plaza extends around the anchor. The Grand Plaza is centered on it.

**Footprint grows outward symmetrically (or asymmetrically, per design notes below).** A small form (Tent, Campfire) occupies a small footprint. As forms evolve, the footprint expands outward from the anchor.

**Reserved space.** Each plot reserves enough space for its **largest form**. This means the visual area around small forms can feel empty.

**Camouflage fills the empty space.** This is the key innovation. When a building is at a small form, surrounding **camouflage elements** fill the reserved space to make it feel cozy and right-sized:

- A **Level 1 Tent** (3m × 3m) on a Housing plot (reserved 10m × 8m) is surrounded by:
  - A small fenced garden plot (NW corner)
  - A stack of firewood (NE corner)
  - A drying rack with cloths (SW corner)
  - A simple wooden bench (SE corner)
  - A worn dirt path leading to the tent flap

- A **Level 1 Campfire** at the central plot (5m × 5m of actual fire pit) on a reserved 30m × 30m plaza:
  - A circle of log seats around the fire (extending the visual occupation to ~10m)
  - Tents (which are housing plots adjacent, naturally)
  - A small woven mat for elders nearby
  - A simple hide-stretching frame

- A **Level 1 Stone Gatherer** (5m × 5m) on a Mountain Stone plot (reserved 16m × 12m):
  - Loose piles of unfinished stone around the gathering point
  - A few tools leaned against rocks
  - A small lean-to for shelter

**Camouflage disappears as the form evolves.** When the building grows to fill more of the reserved space, the camouflage elements are gradually absorbed or replaced by the building itself or its appropriate larger-scale elements.

### Example transition: Housing plot from Tent to Wooden Cabin

| Form | Building footprint | Camouflage |
|------|-------------------|------------|
| Tent (L1) | 3m × 3m | Garden + firewood stack + drying rack + bench + path |
| Tent (L5) | 3.5m × 3.5m + small extension | Same as above, with garden expanded |
| **Evolution moment** | (animation: scaffolding appears, dust, ~5s, cabin reveals) |
| Cabin (L1) | 6m × 6m | Garden remains; firewood stack becomes a proper woodshed; drying rack moved to outside the cabin wall; bench remains |
| Cabin (L5) | 8m × 6m + porch | Garden expanded; firewood shed grown; small ornaments added |
| **Evolution moment** | (richer animation) |
| Timber House (L1) | 8m × 8m | Garden formalized with fence; small flowerbox; path becomes gravel |
| ... and so on |

The same anchor point, growing outward, with surrounding elements maturing alongside the building.

### The Heart plot is special (B2 model — radial expansion)

The central Heart plot is the only plot that expands **dramatically and radially**. Other plots respect a maximum reserved footprint; the Heart's footprint grows so much that the plot's reserved area is the **largest on the map** (~30m × 30m).

- **Campfire forms (1–5):** ~5m visible occupation, with camouflage extending to ~12m radius.
- **Communal Hearth forms:** ~10m visible occupation, with covered structures, banners, and seating extending to ~15m radius.
- **Market Square forms:** ~18m × 18m of actual plaza with stalls.
- **Civic Plaza forms:** ~24m × 24m of paved plaza with fountain, gardens, lanterns.
- **Grand Plaza forms:** Full 30m × 30m plaza with monument as visual centerpiece.

**Nearby plots are set back from the Heart's reserved space** by at least 3m to allow paths and breathing room around the central area. This is why the Settlement Core zone clusters tightly *near* the Heart but never *in* its reserved space.

---

## 6. Orientation Rules

Most plots have a defined "facing direction" — the direction the building's entrance and main façade point. This matters for visual coherence:

- **Buildings face toward the Heart** when on the settlement's periphery. Doors and windows face inward. This creates a visual sense of a community oriented around its center.
- **Resource buildings face their resource.** The Mill faces the stream. The Sawmill faces the forest. The Stone Yard faces the mountain. Workers visibly come and go between building and resource.
- **The Trade plot faces the lake** at every form. This emphasizes the maritime connection.
- **The Sacred Height plot faces the Heart** so that approaching the Chapel/Cathedral from the central settlement feels natural.
- **Defensive plots face outward** (away from the settlement). They guard outward.

When the orientation is "radial," there's no single facing — the building (Heart's plaza forms, fields) is approachable from all sides.

---

## 7. The Maritime Trade Dimension (Trade Lineage Expansion)

This is a refinement to the Trade lineage based on the map's lake feature. **Update `PLOT_LINEAGES.md` on next pass to reflect this.**

The Trade lineage now has a maritime dimension that emerges at higher forms:

| Form | Land trade | Water trade |
|------|-----------|-------------|
| **Form 0 (Dormant)** | Signpost at caravan road | Nothing |
| **Form 1: Trader's Tent** | Caravans visit ~every 30 days from south | None |
| **Form 2: Market Stall** | Caravans more frequent | Occasional small rowboat from the lake (rare event) |
| **Form 3: Trader's Post** | Regular caravan trade | **Small dock visible**; small sailboats arrive every few weeks |
| **Form 4: Merchant's Guild** | Premium caravan trade | **Proper harbor with regular sailing ships**; foreign merchants arrive from the lake outflow |

**Visual moments:**
- The first time a small boat arrives from the lake outflow is a small magical moment ("There's a boat coming in!").
- The first time a full sailing ship arrives at the harbor is a *signature* visual moment — camera focus, music swell, foreign merchant disembarks with exotic goods.

**Mechanical impact:**
- Each form's trade improvement is both land and water at higher tiers.
- Maritime trade unlocks unique luxury imports unavailable from land caravans (foreign spices, silk-equivalents, rare crystals from distant grottoes).

This makes the lake a real gameplay element, not just scenery.

---

## 8. Path System (Settlement Infrastructure)

Paths are **not a lineage**. They are **settlement-wide infrastructure** that upgrades all paths simultaneously when the player triggers the upgrade.

### Path layout (handcrafted)

Paths are pre-designed and drawn as part of the map scene:
- A path from each active plot to the Heart plot.
- A path connecting the Heart to the southern gate (caravan road).
- A path from the Heart to the lake (Trade plot).
- A "ring path" loosely circling the settlement core, connecting nearby plots laterally.
- Side paths to outer plots (Wood, Forage, Mines) branching from the ring.

Paths are visible from the moment a plot is activated. Inactive plot's paths are dormant (overgrown).

### Path upgrade levels (settlement-wide)

The player can upgrade all paths at once via a "Roadways" menu (accessible from the Chief's Seat once it reaches form 2 — Chief's House):

| Level | Path appearance | Effect |
|-------|----------------|--------|
| **1: Dirt Path** | Bare worn earth | Base movement speed |
| **2: Trampled Path** | Compacted dirt with edges | +5% villager/hauler speed |
| **3: Gravel Path** | Loose gravel, clearly defined edges | +15% speed; less mud in rain |
| **4: Cobblestone Path** | Set cobblestones, drainage | +30% speed; visual upgrade to "Town" feel |
| **5: Paved Street with Curbs** | Cut stone paving, curbs, occasional lanterns | +45% speed; "City" feel; lanterns light paths at night |

Each upgrade costs resources scaled to current settlement size. The "Roadways" upgrade is one of the most satisfying single decisions a player can make — the whole settlement transforms visually in one moment.

### Why not a lineage

- Lineages are buildings the player activates one at a time.
- Paths are continuous, settlement-wide, and feel wrong to manage segment-by-segment.
- A single "upgrade all paths" decision is more satisfying than 30 individual decisions.
- Implementation is simpler: paths are a `path_level` integer on the settlement state, and the renderer swaps path materials based on that value.

---

## 9. Defense Perimeter

The defense plots aren't a single line — they form a **rough ring** around the buildable area. The actual layout:

- **South gate** (`plot_defense_gate_01`) at F10, on the caravan road. This is the main entry/exit for land travel.
- **Defense segments** distributed around the perimeter, with denser placement where threats are more likely (south side, where bandits come from).
- The **north perimeter (against the mountain)** doesn't need walls — the mountain is the wall.
- The **east perimeter (against the lake)** may have shoreline walls or a small fortified dock at higher Trade lineage forms.
- **Total perimeter plots:** 6–8 wall segments + 1 main gate.

When defense plots are dormant, the perimeter is suggested by natural features (hedgerows, scrub, slight earth banks). As walls are built, those features are replaced by actual defenses.

---

## 10. Implementation Notes for Claude Code

When implementing this map in Godot:

### The map is one scene
- A single `World.tscn` scene at the project's scene root.
- Contains the terrain mesh (forest, mountain, stream, lake, hills, fertile patches) as a base.
- Contains all **plot nodes** as child nodes of a `Plots` container.
- Contains all **path segments** as child nodes of a `Paths` container.
- Contains a **lighting node** for day/night cycle.
- Contains **camera control node** for player camera.

### Each plot is a node
- A `Plot` class (extends `Node3D`) with these properties:
  - `plot_id` (e.g., `"plot_heart_01"`)
  - `lineage` (a `LineageResource` reference — `.tres` file)
  - `anchor_position` (the plot's center anchor, used for placement)
  - `reserved_footprint` (Vector2: max width/depth needed)
  - `orientation` (radians or a vector for facing direction)
  - `activation_state` (enum: Dormant / Activatable / Built)
  - `current_form_index` (which form of the lineage is currently built)
  - `current_level` (1–5)
  - `current_building_instance` (the spawned building scene)
  - `camouflage_instance` (the surrounding camouflage props for the current form)

### Building scenes
- Each form has its own scene file (e.g., `WoodcutterLeanTo.tscn`, `WoodcutterLodge.tscn`).
- Levels within a form are handled by **enabling/disabling child nodes or props** on the same scene, not by separate scenes. This avoids 70+ separate scene files.
- Camouflage is a separate scene per form (`WoodcutterLeanTo_Camouflage.tscn`) that's spawned alongside the main building.

### Path rendering
- Paths are a single mesh with multiple material slots; the material swaps based on `GameState.path_level`.
- Or: paths are individual segment scenes, each with their own material that's swapped on upgrade. Either works; the first is more efficient.

### Don't hardcode plot positions
- Place plots in the Godot editor visually.
- Save their positions as part of the scene.
- The lineage data (in `.tres` files) defines what the plot *can* become; the scene defines *where* it is.

---

## 11. Vertical Slice Map (Camp Tier Subset)

For Slice 1, the map can be a **smaller subset** — focus only on the area that's relevant to Camp tier:

- **Used zones:** Forest Edge — West (just `plot_wood_01` and `plot_forage_01`), Stream Corridor (just `plot_stream_01`), Settlement Core (Heart, 2 housing plots, Chief's Seat optional).
- **Visible but inactive:** the rest of the map can be visible as terrain (forest extends, mountain visible in distance, stream visible, lake visible) but plots beyond Camp tier scope are not implemented.
- **Effective playable area:** ~60m × 60m of actual usable plots, with the rest as visual backdrop.

This keeps Slice 1 art and implementation work tractable while showing the full vision of the world.

---

## 12. Open Questions

To be resolved during development:

- Exact pop. thresholds for housing plot unlocks.
- Whether the Sacred Hill should be more pronounced (more elevation = more visual drama, but harder to render cleanly).
- Whether trade ships' arrival times should be predictable (scheduled) or atmospheric (occasional surprise).
- Where to place the trader's path — directly from the dock to the Heart, or through the settlement?
- Whether the lake's outflow should occasionally feature passing ships that don't stop (atmospheric storytelling).
- Whether the south gate should have a specific "ceremonial" visual (e.g., decorations on tier-ups).

---

## 13. Things This Doc Doesn't Cover (Yet)

- **Pathfinding for villagers and haulers** — Godot's NavigationServer3D handles this; the design just needs to ensure paths are valid navmesh.
- **Day/night lighting specifics** — covered in the future ART_DIRECTION doc.
- **Seasonal visual variations** — covered in future SEASONS doc.
- **Camera behavior on signature evolution moments** — covered in future UI_INTERACTION doc.

These will be added as their own documents when they become relevant to implement.

---

*Refer to `PLOT_LINEAGES.md` for what each plot's lineage contains. Refer to `VISION_PRD.md` for high-level design intent. This document is the bridge between them and the actual Godot scene.*
