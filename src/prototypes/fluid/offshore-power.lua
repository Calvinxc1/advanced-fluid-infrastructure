-- Pump and offshore pump power.
--
-- Offshore pump tiers draw power exactly as the vanilla offshore pump does.
-- The tiers are deepcopies taken in data.lua, before any overhaul's
-- data-updates pass. Krastorio 2 makes the vanilla offshore pump electric in
-- its data-updates, so a copy taken earlier would keep vanilla's free "void"
-- source and every tier above iron would pump without power. Running here,
-- after the mods this one loads after, copies the final source instead. In a
-- load where the vanilla pump is still unpowered this changes nothing.
--
-- Under Krastorio 2, power then grows faster than throughput:
--
--   energy = base_energy * (pumping_speed / base_speed) ^ 1.5
--
-- where the base is the vanilla pump or offshore pump at the iron tier. Each
-- tier moves more fluid and pays a little more per unit for it, so a larger
-- pump is a real power commitment rather than a free upgrade. Speeds are read
-- after tier-apply.lua, so a tier retuned through the API is priced by its
-- configured speed.

local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local POWER_EXPONENT = 1.5

local offshore_reference = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]

if offshore_reference and offshore_reference.energy_source and offshore_reference.energy_source.type ~= "void" then
  for name, prototype in pairs(data.raw["offshore-pump"]) do
    if string.sub(name, 1, 4) == "afi_" then
      prototype.energy_source = util.table.deepcopy(offshore_reference.energy_source)
      prototype.energy_usage = offshore_reference.energy_usage
    end
  end
end

if not optional_dependencies.has_krastorio2 then
  return
end

local UNITS = { [""] = 1, k = 1e3, M = 1e6, G = 1e9 }

local function watts(energy)
  local number, prefix = string.match(energy or "", "^([%d%.]+)%s*([kMG]?)W$")
  return number and tonumber(number) * UNITS[prefix] or nil
end

local function format_watts(value)
  if value >= 1e6 then
    return string.format("%.3gMW", value / 1e6)
  end
  return string.format("%.3gkW", value / 1e3)
end

-- The tiers this mod prices: its own prototypes, plus K2's steel pump, which
-- is the steel tier under K2.
local function priced(name)
  return string.sub(name, 1, 4) == "afi_" or name == optional_dependencies.name("afi_steel-pump")
end

local function scale(category, reference_name)
  local reference = data.raw[category] and data.raw[category][reference_name]
  local base_energy = reference and watts(reference.energy_usage)
  local base_speed = reference and reference.pumping_speed
  if not (base_energy and base_speed and base_speed > 0) then
    return
  end

  for name, prototype in pairs(data.raw[category]) do
    if priced(name) and prototype.pumping_speed and prototype.energy_source
        and prototype.energy_source.type == "electric" then
      local ratio = prototype.pumping_speed / base_speed
      prototype.energy_usage = format_watts(base_energy * ratio ^ POWER_EXPONENT)
    end
  end
end

scale("pump", "pump")
scale("offshore-pump", "offshore-pump")
