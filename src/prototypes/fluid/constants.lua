-- Every tunable this mod owns, and the default payload behind the public API
-- in api.lua.
--
-- Once api.lua has published this table, every later require resolves to the
-- published one rather than rebuilding a fresh copy from the literal below.
-- That matters because the prototype pass runs a stage later than publication:
-- Factorio's require cache is not guaranteed to survive from data.lua into
-- data-updates.lua, and a rebuilt copy here would silently discard everything a
-- dependent mod configured. Reading the global makes the single-table
-- guarantee independent of cache behaviour, and keeps every existing
-- `require("prototypes.fluid.constants")` call site correct unchanged.
if AdvancedFluidInfrastructure and AdvancedFluidInfrastructure.tiers then
  return AdvancedFluidInfrastructure.tiers
end

return {
  iron = {
    pipeline_extent = 24,
    underground_distance = 4,
    pumping_speed = 1,
  },
  steel = {
    pipeline_extent = 64,
    underground_distance = 8,
    pumping_speed = 4,
    icon_tint = { r = 0.5, g = 0.72, b = 1.0, a = 0.48 },
  },
  low_pressure_steel = {
    pipeline_extent = 64,
    underground_distance = 8,
    pumping_speed = 4,
    icon_tint = { r = 0.9, g = 0.94, b = 1.0, a = 0.56 },
    entity_tint = { r = 0.82, g = 0.86, b = 0.92, a = 1 },
  },
  calcite_lined = {
    pipeline_extent = 24,
    underground_distance = 4,
    pumping_speed = 1,
    icon_tint = { r = 1.0, g = 0.28, b = 0.18, a = 0.32 },
    entity_tint = { r = 0.86, g = 0.58, b = 0.52, a = 1 },
  },
  tungsten = {
    pipeline_extent = 64,
    underground_distance = 8,
    pumping_speed = 4,
    icon_tint = { r = 0.72, g = 0.32, b = 1.0, a = 0.34 },
    entity_tint = { r = 0.72, g = 0.58, b = 0.86, a = 1 },
  },
  reinforced = {
    pipeline_extent = 192,
    underground_distance = 12,
    pumping_speed = 10,
    icon_tint = { r = 0.22, g = 0.74, b = 0.34, a = 0.22 },
    entity_tint = { r = 0.72, g = 0.86, b = 0.74, a = 1 },
    resistances = {
      { type = "fire", percent = 100 },
      { type = "acid", percent = 80 },
      { type = "poison", percent = 80 },
      { type = "explosion", percent = 70 },
      { type = "physical", percent = 60 },
      { type = "impact", percent = 60 },
      { type = "electric", percent = 50 },
      { type = "laser", percent = 50 },
    },
  },
  foundation = {
    pipeline_extent = 512,
    underground_distance = 20,
    pumping_speed = 20,
    icon_tint = { r = 0.82, g = 0.94, b = 1.0, a = 0.28 },
    entity_tint = { r = 0.86, g = 0.92, b = 0.96, a = 1 },
    resistances = {
      { type = "fire", percent = 100 },
      { type = "acid", percent = 85 },
      { type = "poison", percent = 85 },
      { type = "explosion", percent = 80 },
      { type = "physical", percent = 70 },
      { type = "impact", percent = 70 },
      { type = "electric", percent = 60 },
      { type = "laser", percent = 60 },
    },
  },
  high_pressure_foundation = {
    pipeline_extent = 512,
    pumping_speed = 60,
    icon_tint = { r = 0.18, g = 0.22, b = 0.72, a = 0.42 },
    entity_tint = { r = 0.74, g = 0.82, b = 1.0, a = 1 },
  },
  rubber_lined = {
    pipeline_extent = 96,
    underground_distance = 12,
    pumping_speed = 6,
    icon_tint = { r = 0.08, g = 0.08, b = 0.08, a = 0.58 },
    entity_tint = { r = 0.42, g = 0.42, b = 0.42, a = 1 },
  },
}
