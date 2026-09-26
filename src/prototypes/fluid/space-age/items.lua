local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local low_pressure_steel = constants.low_pressure_steel
local calcite_lined = constants.calcite_lined
local tungsten = constants.tungsten

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

local calcite_lined_pipe_item = util.table.deepcopy(data.raw.item.pipe)
calcite_lined_pipe_item.name = "afi_calcite-lined-pipe"
calcite_lined_pipe_item.place_result = "afi_calcite-lined-pipe"
calcite_lined_pipe_item.order = "a[pipe]-a[calcite-lined-pipe]"
helpers.apply_calcite_lined_icon_tint(calcite_lined_pipe_item)
helpers.set_description(calcite_lined_pipe_item, helpers.pipe_description(calcite_lined.pipeline_extent))
data:extend({ calcite_lined_pipe_item })

local calcite_lined_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
calcite_lined_pipe_to_ground_item.name = "afi_calcite-lined-pipe-to-ground"
calcite_lined_pipe_to_ground_item.place_result = "afi_calcite-lined-pipe-to-ground"
calcite_lined_pipe_to_ground_item.order = "a[pipe]-b[calcite-lined-pipe-to-ground]"
helpers.apply_calcite_lined_icon_tint(calcite_lined_pipe_to_ground_item)
helpers.set_description(
  calcite_lined_pipe_to_ground_item,
  helpers.underground_pipe_description(calcite_lined.pipeline_extent, calcite_lined.underground_distance)
)
data:extend({ calcite_lined_pipe_to_ground_item })

local calcite_lined_pump_item = util.table.deepcopy(data.raw.item.pump)
calcite_lined_pump_item.name = "afi_calcite-lined-pump"
calcite_lined_pump_item.place_result = "afi_calcite-lined-pump"
calcite_lined_pump_item.order = "b[fluid]-b[pump-vulcanus]"
helpers.apply_calcite_lined_icon_tint(calcite_lined_pump_item)
helpers.set_description(calcite_lined_pump_item, helpers.pump_description())
data:extend({ calcite_lined_pump_item })

local calcite_lined_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
calcite_lined_offshore_pump_item.name = "afi_calcite-lined-offshore-pump"
calcite_lined_offshore_pump_item.place_result = "afi_calcite-lined-offshore-pump"
calcite_lined_offshore_pump_item.order = "b[fluid]-a[offshore-pump-vulcanus]"
helpers.apply_calcite_lined_icon_tint(calcite_lined_offshore_pump_item)
helpers.set_description(
  calcite_lined_offshore_pump_item,
  helpers.lava_offshore_pump_description(calcite_lined.pipeline_extent)
)
data:extend({ calcite_lined_offshore_pump_item })

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
