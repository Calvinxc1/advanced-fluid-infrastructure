-- The foundation and high-pressure foundation tiers: entities.
--
-- Built whenever a load has a late game to put them in: Space Age, or
-- Krastorio 2. The prototypes are the same in both; only the recipes and
-- technologies differ, and those live with the mod that supplies their
-- materials (prototypes/fluid/space-age/ and prototypes/fluid/krastorio2-foundation.lua).

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation

local foundation_pipe = util.table.deepcopy(data.raw.pipe.pipe)
foundation_pipe.name = "afi_foundation-pipe"
foundation_pipe.minable.result = "afi_foundation-pipe"
foundation_pipe.max_health = 360
helpers.apply_foundation_icon_tint(foundation_pipe)
helpers.apply_foundation_entity_tint(foundation_pipe)
helpers.set_resistances(foundation_pipe, foundation.resistances)
helpers.set_fluid_box_extent(foundation_pipe.fluid_box, foundation.pipeline_extent)
foundation_pipe.next_upgrade = nil
helpers.set_description(foundation_pipe, helpers.pipe_description(foundation.pipeline_extent))
helpers.allow_all_surfaces(foundation_pipe)
data:extend({ foundation_pipe })

local foundation_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
foundation_pipe_to_ground.name = "afi_foundation-pipe-to-ground"
foundation_pipe_to_ground.minable.result = "afi_foundation-pipe-to-ground"
foundation_pipe_to_ground.max_health = 440
helpers.apply_foundation_icon_tint(foundation_pipe_to_ground)
helpers.apply_foundation_entity_tint(foundation_pipe_to_ground)
helpers.set_resistances(foundation_pipe_to_ground, foundation.resistances)
helpers.set_underground_distance(foundation_pipe_to_ground, foundation.underground_distance)
helpers.set_fluid_box_extent(foundation_pipe_to_ground.fluid_box, foundation.pipeline_extent)
foundation_pipe_to_ground.next_upgrade = nil
helpers.set_description(
  foundation_pipe_to_ground,
  helpers.underground_pipe_description(foundation.pipeline_extent, foundation.underground_distance)
)
helpers.allow_all_surfaces(foundation_pipe_to_ground)
data:extend({ foundation_pipe_to_ground })

local foundation_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
foundation_offshore_pump.name = "afi_foundation-offshore-pump"
foundation_offshore_pump.minable.result = "afi_foundation-offshore-pump"
foundation_offshore_pump.max_health = 460
foundation_offshore_pump.pumping_speed = foundation.pumping_speed
helpers.apply_foundation_icon_tint(foundation_offshore_pump)
helpers.apply_foundation_entity_tint(foundation_offshore_pump)
helpers.set_resistances(foundation_offshore_pump, foundation.resistances)
helpers.set_fluid_box_extent(foundation_offshore_pump.fluid_box, foundation.pipeline_extent)
foundation_offshore_pump.next_upgrade = "afi_high-pressure-foundation-offshore-pump"
helpers.set_description(
  foundation_offshore_pump,
  helpers.offshore_pump_description(foundation.pipeline_extent)
)
helpers.allow_all_surfaces(foundation_offshore_pump)
data:extend({ foundation_offshore_pump })

local foundation_pump = util.table.deepcopy(data.raw.pump.pump)
foundation_pump.name = "afi_foundation-pump"
foundation_pump.minable.result = "afi_foundation-pump"
foundation_pump.max_health = 460
foundation_pump.pumping_speed = foundation.pumping_speed
foundation_pump.next_upgrade = "afi_high-pressure-foundation-pump"
helpers.apply_foundation_icon_tint(foundation_pump)
helpers.apply_foundation_entity_tint(foundation_pump)
helpers.set_resistances(foundation_pump, foundation.resistances)
helpers.set_description(foundation_pump, helpers.pump_description())
helpers.allow_all_surfaces(foundation_pump)
data:extend({ foundation_pump })

local high_pressure_foundation_offshore_pump = util.table.deepcopy(foundation_offshore_pump)
high_pressure_foundation_offshore_pump.name = "afi_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump.minable.result = "afi_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump.max_health = 560
high_pressure_foundation_offshore_pump.pumping_speed = high_pressure_foundation.pumping_speed
high_pressure_foundation_offshore_pump.next_upgrade = nil
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_offshore_pump)
helpers.apply_high_pressure_foundation_entity_tint(high_pressure_foundation_offshore_pump)
helpers.set_resistances(high_pressure_foundation_offshore_pump, foundation.resistances)
helpers.set_fluid_box_extent(high_pressure_foundation_offshore_pump.fluid_box, high_pressure_foundation.pipeline_extent)
helpers.set_description(
  high_pressure_foundation_offshore_pump,
  helpers.offshore_pump_description(high_pressure_foundation.pipeline_extent)
)
helpers.allow_all_surfaces(high_pressure_foundation_offshore_pump)
data:extend({ high_pressure_foundation_offshore_pump })

local high_pressure_foundation_pump = util.table.deepcopy(foundation_pump)
high_pressure_foundation_pump.name = "afi_high-pressure-foundation-pump"
high_pressure_foundation_pump.minable.result = "afi_high-pressure-foundation-pump"
high_pressure_foundation_pump.max_health = 560
high_pressure_foundation_pump.pumping_speed = high_pressure_foundation.pumping_speed
high_pressure_foundation_pump.next_upgrade = nil
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_pump)
helpers.apply_high_pressure_foundation_entity_tint(high_pressure_foundation_pump)
helpers.set_resistances(high_pressure_foundation_pump, foundation.resistances)
helpers.set_description(high_pressure_foundation_pump, helpers.pump_description())
helpers.allow_all_surfaces(high_pressure_foundation_pump)
data:extend({ high_pressure_foundation_pump })

-- Reinforced is the terminal tier in a load without a late game. With the
-- foundation tier present above it, re-point the upgrade chain here.
data.raw.pipe["afi_reinforced-pipe"].next_upgrade = "afi_foundation-pipe"
data.raw["pipe-to-ground"]["afi_reinforced-pipe-to-ground"].next_upgrade = "afi_foundation-pipe-to-ground"
data.raw["offshore-pump"]["afi_reinforced-offshore-pump"].next_upgrade = "afi_foundation-offshore-pump"
data.raw.pump["afi_reinforced-pump"].next_upgrade = "afi_foundation-pump"
