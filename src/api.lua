-- Public data-stage configuration API.
--
-- Every tunable this mod owns lives in prototypes/fluid/constants.lua. That
-- table is the default payload; this file publishes it so other mods can retune
-- a tier before any prototype is built from it.
--
-- The contract is a load-order one. data.lua publishes and builds nothing;
-- prototypes/fluid is built from data-updates.lua instead. A mod that declares
-- `? advanced-fluid-infrastructure` therefore runs its own data.lua in the
-- window between the two, which is the only point where a change can still
-- reach a prototype.
--
--     data.lua            (this mod)  publish, build nothing
--     data.lua            (consumer)  configure here
--     data-updates.lua    (this mod)  build prototypes
--     data-updates.lua    (consumer)  patch finished prototypes
--
-- No attempt is made to stop a caller unbalancing the mod. Tier values are the
-- player's and the modder's to set; what this file guarantees is that a change
-- either lands or says why it did not, rather than silently doing nothing.

AdvancedFluidInfrastructure = AdvancedFluidInfrastructure or {}
local api = AdvancedFluidInfrastructure

-- Bumped only when an existing call's meaning changes, so a caller can gate on
-- it. Adding a tier or a tunable does not bump it.
api.version = 1

-- Guarded, and the guard is load-bearing rather than defensive. Factorio's
-- require cache is not shared across mods, so this file runs once per consuming
-- mod; an unguarded require would re-execute constants.lua each time and hand
-- every caller after the first a fresh default table, discarding the changes
-- made before it. Binding to the global means all callers share one table
-- whether or not the cache is shared.
--
-- The path is absolute for the same reason: a relative require inside a file
-- another mod required resolves against that mod's root, not this one's.
api.tiers = api.tiers
  or require("__advanced-fluid-infrastructure__.prototypes.fluid.constants")

-- What this mod will act on. Anything else is accepted into the table and
-- ignored by the prototype pass, so it is rejected here instead of appearing to
-- work. Cosmetic fields (icon_tint, entity_tint, resistances) are deliberately
-- absent: they are read through helpers at call time and are a separate surface
-- from the numbers that decide balance.
local TUNABLE = {
  pipeline_extent = "number",
  underground_distance = "number",
  pumping_speed = "number",
}

local function tunable_names()
  local names = {}
  for name in pairs(TUNABLE) do
    table.insert(names, name)
  end
  table.sort(names)
  return table.concat(names, ", ")
end

-- Names every tier this load actually has. Space Age tiers are present in the
-- constants table whether or not Space Age is loaded -- only the prototypes
-- built from them are conditional -- so this is the full list in every load and
-- configuring an unbuilt tier is harmless.
function api.tier_names()
  local names = {}
  for name in pairs(api.tiers) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

-- The live tier table, not a copy. Reading is the intended use; writing to it
-- directly works but skips the validation and the log line, so prefer
-- configure_tier.
function api.get_tier(name)
  return api.tiers[name]
end

-- Merges `changes` into a tier. Returns true when every field was applied.
--
-- Merging rather than replacing is required, not stylistic: entities.lua and
-- space-age/entities.lua bind each tier sub-table to a local at require time,
-- so a replaced table would never be seen by the prototype pass. Merging also
-- means a caller changing pumping_speed does not have to restate the tier's
-- tints and resistances.
-- `source` is an optional caller label ("my-mod") used only in the log. The
-- data stage exposes no way to ask which mod is currently executing, so a
-- caller that wants its name in the trail has to say so.
function api.configure_tier(name, changes, source)
  local tier = api.tiers[name]
  if not tier then
    log(("AFI: configure_tier(%q) ignored -- no such tier. Known tiers: %s")
      :format(tostring(name), table.concat(api.tier_names(), ", ")))
    return false
  end

  if type(changes) ~= "table" then
    log(("AFI: configure_tier(%q) ignored -- expected a table of changes, got %s")
      :format(name, type(changes)))
    return false
  end

  local applied = true
  for field, value in pairs(changes) do
    local expected = TUNABLE[field]
    if not expected then
      log(("AFI: configure_tier(%q) skipped unknown field %q. Configurable: %s")
        :format(name, tostring(field), tunable_names()))
      applied = false
    elseif type(value) ~= expected then
      log(("AFI: configure_tier(%q) skipped %s -- expected %s, got %s")
        :format(name, field, expected, type(value)))
      applied = false
    else
      -- Logged on change rather than on every call, so the log shows who moved
      -- a value and what it was before. With two mods configuring the same
      -- tier this is the difference between a quick diagnosis and an
      -- unreproducible bug report.
      if tier[field] ~= value then
        log(("AFI: %s.%s %s -> %s%s")
          :format(name, field, tostring(tier[field]), tostring(value),
            source and (" (by " .. tostring(source) .. ")") or ""))
      end
      tier[field] = value
    end
  end

  return applied
end

return api
