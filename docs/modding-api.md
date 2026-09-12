# Configuration API

Advanced Fluid Infrastructure publishes its tier table so other mods can retune
it. This is a back-end surface for mod authors: none of it is exposed as a
player-facing mod setting, and nothing here appears in the Factorio settings UI.

The mod does not try to stop you unbalancing it. If you want a 4000-tile iron
pipe, that is yours to make. What the API guarantees is that a change either
lands, or says in the log why it did not.

- [Quick start](#quick-start)
- [A complete example](#a-complete-example)
- [Load order](#load-order)
- [Tiers](#tiers)
- [Fields](#fields)
- [Defaults](#defaults)
- [Functions](#functions)
- [Rejections](#rejections)
- [Conflicts between mods](#conflicts-between-mods)
- [Troubleshooting](#troubleshooting)
- [What is not configurable](#what-is-not-configurable)
- [Stability](#stability)

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

## A complete example

A mod that makes the early game more forgiving and the late game less so.

`info.json`:

```json
{
  "name": "my-fluid-tweaks",
  "version": "1.0.0",
  "factorio_version": "2.1",
  "title": "My Fluid Tweaks",
  "author": "you",
  "dependencies": [
    "base >= 2.1.0",
    "? advanced-fluid-infrastructure >= 0.3.0"
  ]
}
```

`data.lua`:

```lua
if not mods["advanced-fluid-infrastructure"] then return end

local afi = require("__advanced-fluid-infrastructure__.api")

-- Ease the opening: vanilla pipe reaches further and undergrounds jump more.
afi.configure_tier("iron", {
  pipeline_extent = 40,
  underground_distance = 6,
}, "my-fluid-tweaks")

-- Tighten the endgame so foundation is a convenience, not an exemption.
afi.configure_tier("foundation", { pipeline_extent = 256 }, "my-fluid-tweaks")
```

That is the whole integration. The `? ` prefix makes the dependency optional, and
the `mods[...]` guard means your mod still loads when Advanced Fluid
Infrastructure is not installed.

## Load order

This mod publishes the API and builds its prototypes in `data.lua`, then writes
the final tier values over them in `data-updates.lua`. Your `data.lua` runs
between the two:

| Stage | Runs | State |
| --- | --- | --- |
| `data.lua` | Advanced Fluid Infrastructure | API published; prototypes built with default values |
| `data.lua` | **your mod** | **configure here** |
| `data-updates.lua` | Advanced Fluid Infrastructure | configured values written over the defaults |
| `data-updates.lua` | your mod | patch the finished prototypes directly |

Declaring the dependency is what puts your `data.lua` after this mod's. Without
it, load order is undefined and your configuration may run before the API
exists.

Prototypes exist from `data.lua` onward even though their values are not final
until `data-updates`. That is deliberate: anything scanning `data.raw` in
`data-updates` — Space Age's recycler generating a recycling recipe per recipe,
most of all — has to find them at the ordinary time. Only numbers move late, and
no prototype is created, renamed or removed in `data-updates`.

Configuring from `data-updates.lua` or later is too late — the values have
already been applied. At that point, edit `data.raw` yourself.

## Tiers

| Tier | Builds | Space Age only |
| --- | --- | --- |
| `iron` | the vanilla pipe, pipe-to-ground, pump and offshore pump, patched in place | |
| `steel` | pipe, pipe-to-ground, pump, offshore pump | |
| `rubber_lined` | pipe, pipe-to-ground, pump, offshore pump | |
| `reinforced` | pipe, pipe-to-ground, pump, offshore pump | |
| `low_pressure_steel` | pipe, pipe-to-ground, pump | yes |
| `calcite_lined` | pipe, pipe-to-ground, pump, offshore pump | yes |
| `tungsten` | pipe, pipe-to-ground, pump, offshore pump | yes |
| `foundation` | pipe, pipe-to-ground, pump, offshore pump | yes |
| `high_pressure_foundation` | pump, offshore pump | yes |

`iron` is the vanilla set, which this mod patches rather than replaces.
Configuring it retunes vanilla.

All nine tiers are present in the table in every load — only the prototypes
built from them are conditional — so configuring a Space Age tier in a base-game
load is harmless and needs no guard.

Call `afi.tier_names()` rather than hardcoding the list.

## Fields

| Field | Type | Applies to |
| --- | --- | --- |
| `pipeline_extent` | number | pipes, pipe-to-grounds, offshore pumps |
| `underground_distance` | number | pipe-to-grounds |
| `pumping_speed` | number | pumps, offshore pumps |

A tier only accepts the fields it actually uses. `high_pressure_foundation`
builds no pipe-to-ground, so it has no `underground_distance` and setting one is
rejected rather than accepted-and-ignored.

`steel.pipeline_extent` has a second effect worth knowing: it is also the
fluid-box extent this mod gives every assembling machine, furnace, mining drill
and rocket silo in the load. Raising it raises those too.

If you read a prototype's values during your own `data.lua`, you are reading the
defaults, not the configured result. Read the tier with `afi.get_tier` instead,
or do the reading from your `data-updates.lua`.

## Defaults

Current as of 0.3.0. `afi.get_tier(name)` is the authoritative source at
runtime; this table is for orientation.

| Tier | `pipeline_extent` | `underground_distance` | `pumping_speed` |
| --- | --- | --- | --- |
| `iron` | 24 | 4 | 1 |
| `steel` | 64 | 8 | 4 |
| `rubber_lined` | 96 | 12 | 6 |
| `reinforced` | 192 | 12 | 10 |
| `foundation` | 512 | 20 | 20 |
| `low_pressure_steel` | 64 | 8 | 4 |
| `calcite_lined` | 24 | 4 | 1 |
| `tungsten` | 64 | 8 | 4 |
| `high_pressure_foundation` | 512 | — | 60 |

## Functions

### `afi.configure_tier(tier, changes[, source])`

Merges `changes` into a tier. Returns `true` when every field applied, `false`
when any was rejected. Rejected fields are never written; accepted fields in the
same call still apply. See [Rejections](#rejections) for every case and what it
logs.

`source` is an optional label for the log. The data stage offers no way to ask
which mod is currently running, so pass your own name if you want it in the
trail.

Merging is deliberate, and assigning a whole tier table does **not** work:

```lua
afi.tiers.steel = { pipeline_extent = 120 }   -- silently has no effect
afi.configure_tier("steel", { pipeline_extent = 120 })   -- correct
```

The prototype pass binds each tier sub-table to a local at require time, so a
replaced table is never seen. Merging also means you do not have to restate a
tier's tints and resistances to change one number.

### `afi.get_tier(tier)`

The live tier table, not a copy. Reading is the intended use; writing to it
directly works but skips validation and the log line.

```lua
local current = afi.get_tier("steel").pipeline_extent
afi.configure_tier("steel", { pipeline_extent = current * 2 }, "my-mod")
```

### `afi.tier_names()`

Every tier name in this load, sorted. Use it instead of hardcoding the list:

```lua
for _, name in pairs(afi.tier_names()) do
  local tier = afi.get_tier(name)
  if tier.pipeline_extent then
    afi.configure_tier(name, { pipeline_extent = tier.pipeline_extent * 2 }, "my-mod")
  end
end
```

### `afi.version`

Currently `1`. Bumped only when an existing call's meaning changes — adding a
tier or a field does not bump it. See [Stability](#stability).

## Rejections

Nothing here raises an error or aborts the load. A rejection is a log line and a
`false` return: a third-party typo should not hard-fail somebody's game, but it
should not disappear either. Every message names both what was wrong and what
the valid options were.

Real output, from a load that makes each mistake in turn:

```
AFI: configure_tier("no-such-tier") ignored -- no such tier. Known tiers: calcite_lined, foundation, high_pressure_foundation, iron, low_pressure_steel, reinforced, rubber_lined, steel, tungsten
AFI: configure_tier("steel") ignored -- expected a table of changes, got string
AFI: configure_tier("steel") skipped unknown field "max_health". Configurable: pipeline_extent, pumping_speed, underground_distance
AFI: configure_tier("high_pressure_foundation") skipped underground_distance -- this tier has no underground_distance to set
AFI: configure_tier("steel") skipped pumping_speed -- expected number, got string
```

### "ignored" versus "skipped"

The verb tells you how much of your call died.

| Verb | Scope | Cases |
| --- | --- | --- |
| **ignored** | the whole call is abandoned; nothing is written | unknown tier; `changes` is not a table |
| **skipped** | that one field only; the rest of the call still applies | unknown field; tier does not carry the field; wrong type |

So this applies the extent and rejects only the second field:

```lua
afi.configure_tier("steel", { pipeline_extent = 120, max_health = 500 })
-- extent applied, max_health skipped, returns false
```

`configure_tier` returns `true` only when **every** field applied. A `false`
return therefore does not mean nothing happened — read the log to see which
fields landed.

### The cases

**Unknown tier.** Checked first, so `configure_tier("nope", "garbage")` reports
only the tier problem and never mentions the malformed second argument. The
message lists every valid name, which makes a typo self-diagnosing.

**`changes` is not a table.** Catches `configure_tier("steel", 120)` — a bare
value where a field table belongs.

**Unknown field.** Checked against the three configurable names. Worth knowing:
this fires for `icon_tint` **even though the tier really does have an
`icon_tint` key**. Cosmetic fields are deliberately outside this API; they are
read through a different path from the numbers that decide balance. "Unknown"
here means *not configurable*, not *not present*.

**The tier does not carry that field.** The subtle one. `high_pressure_foundation`
builds pumps only — there is no pipe-to-ground to read an underground distance —
so the tier's own keys are used as the schema. A field the defaults never
carried is one nothing would ever read, and accepting it would report success
for a change that cannot take effect.

**Wrong type.** Checked last, so `{ max_health = "x" }` reports the unknown
field rather than the type error. A field is rejected on the first ground that
applies.

### What is not rejected

There is no range or sanity checking. Negative, zero and absurd values all apply
silently. Balance is yours to set.

Three things fail silently because the API never sees them:

```lua
afi.tiers.steel = { pipeline_extent = 120 }          -- replaces; build never sees it
afi.get_tier("steel").pipeline_extent = 120          -- works, but no validation or log
```

and configuring from `data-updates.lua`, which logs a perfectly normal success
line — the values have simply already been applied by then. The API has no way
to know which stage it is being called from.

### One more message, from elsewhere

This shares the `AFI:` prefix but is not a `configure_tier` rejection:

```
AFI: tier-apply did not recognise <name>; it keeps its built-in defaults and ignores configuration
```

It comes from the pass that writes configured values onto prototypes, and means
a prototype name falls outside the derived `afi_<tier-with-hyphens>-<role>`
convention. It indicates this mod needs a code change, not your call site, and
is silent on a correct load.

## Conflicts between mods

Last writer wins, and every change is logged with its previous value:

```
AFI: steel.pipeline_extent 64 -> 120 (by my-mod)
AFI: steel.pipeline_extent 120 -> 80 (by someone-elses-mod)
```

If two mods configure the same tier, both lines appear in load order and the
later one stands. Nothing is blocked and no warning is raised — the log is the
whole conflict story, which is why passing `source` is worth the keystrokes.

To land after a specific mod, depend on it. To land after everything, do not use
this API at all: patch `data.raw` in your own `data-final-fixes.lua`.

## Troubleshooting

Everything this API refuses is written to the Factorio log, prefixed `AFI:`.
Find it at `%APPDATA%\Factorio\factory-debug.log` on Windows or
`~/.factorio/factorio-current.log` on Linux and macOS, and search for `AFI:`.

**My change did not apply, and there is no log line at all.** Your code did not
run, or it ran before the API existed. Check that you declared
`? advanced-fluid-infrastructure` in `info.json` — without it your mod may load
first — and that you are calling from `data.lua`, not `data-updates.lua`.

**There is a log line and it says `ignored` or `skipped`.** The call was
refused; [Rejections](#rejections) covers every case and what each one means.
The most common is a misspelled tier — names use underscores (`rubber_lined`)
while prototype names use hyphens (`afi_rubber-lined-pipe`).

**`configure_tier` returned `false` but something clearly changed.** Expected.
It returns `true` only when every field applied, so a call with one bad field
among several good ones returns `false` after applying the good ones. The log
says which were skipped.

**The log shows the change, but the entity is unchanged in game.** Startup
changes need a full restart, not a save reload. If you changed `steel` and are
looking at an assembling machine, that is expected — see [Fields](#fields).

**I read the prototype in my `data.lua` and saw the old value.** Expected:
prototypes are built with defaults and the configured values are written in
`data-updates`. Read `afi.get_tier` instead, or read from `data-updates.lua`.

**I added a tier through some other route and it ignores configuration.** Tier
prototype names are derived as `afi_<tier-with-hyphens>-<role>`. A name outside
that convention is reported as `tier-apply did not recognise ...` and keeps its
built-in defaults — see [Rejections](#rejections).

**My change applied, but nothing was logged and nothing was validated.** You
probably wrote to the table directly rather than through `configure_tier`. Both
work; only one leaves a trail. See
[What is not rejected](#what-is-not-rejected).

## What is not configurable

Tier tables also carry `icon_tint`, `entity_tint` and `resistances`. Those are
read through a different path and are rejected by `configure_tier`.

Also outside this API: recipes, technologies, unlock order, crafting-menu
layout, surface conditions, and the `next_upgrade` chain. Those are structural
rather than tunable, and a mod that wants to change them should patch `data.raw`
from its own `data-updates.lua`, which runs after this mod has built everything.

## Stability

While `afi.version` is `1`:

- `configure_tier`, `get_tier`, `tier_names` and `version` keep their current
  signatures and meanings.
- The nine tier names above keep their spellings.
- The three configurable fields keep their names, types and units.
- Default values may change between releases. Read them with `get_tier` rather
  than assuming them.

New tiers and new configurable fields may be added without a version bump, so
write against `tier_names()` rather than a hardcoded list.
