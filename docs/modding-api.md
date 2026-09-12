# Configuration API

Advanced Fluid Infrastructure publishes its tier table so other mods can retune
it. Nothing here is exposed as a player-facing mod setting: this is a back-end
surface for mod authors.

The mod does not try to stop you unbalancing it. If you want a 4000-tile iron
pipe, that is yours to make. What the API guarantees is that a change either
lands or tells you in the log why it did not.

## Quick start

Declare the dependency in your `info.json`:

```json
"dependencies": ["? advanced-fluid-infrastructure >= 0.3.0"]
```

Then configure from your own `data.lua`:

```lua
if mods["advanced-fluid-infrastructure"] then
  local afi = require("__advanced-fluid-infrastructure__.api")
  afi.configure_tier("steel", { pipeline_extent = 120 }, "my-mod")
end
```

It must be `data.lua`. See [Load order](#load-order).

## Load order

This mod publishes in `data.lua` and builds its prototypes in
`data-updates.lua`. That leaves exactly one window where a change can still
reach a prototype:

| Stage | Runs | State |
| --- | --- | --- |
| `data.lua` | Advanced Fluid Infrastructure | API published, nothing built |
| `data.lua` | **your mod** | **configure here** |
| `data-updates.lua` | Advanced Fluid Infrastructure | prototypes built from the final values |
| `data-updates.lua` | your mod | patch the finished prototypes directly |

Configuring from `data-updates.lua` or later is too late — the prototypes
already exist. At that point, edit `data.raw` yourself.

## Tiers

`iron`, `steel`, `rubber_lined`, `reinforced`, `foundation`,
`low_pressure_steel`, `calcite_lined`, `tungsten`, `high_pressure_foundation`.

`iron` is the vanilla pipe, pipe-to-ground, pump and offshore pump, which this
mod patches in place rather than replacing. Configuring it retunes vanilla.

The last four only have prototypes built from them under Space Age, but all
nine are present in the table in every load, so configuring one that is not
built is harmless and needs no guard.

Call `afi.tier_names()` rather than hardcoding the list.

## Fields

| Field | Type | Applies to |
| --- | --- | --- |
| `pipeline_extent` | number | pipes, pipe-to-grounds, offshore pumps |
| `underground_distance` | number | pipe-to-grounds |
| `pumping_speed` | number | pumps, offshore pumps |

Tier tables also carry `icon_tint`, `entity_tint` and `resistances`. Those are
cosmetic and read through a different path; they are not configurable here and
setting them is rejected.

`steel.pipeline_extent` has a second effect: it is also the fluid-box extent
this mod gives every assembling machine, furnace, mining drill and rocket silo
in the load.

## Functions

### `afi.configure_tier(tier, changes[, source])`

Merges `changes` into a tier. Returns `true` when every field applied, `false`
when any was rejected — an unknown tier, an unknown field, a wrong type, or a
`changes` that is not a table. Rejected fields are never written; accepted
fields in the same call still apply.

`source` is an optional label for the log. The data stage offers no way to ask
which mod is currently running, so pass your own name if you want it in the
trail.

Merging is deliberate. Assigning a whole tier table (`afi.tiers.steel = {...}`)
does **not** work: the prototype pass binds each tier sub-table to a local, so a
replaced table is never seen. Merging also means you do not have to restate a
tier's tints to change one number.

### `afi.get_tier(tier)`

The live tier table, not a copy. Reading is the intended use; writing to it
directly works but skips validation and the log line.

### `afi.tier_names()`

Every tier name in this load, sorted.

### `afi.version`

Currently `1`. Bumped only when an existing call's meaning changes — adding a
tier or a field does not bump it.

## Conflicts

Last writer wins, and every change is logged with its previous value:

```
AFI: steel.pipeline_extent 64 -> 120 (by my-mod)
```

If two mods configure the same tier, both lines appear in order. Nothing is
blocked.

## Using the global directly

`AdvancedFluidInfrastructure` is a plain global, published before any dependent
mod's `data.lua` runs, so `require` is a convenience rather than a requirement:

```lua
AdvancedFluidInfrastructure.configure_tier("steel", { pipeline_extent = 120 })
```

Both reach the same table.
