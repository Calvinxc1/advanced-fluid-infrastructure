-- Re-applies tier values to prototypes this mod already built.
--
-- Prototypes are created in data.lua, at the ordinary stage, so that every
-- base-game and mod pass that scans data.raw during data-updates sees them --
-- Space Age's recycler being the one that bites, since it generates a recycling
-- recipe for every recipe present when it runs. Creating them a stage later
-- left all of this mod's items unrecyclable.
--
-- But a dependent mod cannot configure a tier until its own data.lua, which is
-- after ours. So creation stays early and only the numbers move late: this pass
-- runs in data-updates and writes the final tier values over the defaults the
-- prototypes were built with. Values are all that change -- no prototype is
-- created, renamed, or removed here.
--
-- Prototype names are derived from the tier name rather than listed, so adding
-- a tier needs no edit here. The derivation is checked at the bottom.

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

-- Role suffix -> the data.raw category the prototype lives in. The iron tier is
-- the vanilla set, whose names are the bare suffixes.
local ROLES = {
  { suffix = "pipe", category = "pipe" },
  { suffix = "pipe-to-ground", category = "pipe-to-ground" },
  { suffix = "pump", category = "pump" },
  { suffix = "offshore-pump", category = "offshore-pump" },
}

local function prototype_name(tier_name, suffix)
  if tier_name == "iron" then
    return suffix
  end
  return "afi_" .. string.gsub(tier_name, "_", "-") .. "-" .. suffix
end

-- Which tier fields each description key interpolates, in argument order.
--
-- Keyed by the description already on the prototype rather than by tier and
-- role, so the variants stay this module's business only as arities. That is
-- what keeps the Vulcanus lava offshore pumps correct without a table here
-- naming which tiers use them.
local DESCRIPTION_ARGUMENTS = {
  ["description.afi_pipeline-extent"] = { "pipeline_extent" },
  ["description.afi_underground-pipeline-extent"] = { "pipeline_extent", "underground_distance" },
  ["description.afi_offshore-pump-fluid-stats"] = { "pipeline_extent" },
  ["description.afi_lava-offshore-pump-fluid-stats"] = { "pipeline_extent" },
  ["description.afi_pump-fluid-stats"] = {},
}

local function refresh_description(prototype, tier)
  local description = prototype and prototype.localised_description
  if type(description) ~= "table" then
    return
  end

  local fields = DESCRIPTION_ARGUMENTS[description[1]]
  if not fields then
    return
  end

  for index, field in ipairs(fields) do
    if tier[field] ~= nil then
      description[index + 1] = tostring(tier[field])
    end
  end
end

local function set_extent(prototype, tier)
  if tier.pipeline_extent ~= nil then
    helpers.set_fluid_box_extent(prototype.fluid_box, tier.pipeline_extent)
  end
end

local function set_speed(prototype, tier)
  if tier.pumping_speed ~= nil then
    prototype.pumping_speed = tier.pumping_speed
  end
end

-- Pumps are pipeline segment boundaries, so this mod never gives them an
-- extent; their description carries no numbers either.
local APPLY = {
  ["pipe"] = set_extent,
  ["pipe-to-ground"] = function(prototype, tier)
    set_extent(prototype, tier)
    if tier.underground_distance ~= nil then
      helpers.set_underground_distance(prototype, tier.underground_distance)
    end
  end,
  ["pump"] = set_speed,
  ["offshore-pump"] = function(prototype, tier)
    set_extent(prototype, tier)
    set_speed(prototype, tier)
  end,
}

local covered = {}

for tier_name, tier in pairs(constants) do
  if type(tier) == "table" then
    for _, role in ipairs(ROLES) do
      local name = prototype_name(tier_name, role.suffix)
      local prototype = data.raw[role.category] and data.raw[role.category][name]
      if prototype then
        covered[name] = true
        APPLY[role.suffix](prototype, tier)
        refresh_description(prototype, tier)
        -- The item's tooltip repeats the entity's numbers, so it has to follow
        -- or the two disagree about the tier the player is holding.
        refresh_description(data.raw.item[name], tier)
      end
    end
  end
end

-- Names are derived, so a tier or role that stops matching the convention would
-- silently keep its defaults rather than fail. Nothing is logged on a correct
-- load; a line here means this module needs a new case.
for _, role in ipairs(ROLES) do
  for name in pairs(data.raw[role.category] or {}) do
    if string.sub(name, 1, 4) == "afi_" and not covered[name] then
      log("AFI: tier-apply did not recognise " .. name ..
        "; it keeps its built-in defaults and ignores configuration")
    end
  end
end
