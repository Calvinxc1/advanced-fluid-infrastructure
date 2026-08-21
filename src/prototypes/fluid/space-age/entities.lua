local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local low_pressure_steel = constants.low_pressure_steel
local calcite_lined = constants.calcite_lined
local tungsten = constants.tungsten
local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation

local low_pressure_steel_pipe = util.table.deepcopy(data.raw.pipe.pipe)
low_pressure_steel_pipe.name = "afi_low-pressure-steel-pipe"
low_pressure_steel_pipe.minable.result = "afi_low-pressure-steel-pipe"
low_pressure_steel_pipe.max_health = 150
helpers.allow_only_space_platforms(low_pressure_steel_pipe)
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pipe)
helpers.set_fluid_box_extent(low_pressure_steel_pipe.fluid_box, low_pressure_steel.pipeline_extent)
low_pressure_steel_pipe.next_upgrade = "afi_foundation-pipe"
helpers.set_description(low_pressure_steel_pipe, helpers.pipe_description(low_pressure_steel.pipeline_extent))
data:extend({ low_pressure_steel_pipe })

local low_pressure_steel_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
low_pressure_steel_pipe_to_ground.name = "afi_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground.minable.result = "afi_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground.max_health = 200
helpers.allow_only_space_platforms(low_pressure_steel_pipe_to_ground)
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_to_ground)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pipe_to_ground)
helpers.set_underground_distance(low_pressure_steel_pipe_to_ground, low_pressure_steel.underground_distance)
helpers.set_fluid_box_extent(low_pressure_steel_pipe_to_ground.fluid_box, low_pressure_steel.pipeline_extent)
low_pressure_steel_pipe_to_ground.next_upgrade = "afi_foundation-pipe-to-ground"
helpers.set_description(
  low_pressure_steel_pipe_to_ground,
  helpers.underground_pipe_description(low_pressure_steel.pipeline_extent, low_pressure_steel.underground_distance)
)
data:extend({ low_pressure_steel_pipe_to_ground })

local low_pressure_steel_pump = util.table.deepcopy(data.raw.pump.pump)
low_pressure_steel_pump.name = "afi_low-pressure-steel-pump"
low_pressure_steel_pump.minable.result = "afi_low-pressure-steel-pump"
low_pressure_steel_pump.max_health = 200
helpers.allow_only_space_platforms(low_pressure_steel_pump)
low_pressure_steel_pump.pumping_speed = low_pressure_steel.pumping_speed
low_pressure_steel_pump.next_upgrade = "afi_foundation-pump"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pump)
helpers.apply_low_pressure_steel_entity_tint(low_pressure_steel_pump)
helpers.set_description(low_pressure_steel_pump, helpers.pump_description())
data:extend({ low_pressure_steel_pump })

local calcite_lined_pipe = util.table.deepcopy(data.raw.pipe.pipe)
calcite_lined_pipe.name = "afi_calcite-lined-pipe"
calcite_lined_pipe.minable.result = "afi_calcite-lined-pipe"
calcite_lined_pipe.max_health = 150
helpers.allow_only_vulcanus(calcite_lined_pipe)
helpers.apply_calcite_lined_icon_tint(calcite_lined_pipe)
helpers.apply_calcite_lined_entity_tint(calcite_lined_pipe)
helpers.set_fluid_box_extent(calcite_lined_pipe.fluid_box, calcite_lined.pipeline_extent)
calcite_lined_pipe.next_upgrade = "afi_tungsten-pipe"
helpers.set_description(calcite_lined_pipe, helpers.pipe_description(calcite_lined.pipeline_extent))
data:extend({ calcite_lined_pipe })

local calcite_lined_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
calcite_lined_pipe_to_ground.name = "afi_calcite-lined-pipe-to-ground"
calcite_lined_pipe_to_ground.minable.result = "afi_calcite-lined-pipe-to-ground"
calcite_lined_pipe_to_ground.max_health = 200
helpers.allow_only_vulcanus(calcite_lined_pipe_to_ground)
helpers.apply_calcite_lined_icon_tint(calcite_lined_pipe_to_ground)
helpers.apply_calcite_lined_entity_tint(calcite_lined_pipe_to_ground)
helpers.set_underground_distance(calcite_lined_pipe_to_ground, calcite_lined.underground_distance)
helpers.set_fluid_box_extent(calcite_lined_pipe_to_ground.fluid_box, calcite_lined.pipeline_extent)
calcite_lined_pipe_to_ground.next_upgrade = "afi_tungsten-pipe-to-ground"
helpers.set_description(
  calcite_lined_pipe_to_ground,
  helpers.underground_pipe_description(calcite_lined.pipeline_extent, calcite_lined.underground_distance)
)
data:extend({ calcite_lined_pipe_to_ground })

local calcite_lined_pump = util.table.deepcopy(data.raw.pump.pump)
calcite_lined_pump.name = "afi_calcite-lined-pump"
calcite_lined_pump.minable.result = "afi_calcite-lined-pump"
calcite_lined_pump.max_health = 200
helpers.allow_only_vulcanus(calcite_lined_pump)
calcite_lined_pump.pumping_speed = calcite_lined.pumping_speed
calcite_lined_pump.next_upgrade = "afi_tungsten-pump"
helpers.apply_calcite_lined_icon_tint(calcite_lined_pump)
helpers.apply_calcite_lined_entity_tint(calcite_lined_pump)
helpers.set_description(calcite_lined_pump, helpers.pump_description())
data:extend({ calcite_lined_pump })

local tungsten_pipe = util.table.deepcopy(data.raw.pipe.pipe)
tungsten_pipe.name = "afi_tungsten-pipe"
tungsten_pipe.minable.result = "afi_tungsten-pipe"
tungsten_pipe.max_health = 180
helpers.allow_only_vulcanus(tungsten_pipe)
helpers.apply_tungsten_icon_tint(tungsten_pipe)
helpers.apply_tungsten_entity_tint(tungsten_pipe)
helpers.set_fluid_box_extent(tungsten_pipe.fluid_box, tungsten.pipeline_extent)
tungsten_pipe.next_upgrade = "afi_reinforced-pipe"
helpers.set_description(tungsten_pipe, helpers.pipe_description(tungsten.pipeline_extent))
data:extend({ tungsten_pipe })

local tungsten_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
tungsten_pipe_to_ground.name = "afi_tungsten-pipe-to-ground"
tungsten_pipe_to_ground.minable.result = "afi_tungsten-pipe-to-ground"
tungsten_pipe_to_ground.max_health = 230
helpers.allow_only_vulcanus(tungsten_pipe_to_ground)
helpers.apply_tungsten_icon_tint(tungsten_pipe_to_ground)
helpers.apply_tungsten_entity_tint(tungsten_pipe_to_ground)
helpers.set_underground_distance(tungsten_pipe_to_ground, tungsten.underground_distance)
helpers.set_fluid_box_extent(tungsten_pipe_to_ground.fluid_box, tungsten.pipeline_extent)
tungsten_pipe_to_ground.next_upgrade = "afi_reinforced-pipe-to-ground"
helpers.set_description(
  tungsten_pipe_to_ground,
  helpers.underground_pipe_description(tungsten.pipeline_extent, tungsten.underground_distance)
)
data:extend({ tungsten_pipe_to_ground })

local tungsten_pump = util.table.deepcopy(data.raw.pump.pump)
tungsten_pump.name = "afi_tungsten-pump"
tungsten_pump.minable.result = "afi_tungsten-pump"
tungsten_pump.max_health = 240
helpers.allow_only_vulcanus(tungsten_pump)
tungsten_pump.pumping_speed = tungsten.pumping_speed
tungsten_pump.next_upgrade = "afi_reinforced-pump"
helpers.apply_tungsten_icon_tint(tungsten_pump)
helpers.apply_tungsten_entity_tint(tungsten_pump)
helpers.set_description(tungsten_pump, helpers.pump_description())
data:extend({ tungsten_pump })

local tungsten_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
tungsten_offshore_pump.name = "afi_tungsten-offshore-pump"
tungsten_offshore_pump.minable.result = "afi_tungsten-offshore-pump"
tungsten_offshore_pump.max_health = 240
helpers.allow_only_vulcanus(tungsten_offshore_pump)
tungsten_offshore_pump.pumping_speed = tungsten.pumping_speed
tungsten_offshore_pump.fluid_box.filter = "lava"
helpers.apply_tungsten_icon_tint(tungsten_offshore_pump)
helpers.apply_tungsten_entity_tint(tungsten_offshore_pump)
helpers.set_fluid_box_extent(tungsten_offshore_pump.fluid_box, tungsten.pipeline_extent)
tungsten_offshore_pump.next_upgrade = "afi_reinforced-offshore-pump"
helpers.set_description(
  tungsten_offshore_pump,
  helpers.lava_offshore_pump_description(tungsten.pipeline_extent)
)
data:extend({ tungsten_offshore_pump })
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
data:extend({ high_pressure_foundation_pump })

-- Reinforced is the terminal tier in a base-game load. With Space Age present
-- the foundation tier exists above it, so re-point the upgrade chain here.
data.raw.pipe["afi_reinforced-pipe"].next_upgrade = "afi_foundation-pipe"
data.raw["pipe-to-ground"]["afi_reinforced-pipe-to-ground"].next_upgrade = "afi_foundation-pipe-to-ground"
data.raw["offshore-pump"]["afi_reinforced-offshore-pump"].next_upgrade = "afi_foundation-offshore-pump"
data.raw.pump["afi_reinforced-pump"].next_upgrade = "afi_foundation-pump"
