# Plot Lineages Catalog

> **Status:** Living reference. The authoritative catalog of every plot lineage in the game.
>
> **Purpose:** When designing or implementing any building, refer here first.
>
> **Last updated:** 2026-05-11

---

## How to read this document

Each lineage section contains:
- **Role**: what the lineage does in the game's economy / experience.
- **Plot count on map**: how many instances of this lineage exist on the full map (most are 1; housing and fields and defense have multiple).
- **Forms**: the sequence of buildings the lineage progresses through, with descriptive notes.
- **Levels per form**: each form has 5 levels. Level 5 auto-evolves to the next form (returning to level 1).
- **Outputs / effects**: what the building produces or does, scaling roughly +25% per level within a form.
- **Evolution requirement**: any condition beyond reaching level 5 that must be met for evolution.
- **Signature moments** (marked ⭐): evolutions designed as celebrated moments.
- **Notes**: design intent, art direction, special behaviors.

All numbers are **placeholders for tuning during development.** The structure is what matters; balance comes later.

---

## LINEAGE 1: The Heart

**Role:** The center of the settlement. Always exists. Mood, gathering, ceremonies, civic identity. Drives the tier descriptor displayed in the UI.

**Plot count on map:** 1 (the central plot).

**Always pre-built at game start.** Cannot be removed.

### Forms

**Form 1: Campfire**
- Levels 1–5. Each level adds: better stonework around the pit, more seating, eventually a covering.
- Effect: small warmth radius at night, mood gathering point.
- ⭐ Level 5 → evolves to Communal Hearth.

**Form 2: Communal Hearth**
- Larger fire pit with built shelter. Settlement-wide mood baseline.
- Levels 1–5. Each level adds: better shelter, banners, decorations.
- Effect: ambient mood for all villagers within visual range.
- ⭐ Level 5 → evolves to Market Square. **(Requirement: at least one Storage and one production building at form 2 elsewhere.)**

**Form 3: Market Square**
- Open plaza with stalls, wells, public space. Enables travelling merchants.
- Levels 1–5: more stalls, decoration, paving improvements.
- Effect: enables Trade lineage activation; settlement-wide mood; gathering hub at midday.
- ⭐ Level 5 → evolves to Civic Plaza. **(Requirement: faith plot at Church OR Trade plot at Market Stall.)**

**Form 4: Civic Plaza**
- Stone-paved plaza with fountain, statues, ornamental landscaping.
- Levels 1–5: increasing decoration density, lighting, gardens.
- Effect: large mood radius, hosts public events (feast days policy), faith bonus.
- ⭐ Level 5 → evolves to Grand Plaza.

**Form 5: Grand Plaza with Monument**
- Endgame visual centerpiece. Monument commemorates settlement history.
- Levels 1–5: monument grows, gardens expand, lanterns line the plaza at night.
- Effect: settlement-wide mood bonus, ceremonial events possible, atmospheric anchor.

**Notes:** This lineage drives tier descriptor changes. Its evolutions are among the most photographed moments — invest in visual quality. Music swells significantly during its evolutions.

---

## LINEAGE 2: The Chief's Seat

**Role:** Governance and policy unlocks. Visual landmark that grows into the settlement's largest residence/seat of power.

**Plot count on map:** 1 (prominent location, often on slightly elevated ground or facing the Heart plot).

**Activatable from start.** Player must choose to build.

### Forms

**Form 1: Elder's Tent**
- Levels 1–5: simple tent → tent with attached storage → small attached structure.
- Effect: enables the *first* unlocked policy (Communal Work). One policy slot.
- Level 5 → evolves to Chief's House.

**Form 2: Chief's House**
- Modest wooden home for the settlement's leader. Family-sized.
- Levels 1–5: visual upgrades to structure.
- Effect: 2 policy slots. Unlocks Rationing policy.
- ⭐ Level 5 → evolves to Mayor's House. **(Requirement: settlement is at Settlement tier or above.)**

**Form 3: Mayor's House**
- Larger timber-framed house. Visible from afar.
- Levels 1–5: porches, gardens, decoration.
- Effect: 3 policy slots. Unlocks Apprenticeship, Trade Priority policies.
- ⭐ Level 5 → evolves to Town Hall. **(Requirement: settlement is at Town tier or above.)**

**Form 4: Town Hall**
- Public civic building. Stone construction. Council chamber.
- Levels 1–5: clocktower added, courtyard expanded.
- Effect: 5 policy slots. Unlocks Public Feast Days, Sanitation Laws, Faith Observance.
- ⭐ Level 5 → evolves to Manor / Keep. **(Requirement: defense lineage active at Stone Wall or beyond.)**

**Form 5: Manor / Keep**
- Fortified manor house. The settlement's visual capstone alongside the Cathedral.
- Levels 1–5: towers added, courtyards expanded, banners.
- Effect: all policy slots unlocked (8+). Unlocks Standing Army, Open Gates, Royal Patronage.

**Notes:** This lineage's evolutions feel *political* — each one a celebration of governance maturing. The Manor/Keep should rival the Cathedral visually.

---

## LINEAGE 3: The Sacred Height

**Role:** Faith comfort need. Source of **Blessings** (area buff). Hints of magic. Often on visually elevated ground for silhouette purposes.

**Plot count on map:** 1 (on a hill or visually prominent location).

**Dormant at game start.** A simple standing stone is visible from the beginning, hinting at the plot's future.

### Forms

**Form 0 (Dormant): Standing Stone**
- A weathered megalith. Players can click for flavor text. Cannot be built on yet.
- Becomes activatable when: settlement reaches Settlement tier (Communal Hearth exists) AND has at least 8 villagers.

**Form 1: Small Chapel**
- Modest wooden structure. First clergy villager assigned here.
- Levels 1–5: ornamentation, small bell, side garden.
- Effect: Small mood bonus to villagers within range. Faith comfort need begins applying (so villagers want this).
- ⭐ Level 5 → evolves to Shrine. **(Requirement: Standing Stone plot has been the site for at least one full year.)**

**Form 2: Shrine**
- Stone-built shrine. Magical undertones become visible (subtle glowing motifs).
- Levels 1–5: motifs more prominent, stained glass appears, garden becomes a sacred grove.
- Effect: Stronger mood radius. Occasionally heals minor illness in villagers. Blessings begin affecting nearby buildings (small productivity bonus).
- ⭐ Level 5 → evolves to Church.

**Form 3: Church**
- Imposing stone church with bell tower. Bells ring on the hour during daytime.
- Levels 1–5: bell tower grows, more stained glass, gardens, larger congregation space.
- Effect: Settlement-wide mood bonus. Faster recovery from illness. Reduces morale of attacking raiders. Faith Observance policy becomes available.
- ⭐ Level 5 → evolves to Cathedral.

**Form 4: Cathedral**
- Grand cathedral with spires. The signature visual capstone of the settlement.
- Levels 1–5: spires extend, rose window appears, flying buttresses, gardens become formal grounds.
- Effect: Powerful settlement-wide Blessings package. Passively generates 1 Magic Crystal per ~20 minutes (a small interaction with the arcane subsystem). Hosts major ceremonies.

**Notes:** This building should be photographed by players. Audio: bells become richer and more layered as it evolves; choral music intensifies during its evolution moments.

---

## LINEAGE 4: The Grove

**Role:** Source of **Magic Crystals** (resource) and **Spells**. The magical heart of the settlement.

**Plot count on map:** 1 (in a forest grove or by ancient stones).

**Dormant at game start.** Ancient stones visible from the beginning as a mystery.

### Forms

**Form 0 (Dormant): Ancient Stones**
- A circle of weathered stones in a wild grove. Clickable for flavor only.
- Villagers occasionally walk past and look at them; rare ambient mention in tooltips.
- Becomes "stirring" when settlement reaches Town tier (Market Square exists).

**Form 1 (Dormant): Whispering Grove**
- Stones now visibly humming with a faint glow at night. Plants grow lushly here. Birds gather.
- Becomes activatable when: a villager with the "Curious" or "Wise" trait exists AND herbs are being produced.

**Form 2: Wise One's Cottage**
- Modest stone-and-thatch cottage built into the grove. A single villager (the Wise One) lives and works here.
- Levels 1–5: garden expands, drying herbs hang from rafters, soft glow visible at night.
- Effect: Produces **1 Magic Crystal per ~5 minutes** when staffed and supplied with herbs. Unlocks first spell: **Verdant Bloom**.
- ⭐ Level 5 → evolves to Mage's Tower.

**Form 3: Mage's Tower**
- A tower of stone with arched windows. Crystals glow visibly on the upper floor at night.
- Levels 1–5: tower grows taller, magical motifs increase, the grove around it becomes lusher.
- Effect: Crystal production doubles. Can convert mundane resources (stone + herbs + time) into crystals. **Unlocks the Spellbook UI** and additional spells: Warding, Beacon, Gentle Rain, Hearthlight.
- ⭐ Level 5 → evolves to Arcane Sanctum. **(Requirement: at least one Spell has been cast.)**

**Form 4: Arcane Sanctum**
- The grove is now manifestly magical. Floating crystals, soft chimes, occasional fae lights at night.
- Levels 1–5: more visual magic, the area becomes a destination villagers visit for awe.
- Effect: Significant passive crystal production. Unlocks late-game spells: Forge-Fire, Awakening, Long-Sight. Enables magical creature visitor events.

**Notes:** This lineage carries the game's magical identity. Audio: chimes increase, ambient music gains magical layers. Light: crystals cast colored light on nearby buildings at night.

---

## LINEAGE 5: Forest Edge — Wood

**Role:** Wood production → planks → fine furniture/luxury. Foundation of the settlement's construction.

**Plot count on map:** 1 (forest edge).

**Activatable from start.**

### Forms

**Form 1: Woodcutter's Lean-to**
- Simple shelter with axe rack.
- Levels 1–5.
- Effect: Wood production. Click-to-boost enabled.
- Level 5 → evolves to Woodcutter's Lodge.

**Form 2: Woodcutter's Lodge**
- Proper log cabin with attached drying yard.
- Levels 1–5.
- Effect: Higher wood production. Logs visibly stacked outside.
- Level 5 → evolves to Sawmill. **(Requirement: stream nearby — automatically satisfied by map design.)**

**Form 3: Sawmill**
- Water-powered sawmill. Produces planks (processed resource).
- Levels 1–5.
- Effect: Wood → planks at a fixed ratio. Wood throughput increases.
- ⭐ Level 5 → evolves to Carpenter's Workshop.

**Form 4: Carpenter's Workshop**
- Open workshop with skilled carpenters.
- Levels 1–5.
- Effect: Planks → furniture (luxury good). Can also produce specialty items (cart parts, building decoration).
- Level 5 → evolves to Master Carpenter's Guild.

**Form 5: Master Carpenter's Guild**
- Guild hall with apprentices and journeymen.
- Levels 1–5.
- Effect: Fine furniture (luxury). Possible occasional output of "ornate furniture" — a high-value trade good.

---

## LINEAGE 6: Forest Edge — Foraging/Hunting

**Role:** Food/meat/hides → leather → fine leather goods.

**Plot count on map:** 1 (forest edge, opposite side from Wood lineage).

**Activatable from start.**

### Forms

**Form 1: Forager's Hut**
- Lean-to with baskets. Click-to-boost enabled.
- Levels 1–5.
- Effect: Food (berries, mushrooms, edible roots). Sometimes produces herbs.

**Form 2: Forager's Cabin**
- Larger cabin with drying racks for herbs.
- Levels 1–5.
- Effect: Higher food output. Reliable herb production.
- Level 5 → evolves to Hunter's Lodge.

**Form 3: Hunter's Lodge**
- Cabin with smoking shed. Hunters bring meat and hides.
- Levels 1–5.
- Effect: Meat (food) + hides (raw material). Slightly seasonal.
- ⭐ Level 5 → evolves to Game Larder.

**Form 4: Game Larder**
- Cold storage and butchery. Smoked meats hang visibly.
- Levels 1–5.
- Effect: Refined meat outputs, increased hide yield.
- Level 5 → evolves to Master Huntsman's Lodge.

**Form 5: Master Huntsman's Lodge**
- Prestigious hunting lodge. Trophies visible.
- Levels 1–5.
- Effect: Fine leather + occasional trophy good (luxury).

---

## LINEAGE 7: Stream — Water/Mill/Bath

**Role:** Water access, wheat → flour, hygiene → ornamental capstone.

**Plot count on map:** 1 (on the stream).

**Activatable from start.**

### Forms

**Form 1: Water Carrier Post**
- Simple post with buckets near the stream.
- Levels 1–5. Click-to-boost.
- Effect: Water gathering.

**Form 2: Well**
- Stone well. Visible drawing mechanism.
- Levels 1–5.
- Effect: Centralized water access; nearby buildings gain small efficiency bonus.
- Level 5 → evolves to Mill.

**Form 3: Mill**
- Water-powered mill. Wheel turns visibly.
- Levels 1–5.
- Effect: Wheat → flour. Significant water access for nearby buildings.
- ⭐ Level 5 → evolves to Bathhouse.

**Form 4: Bathhouse**
- Stone bathhouse with steam visible on cold days.
- Levels 1–5.
- Effect: Mood bonus to all villagers. Reduces illness chance. Sanitation Laws policy works through this building.
- Level 5 → evolves to Ornamental Fountain.

**Form 5: Ornamental Fountain**
- Decorative fountain plaza. Children play here in summer.
- Levels 1–5.
- Effect: Significant mood radius. Visual capstone for the stream plot. Sounds of trickling water are loud and pleasant.

---

## LINEAGE 8: Fields (multiple instances)

**Role:** Vegetables and wheat production. Seasonal — these plots are most visible during summer/autumn.

**Plot count on map:** 2–3 instances on fertile patches.

**Activatable from Settlement tier (one of the first things a player builds in Settlement).**

### Forms

**Form 1: Vegetable Patch**
- Small garden plot with a tending villager.
- Levels 1–5.
- Effect: Vegetables (food). Year-round but small yield.

**Form 2: Vegetable Garden**
- Larger plot with raised beds and a small tool shed.
- Levels 1–5.
- Effect: Higher vegetable yield. Diverse crops visible (carrots, cabbage, onions).
- Level 5 → evolves to Farm.

**Form 3: Farm**
- Wheat field with farmhouse. Highly seasonal (plant spring, harvest autumn).
- Levels 1–5.
- Effect: Wheat (large seasonal yield). Vegetables continue alongside in a smaller plot.
- ⭐ Level 5 → evolves to Greater Farmstead.

**Form 4: Greater Farmstead**
- Larger farm with barn, livestock pen, multiple fields.
- Levels 1–5.
- Effect: Significant wheat + vegetables + small wool (sheep) + small dairy/meat.
- Level 5 → evolves to Manor Farm.

**Form 5: Manor Farm**
- Estate-tier farming operation with formal hedges and stone walls.
- Levels 1–5.
- Effect: Peak food production. Possible specialty crops (herbs cultivated as a crop).

**Notes:** Multiple instances mean different field plots can be at different forms simultaneously. Visually, fields are the most seasonal lineage — green in spring, gold in summer, harvested in autumn, fallow snow in winter.

---

## LINEAGE 9: Mountain — Stone

**Role:** Stone → cut stone → masonry decoration → architectural luxury.

**Plot count on map:** 1 (at a mountain or rocky outcrop).

**Activatable from start, but production initially slow.**

### Forms

**Form 1: Stone Gatherer**
- Simple gathering spot. Workers chip at exposed rock.
- Levels 1–5. Click-to-boost.
- Effect: Stone production (slow).

**Form 2: Quarry**
- Open quarry with terraced cuts. Workers visibly haul stone.
- Levels 1–5.
- Effect: Higher stone output.
- Level 5 → evolves to Stonemason's Yard.

**Form 3: Stonemason's Yard**
- Workshop with cut blocks stacked. Mason's tools visible.
- Levels 1–5.
- Effect: Stone → cut stone (processed). Required for higher-tier construction.
- Level 5 → evolves to Stone Carver's Workshop.

**Form 4: Stone Carver's Workshop**
- Workshop with statues, gargoyles, ornamental works in progress.
- Levels 1–5.
- Effect: Cut stone → masonry decoration (luxury good).
- Level 5 → evolves to Master Mason's Guild.

**Form 5: Master Mason's Guild**
- Prestigious guild. Contributes to Cathedral, Manor, Plaza capstone evolutions.
- Levels 1–5.
- Effect: Fine masonry. Accelerates evolution of signature stone buildings nearby.

---

## LINEAGE 10: Mountain — Iron

**Role:** Iron → ingots → tools/weapons → fine metalwork.

**Plot count on map:** 1 (mountain area).

**Activatable from Settlement tier.**

### Forms

**Form 1: Surface Diggings**
- Exposed iron deposit being worked by hand.
- Levels 1–5.
- Effect: Iron ore (slow).

**Form 2: Iron Mine**
- Proper mine entrance with cart tracks.
- Levels 1–5.
- Effect: Higher iron output. Occasional coal byproduct.
- Level 5 → evolves to Smithy. **(Requirement: Charcoal source — Forest Edge Wood at Sawmill or beyond, OR dedicated charcoal kiln if implemented.)**

**Form 3: Smithy**
- Forge with anvil, bellows, glowing fire visible.
- Levels 1–5.
- Effect: Iron + coal → tools + iron goods.
- ⭐ Level 5 → evolves to Armorer's Forge.

**Form 4: Armorer's Forge**
- Larger forge specialized in weapons and armor.
- Levels 1–5.
- Effect: Iron → weapons (required for guards). Continues producing tools.
- Level 5 → evolves to Master Smith's Guild.

**Form 5: Master Smith's Guild**
- Prestigious metalworking guild. Fine ironwork (luxury), specialty trade goods.
- Levels 1–5.
- Effect: Luxury metalwork, occasional masterwork items for high-value trade.

---

## LINEAGE 11: Housing (multiple instances)

**Role:** Population capacity. The most numerous lineage on the map.

**Plot count on map:** 5–7 instances distributed throughout the settlement.

**First two activatable from start. Others unlock as settlement grows.**

### Forms

**Form 1: Tent**
- Simple canvas tent. Houses 2 villagers.
- Levels 1–5: better materials, additions, small fenced yard.
- Effect: Houses 2.

**Form 2: Wooden Cabin**
- Log cabin with chimney. Houses 4.
- Levels 1–5: improvements, gardens, attached shed.
- Effect: Houses 4.
- Level 5 → evolves to Timber House.

**Form 3: Timber House**
- Timber-framed house with multiple rooms. Houses 6.
- Levels 1–5.
- Effect: Houses 6. Comfort need partially satisfied (decoration, space).
- ⭐ Level 5 → evolves to Stone Townhouse. **(Requirement: cut stone available.)**

**Form 4: Stone Townhouse**
- Multi-story stone house. Houses 8.
- Levels 1–5: balconies, gardens, more windows, ornamentation.
- Effect: Houses 8. Comfort + faith + culture needs satisfied.
- Level 5 → evolves to Manor Wing.

**Form 5: Manor Wing**
- Wealthy stone residence. Houses 10. Often the homes of skilled craftspeople.
- Levels 1–5.
- Effect: Houses 10. All comfort needs satisfied. Decorative architectural details.

**Notes:** With 5–7 plot instances, you'll often have housing at multiple forms simultaneously. Newer plots stay at Tent/Cabin while older plots evolve. This creates visual variety across the settlement.

---

## LINEAGE 12: Storage

**Role:** Resource storage capacity. Bases haulers (villagers who carry resources between buildings).

**Plot count on map:** 1–2 instances.

**First plot activatable late in Camp tier (a teaser of Settlement mechanics).**

### Forms

**Form 1: Storage Pile**
- Open-air covered pile with tarp. Holds basics.
- Levels 1–5.
- Effect: Small storage capacity. Limited resource types.

**Form 2: Storehouse**
- Wooden warehouse with hauler base.
- Levels 1–5.
- Effect: Storage for all basic resources. Bases up to 4 haulers.
- ⭐ Level 5 → evolves to Warehouse.

**Form 3: Warehouse**
- Larger warehouse with multiple bays.
- Levels 1–5.
- Effect: Large storage. Up to 8 haulers.
- Level 5 → evolves to Granary Complex.

**Form 4: Granary Complex**
- Specialized food storage + general warehouse. Stone construction.
- Levels 1–5.
- Effect: Food spoils far slower; large general storage.
- Level 5 → evolves to Vaulted Storehouse.

**Form 5: Vaulted Storehouse**
- Stone-vaulted complex with secure storage for luxury and magical goods.
- Levels 1–5.
- Effect: Massive storage. Can store crystals safely (relevant in lategame).

---

## LINEAGE 13: Trade

**Role:** Interface for travelling merchants. Buy/sell resources. Eventually trade routes.

**Plot count on map:** 1 (near a road or caravan entry point).

**Dormant until Town tier (Market Square activates this plot).**

### Forms

**Form 0 (Dormant):** Empty plot, perhaps a hitching post or signpost at the caravan entry road.

**Form 1: Trader's Tent**
- Simple market tent. Visiting merchants set up here occasionally.
- Levels 1–5.
- Effect: First buy/sell access. Merchants visit ~every 30 in-game days.
- Level 5 → evolves to Market Stall.

**Form 2: Market Stall**
- Permanent wooden market stall with awnings.
- Levels 1–5.
- Effect: More merchant types visit. Better prices. Visit frequency increases.
- ⭐ Level 5 → evolves to Trader's Post.

**Form 3: Trader's Post**
- Two-story building with offices and storage. Resident trader villager.
- Levels 1–5.
- Effect: Caravan routes can be established (player chooses what to import/export). Trade Priority policy works through this.
- Level 5 → evolves to Merchant's Guild.

**Form 4: Merchant's Guild**
- Stone-built guild hall. Multiple traders, occasional foreign visitors.
- Levels 1–5.
- Effect: Premium trade access, rare luxury imports, possibility of cultural events (foreign performers visit, etc.).

---

## LINEAGE 14: Defense (perimeter, multiple instances)

**Role:** Protection from raids. Visual completion of the "Fortified City" silhouette.

**Plot count on map:** Multiple instances around the settlement perimeter (typically 4–8 plots for wall sections + 2–4 for towers/bastions).

**Dormant until first threat appears (bandit raid telegraphed at Town tier).**

### Forms

Defense lineage works slightly differently — plots are wall segments and watchtowers. Forms represent material upgrades.

**Form 1: Wooden Palisade Segment**
- Sharpened log wall. Built section by section.
- Levels 1–5.
- Effect: Minor defensive value.

**Form 2: Watchtower**
- Wooden tower with a guard. Provides spotting (early warning).
- Levels 1–5.
- Effect: Reveals incoming raids earlier; small defensive value.
- Level 5 → evolves to Stone Wall Segment (if a wall plot) or Stone Bastion (if a tower plot).

**Form 3: Stone Wall Segment / Stone Bastion**
- Stone construction. Significant defensive value.
- Levels 1–5.
- Effect: Strong defensive value.
- ⭐ Level 5 → evolves to Fortified Wall / Bastion with Battlements.

**Form 4: Fortified Wall / Bastion with Battlements**
- Full stone fortification with crenellations.
- Levels 1–5.
- Effect: Endgame defensive value. Visually completes the "Fortified City" silhouette.

**Notes:** Defense is the most modular lineage. Multiple plot instances let the player build perimeter progressively. The settlement looks dramatically different once walls are completed — a major silhouette change. Optional gates (special plots) allow caravan entry.

---

## Lineage Interactions

Some lineages depend on outputs from others:

- **Smithy** needs coal (from Wood lineage at Sawmill+ producing charcoal byproduct, or dedicated kiln).
- **Bakery** (not a separate lineage in current spec — possibly added later, or part of housing/comfort buildings) needs flour from Mill, water from stream lineage, wood from Wood.
- **Cathedral** (form 4 of Sacred Height) benefits from cut stone from Stone lineage and masonry decoration from late Stone forms.
- **Mage's Tower** (Grove form 3) needs herbs from Foraging lineage.
- **Trade lineage** activates only when Heart reaches Market Square form.

These interactions create the convergent production chains promised in the design pillars.

---

## Visual Level System

Within each form, levels 1–5 represent **visible upgrades**:

- **Level 1:** the form's base state. Functional, modest.
- **Level 2:** minor improvements visible (e.g., shed added, fence built, small decoration).
- **Level 3:** clear visual improvement (e.g., chimney built, garden expanded, structure painted/sealed).
- **Level 4:** the form looks well-established and prosperous.
- **Level 5:** the form is at its peak. About to evolve. Often has a "ready to evolve" subtle visual cue (e.g., scaffolding appears, materials stacked nearby, workers visibly active on improvements).

When a building evolves, there's a brief animated transition (~5 seconds: construction sounds, dust cloud, then the new form is revealed at level 1). Signature evolutions get a longer, richer animation with camera focus.

---

## Plot Activation Rules Summary

| Plot/Lineage | Initial state | Becomes activatable when |
|--------------|---------------|--------------------------|
| Heart | Pre-built (Campfire L1) | N/A |
| Chief's Seat | Activatable | From start |
| Sacred Height | Dormant (Standing Stone visible) | Settlement tier + 8 villagers |
| Grove | Dormant (Ancient Stones visible) | Town tier + curious villager + herb production |
| Forest Wood | Activatable | From start |
| Forest Forage | Activatable | From start |
| Stream | Activatable | From start |
| Fields | Activatable | Settlement tier |
| Mountain Stone | Activatable | From start (slow production) |
| Mountain Iron | Activatable | Settlement tier |
| Housing (first 2 plots) | Activatable | From start |
| Housing (others) | Locked | Each unlocks at specific population thresholds |
| Storage (first) | Activatable | Late Camp tier |
| Storage (second) | Locked | Town tier |
| Trade | Dormant (signpost visible) | Heart reaches Market Square |
| Defense (perimeter) | Dormant | First raid telegraphed (Town tier) |

---

*This catalog is the authoritative source for what buildings exist in the game. When implementing a building, reference its entry here. When adding a new building, decide which lineage it belongs to first.*
