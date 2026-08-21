local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local low_pressure_steel = constants.low_pressure_steel
local heat_resistant = constants.heat_resistant
local tungsten = constants.tungsten
local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation

local low_pressure_steel_pipe_item = util.table.deepcopy(data.raw.item.pipe)
low_pressure_steel_pipe_item.name = "afi_low-pressure-steel-pipe"
low_pressure_steel_pipe_item.place_result = "afi_low-pressure-steel-pipe"
low_pressure_steel_pipe_item.order = "a[pipe]-a[low-pressure-steel-pipe]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_item)
helpers.set_description(low_pressure_steel_pipe_item, helpers.pipe_description(low_pressure_steel.pipeline_extent))
data:extend({ low_pressure_steel_pipe_item })

local low_pressure_steel_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
low_pressure_steel_pipe_to_ground_item.name = "afi_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_item.place_result = "afi_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_item.order = "a[pipe]-b[low-pressure-steel-pipe-to-ground]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pipe_to_ground_item)
helpers.set_description(
  low_pressure_steel_pipe_to_ground_item,
  helpers.underground_pipe_description(low_pressure_steel.pipeline_extent, low_pressure_steel.underground_distance)
)
data:extend({ low_pressure_steel_pipe_to_ground_item })

local low_pressure_steel_pump_item = util.table.deepcopy(data.raw.item.pump)
low_pressure_steel_pump_item.name = "afi_low-pressure-steel-pump"
low_pressure_steel_pump_item.place_result = "afi_low-pressure-steel-pump"
low_pressure_steel_pump_item.order = "b[fluid]-b[pump-space]"
helpers.apply_low_pressure_steel_icon_tint(low_pressure_steel_pump_item)
helpers.set_description(low_pressure_steel_pump_item, helpers.pump_description())
data:extend({ low_pressure_steel_pump_item })

local heat_resistant_pipe_item = util.table.deepcopy(data.raw.item.pipe)
heat_resistant_pipe_item.name = "afi_heat-resistant-pipe"
heat_resistant_pipe_item.place_result = "afi_heat-resistant-pipe"
heat_resistant_pipe_item.order = "a[pipe]-a[heat-resistant-pipe]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe_item)
helpers.set_description(heat_resistant_pipe_item, helpers.pipe_description(heat_resistant.pipeline_extent))
data:extend({ heat_resistant_pipe_item })

local heat_resistant_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
heat_resistant_pipe_to_ground_item.name = "afi_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_item.place_result = "afi_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_item.order = "a[pipe]-b[heat-resistant-pipe-to-ground]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pipe_to_ground_item)
helpers.set_description(
  heat_resistant_pipe_to_ground_item,
  helpers.underground_pipe_description(heat_resistant.pipeline_extent, heat_resistant.underground_distance)
)
data:extend({ heat_resistant_pipe_to_ground_item })

local heat_resistant_pump_item = util.table.deepcopy(data.raw.item.pump)
heat_resistant_pump_item.name = "afi_heat-resistant-pump"
heat_resistant_pump_item.place_result = "afi_heat-resistant-pump"
heat_resistant_pump_item.order = "b[fluid]-b[pump-vulcanus]"
helpers.apply_heat_resistant_icon_tint(heat_resistant_pump_item)
helpers.set_description(heat_resistant_pump_item, helpers.pump_description())
data:extend({ heat_resistant_pump_item })

local tungsten_pipe_item = util.table.deepcopy(data.raw.item.pipe)
tungsten_pipe_item.name = "afi_tungsten-pipe"
tungsten_pipe_item.place_result = "afi_tungsten-pipe"
tungsten_pipe_item.order = "a[pipe]-a[tungsten-pipe]"
helpers.apply_tungsten_icon_tint(tungsten_pipe_item)
helpers.set_description(tungsten_pipe_item, helpers.pipe_description(tungsten.pipeline_extent))
data:extend({ tungsten_pipe_item })

local tungsten_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
tungsten_pipe_to_ground_item.name = "afi_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_item.place_result = "afi_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_item.order = "a[pipe]-b[tungsten-pipe-to-ground]"
helpers.apply_tungsten_icon_tint(tungsten_pipe_to_ground_item)
helpers.set_description(
  tungsten_pipe_to_ground_item,
  helpers.underground_pipe_description(tungsten.pipeline_extent, tungsten.underground_distance)
)
data:extend({ tungsten_pipe_to_ground_item })

local tungsten_pump_item = util.table.deepcopy(data.raw.item.pump)
tungsten_pump_item.name = "afi_tungsten-pump"
tungsten_pump_item.place_result = "afi_tungsten-pump"
tungsten_pump_item.order = "b[fluid]-b[pump-vulcanus-tungsten]"
helpers.apply_tungsten_icon_tint(tungsten_pump_item)
helpers.set_description(tungsten_pump_item, helpers.pump_description())
data:extend({ tungsten_pump_item })

local tungsten_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
tungsten_offshore_pump_item.name = "afi_tungsten-offshore-pump"
tungsten_offshore_pump_item.place_result = "afi_tungsten-offshore-pump"
tungsten_offshore_pump_item.order = "b[fluid]-a[offshore-pump-vulcanus-tungsten]"
helpers.apply_tungsten_icon_tint(tungsten_offshore_pump_item)
helpers.set_description(
  tungsten_offshore_pump_item,
  helpers.lava_offshore_pump_description(tungsten.pipeline_extent)
)
data:extend({ tungsten_offshore_pump_item })
local foundation_pipe_item = util.table.deepcopy(data.raw.item.pipe)
foundation_pipe_item.name = "afi_foundation-pipe"
foundation_pipe_item.place_result = "afi_foundation-pipe"
foundation_pipe_item.order = "a[pipe]-a[foundation-pipe]"
helpers.apply_foundation_icon_tint(foundation_pipe_item)
helpers.set_description(foundation_pipe_item, helpers.pipe_description(foundation.pipeline_extent))
data:extend({ foundation_pipe_item })

local foundation_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
foundation_pipe_to_ground_item.name = "afi_foundation-pipe-to-ground"
foundation_pipe_to_ground_item.place_result = "afi_foundation-pipe-to-ground"
foundation_pipe_to_ground_item.order = "a[pipe]-b[foundation-pipe-to-ground]"
helpers.apply_foundation_icon_tint(foundation_pipe_to_ground_item)
helpers.set_description(
  foundation_pipe_to_ground_item,
  helpers.underground_pipe_description(foundation.pipeline_extent, foundation.underground_distance)
)
data:extend({ foundation_pipe_to_ground_item })

local foundation_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
foundation_offshore_pump_item.name = "afi_foundation-offshore-pump"
foundation_offshore_pump_item.place_result = "afi_foundation-offshore-pump"
foundation_offshore_pump_item.order = "b[fluid]-a[offshore-pump-5]"
helpers.apply_foundation_icon_tint(foundation_offshore_pump_item)
helpers.set_description(
  foundation_offshore_pump_item,
  helpers.offshore_pump_description(foundation.pipeline_extent)
)
data:extend({ foundation_offshore_pump_item })

local foundation_pump_item = util.table.deepcopy(data.raw.item.pump)
foundation_pump_item.name = "afi_foundation-pump"
foundation_pump_item.place_result = "afi_foundation-pump"
foundation_pump_item.order = "b[fluid]-b[pump-5]"
helpers.apply_foundation_icon_tint(foundation_pump_item)
helpers.set_description(foundation_pump_item, helpers.pump_description())
data:extend({ foundation_pump_item })

local high_pressure_foundation_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
high_pressure_foundation_offshore_pump_item.name = "afi_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_item.place_result = "afi_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_item.order = "b[fluid]-a[offshore-pump-6]"
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_offshore_pump_item)
helpers.set_description(
  high_pressure_foundation_offshore_pump_item,
  helpers.offshore_pump_description(high_pressure_foundation.pipeline_extent)
)
data:extend({ high_pressure_foundation_offshore_pump_item })

local high_pressure_foundation_pump_item = util.table.deepcopy(data.raw.item.pump)
high_pressure_foundation_pump_item.name = "afi_high-pressure-foundation-pump"
high_pressure_foundation_pump_item.place_result = "afi_high-pressure-foundation-pump"
high_pressure_foundation_pump_item.order = "b[fluid]-b[pump-6]"
helpers.apply_high_pressure_foundation_icon_tint(high_pressure_foundation_pump_item)
helpers.set_description(high_pressure_foundation_pump_item, helpers.pump_description())
data:extend({ high_pressure_foundation_pump_item })
