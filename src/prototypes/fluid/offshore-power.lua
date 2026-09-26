-- Offshore pump tiers draw power exactly as the vanilla offshore pump does.
--
-- The tiers are deepcopies taken in data.lua, before any overhaul's
-- data-updates pass. Krastorio 2 makes the vanilla offshore pump electric in
-- its data-updates, so a copy taken earlier would keep vanilla's free "void"
-- source and every tier above iron would pump without power. Running here,
-- after the mods this one loads after, copies the final source instead. In a
-- load where the vanilla pump is still unpowered this changes nothing.

local reference = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]

if reference and reference.energy_source and reference.energy_source.type ~= "void" then
  for name, prototype in pairs(data.raw["offshore-pump"]) do
    if string.sub(name, 1, 4) == "afi_" then
      prototype.energy_source = util.table.deepcopy(reference.energy_source)
      prototype.energy_usage = reference.energy_usage
    end
  end
end
