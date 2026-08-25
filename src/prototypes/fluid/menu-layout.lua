-- Crafting menu layout for every item this mod owns, plus the vanilla items it
-- adopts, applied in one place after all tiers exist.
--
-- Vanilla puts pipe, pipe-to-ground and pump in a single
-- `energy-pipe-distribution` row alongside every electric pole, and offshore
-- pump in `extraction-machine`. This mod multiplies each into a tier ladder,
-- which makes those rows unreadable.
--
-- Rows are grouped by role. Pipe and pipe-to-ground are the same job above and
-- below ground, so they share a row. Pumps move fluid already in the network;
-- offshore pumps extract it, which is why vanilla files them as an extraction
-- machine and why they stay in the production group here rather than moving
-- into logistics.
--
-- Planet-restricted variants sit in a secondary row directly beneath the main
-- progression they branch off, rather than interleaving with it. The one
-- exception is the tungsten offshore pump: it is the only planet variant of its
-- family, so it shares the main offshore row rather than sitting alone in a
-- row of its own.
--
-- The `d-b-*` and `c-a-*` prefixes are reserved for this mod. Advanced Energy
-- Grid holds `d-a-*` in the same logistics group and Advanced Power
-- Infrastructure holds `b-a-*` in production, so no two mods interleave rows.

local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local subgroups = {
  { name = "afi_pipe",         group = "logistics",  order = "d-b-a" },
  { name = "afi_pump",         group = "logistics",  order = "d-b-c" },
  { name = "afi_offshore-pump", group = "production", order = "c-a-a" },
}

-- Every planet-restricted variant is a Space Age tier, so these rows would be
-- empty in a base-game load.
if optional_dependencies.has_space_age then
  table.insert(subgroups, { name = "afi_pipe-planet",          group = "logistics",  order = "d-b-b" })
  table.insert(subgroups, { name = "afi_pump-planet",          group = "logistics",  order = "d-b-d" })
end

local defined = {}
for _, s in pairs(subgroups) do
  defined[s.name] = true
  data:extend({ { type = "item-subgroup", name = s.name, group = s.group, order = s.order } })
end

-- item name -> { subgroup, family letter fixing position in the row, tier }
local placement = {
  -- main progression: pipes and pipe-to-grounds share one row
  ["pipe"]                             = { "afi_pipe", "a", 1 },
  ["afi_steel-pipe"]                   = { "afi_pipe", "a", 2 },
  ["afi_rubber-lined-pipe"]            = { "afi_pipe", "a", 3 },
  ["afi_reinforced-pipe"]              = { "afi_pipe", "a", 4 },
  ["afi_foundation-pipe"]              = { "afi_pipe", "a", 5 },
  ["pipe-to-ground"]                   = { "afi_pipe", "b", 1 },
  ["afi_steel-pipe-to-ground"]         = { "afi_pipe", "b", 2 },
  ["afi_rubber-lined-pipe-to-ground"]  = { "afi_pipe", "b", 3 },
  ["afi_reinforced-pipe-to-ground"]    = { "afi_pipe", "b", 4 },
  ["afi_foundation-pipe-to-ground"]    = { "afi_pipe", "b", 5 },

  -- planet-restricted pipe branches
  ["afi_low-pressure-steel-pipe"]              = { "afi_pipe-planet", "a", 1 },
  ["afi_heat-resistant-pipe"]                  = { "afi_pipe-planet", "a", 2 },
  ["afi_tungsten-pipe"]                        = { "afi_pipe-planet", "a", 3 },
  ["afi_low-pressure-steel-pipe-to-ground"]    = { "afi_pipe-planet", "b", 1 },
  ["afi_heat-resistant-pipe-to-ground"]        = { "afi_pipe-planet", "b", 2 },
  ["afi_tungsten-pipe-to-ground"]              = { "afi_pipe-planet", "b", 3 },

  -- pumps
  ["pump"]                                  = { "afi_pump", "a", 1 },
  ["afi_steel-pump"]                        = { "afi_pump", "a", 2 },
  ["afi_rubber-lined-pump"]                 = { "afi_pump", "a", 3 },
  ["afi_reinforced-pump"]                   = { "afi_pump", "a", 4 },
  ["afi_foundation-pump"]                   = { "afi_pump", "a", 5 },
  ["afi_high-pressure-foundation-pump"]     = { "afi_pump", "a", 6 },
  ["afi_low-pressure-steel-pump"]           = { "afi_pump-planet", "a", 1 },
  ["afi_heat-resistant-pump"]               = { "afi_pump-planet", "a", 2 },
  ["afi_tungsten-pump"]                     = { "afi_pump-planet", "a", 3 },

  -- offshore pumps stay in the production group, as vanilla files them
  ["offshore-pump"]                                  = { "afi_offshore-pump", "a", 1 },
  ["afi_steel-offshore-pump"]                        = { "afi_offshore-pump", "a", 2 },
  ["afi_rubber-lined-offshore-pump"]                 = { "afi_offshore-pump", "a", 3 },
  ["afi_reinforced-offshore-pump"]                   = { "afi_offshore-pump", "a", 4 },
  ["afi_foundation-offshore-pump"]                   = { "afi_offshore-pump", "a", 5 },
  ["afi_high-pressure-foundation-offshore-pump"]     = { "afi_offshore-pump", "a", 6 },
  -- Vulcanus-only, but the sole planet variant of this family, so it shares the
  -- main row rather than occupying a row of its own. Family letter `b` places
  -- it after the main tiers without implying it sits above them.
  ["afi_tungsten-offshore-pump"]                     = { "afi_offshore-pump", "b", 1 },
}

local family_name = {
  ["afi_pipe"] = { a = "pipe", b = "pipe-to-ground" },
  ["afi_pipe-planet"] = { a = "pipe", b = "pipe-to-ground" },
  ["afi_pump"] = { a = "pump" },
  ["afi_pump-planet"] = { a = "pump" },
  ["afi_offshore-pump"] = { a = "offshore-pump", b = "offshore-pump-tungsten" },
}

for name, place in pairs(placement) do
  local item = data.raw.item[name]
  local subgroup, letter, tier = place[1], place[2], place[3]
  -- Tiers absent from this load simply have no item to place. Subgroups whose
  -- whole row is Space Age only are not defined in a base-game load either.
  if item and defined[subgroup] then
    item.subgroup = subgroup
    item.order = string.format("%s[%s-%d]", letter, family_name[subgroup][letter], tier)
  end
end
