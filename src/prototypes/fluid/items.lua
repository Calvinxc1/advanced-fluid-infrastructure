local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local iron = constants.iron
local steel = constants.steel
local reinforced = constants.reinforced
local rubber_lined = constants.rubber_lined

data.raw.item.pipe.order = "a[pipe]-a[iron-pipe]"
data.raw.item["pipe-to-ground"].order = "a[pipe]-b[iron-pipe-to-ground]"
data.raw.item["offshore-pump"].order = "b[fluid]-a[offshore-pump-1]"
data.raw.item.pump.order = "b[fluid]-b[pump-1]"
helpers.set_description(data.raw.item.pipe, helpers.pipe_description(iron.pipeline_extent))
helpers.set_description(
  data.raw.item["pipe-to-ground"],
  helpers.underground_pipe_description(iron.pipeline_extent, iron.underground_distance)
)
helpers.set_description(
  data.raw.item["offshore-pump"],
  helpers.offshore_pump_description(iron.pipeline_extent)
)
helpers.set_description(data.raw.item.pump, helpers.pump_description())

local steel_pipe_item = util.table.deepcopy(data.raw.item.pipe)
steel_pipe_item.name = "afi_steel-pipe"
steel_pipe_item.place_result = "afi_steel-pipe"
steel_pipe_item.order = "a[pipe]-a[steel-pipe]"
helpers.apply_steel_icon_tint(steel_pipe_item)
helpers.set_description(steel_pipe_item, helpers.pipe_description(steel.pipeline_extent))
data:extend({ steel_pipe_item })

local steel_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
steel_pipe_to_ground_item.name = "afi_steel-pipe-to-ground"
steel_pipe_to_ground_item.place_result = "afi_steel-pipe-to-ground"
steel_pipe_to_ground_item.order = "a[pipe]-b[steel-pipe-to-ground]"
helpers.apply_steel_icon_tint(steel_pipe_to_ground_item)
helpers.set_description(
  steel_pipe_to_ground_item,
  helpers.underground_pipe_description(steel.pipeline_extent, steel.underground_distance)
)
data:extend({ steel_pipe_to_ground_item })

local steel_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
steel_offshore_pump_item.name = "afi_steel-offshore-pump"
steel_offshore_pump_item.place_result = "afi_steel-offshore-pump"
steel_offshore_pump_item.order = "b[fluid]-a[offshore-pump-2]"
helpers.apply_steel_icon_tint(steel_offshore_pump_item)
helpers.set_description(
  steel_offshore_pump_item,
  helpers.offshore_pump_description(steel.pipeline_extent)
)
data:extend({ steel_offshore_pump_item })

local steel_pump_item = util.table.deepcopy(data.raw.item.pump)
steel_pump_item.name = "afi_steel-pump"
steel_pump_item.place_result = "afi_steel-pump"
steel_pump_item.order = "b[fluid]-b[pump-2]"
helpers.apply_steel_icon_tint(steel_pump_item)
helpers.set_description(steel_pump_item, helpers.pump_description())
data:extend({ steel_pump_item })

local reinforced_pipe_item = util.table.deepcopy(data.raw.item.pipe)
reinforced_pipe_item.name = "afi_reinforced-pipe"
reinforced_pipe_item.place_result = "afi_reinforced-pipe"
reinforced_pipe_item.order = "a[pipe]-a[reinforced-pipe]"
helpers.apply_reinforced_icon_tint(reinforced_pipe_item)
helpers.set_description(reinforced_pipe_item, helpers.pipe_description(reinforced.pipeline_extent))
data:extend({ reinforced_pipe_item })

local reinforced_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
reinforced_pipe_to_ground_item.name = "afi_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_item.place_result = "afi_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_item.order = "a[pipe]-b[reinforced-pipe-to-ground]"
helpers.apply_reinforced_icon_tint(reinforced_pipe_to_ground_item)
helpers.set_description(
  reinforced_pipe_to_ground_item,
  helpers.underground_pipe_description(reinforced.pipeline_extent, reinforced.underground_distance)
)
data:extend({ reinforced_pipe_to_ground_item })

local reinforced_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
reinforced_offshore_pump_item.name = "afi_reinforced-offshore-pump"
reinforced_offshore_pump_item.place_result = "afi_reinforced-offshore-pump"
reinforced_offshore_pump_item.order = "b[fluid]-a[offshore-pump-4]"
helpers.apply_reinforced_icon_tint(reinforced_offshore_pump_item)
helpers.set_description(
  reinforced_offshore_pump_item,
  helpers.offshore_pump_description(reinforced.pipeline_extent)
)
data:extend({ reinforced_offshore_pump_item })

local reinforced_pump_item = util.table.deepcopy(data.raw.item.pump)
reinforced_pump_item.name = "afi_reinforced-pump"
reinforced_pump_item.place_result = "afi_reinforced-pump"
reinforced_pump_item.order = "b[fluid]-b[pump-4]"
helpers.apply_reinforced_icon_tint(reinforced_pump_item)
helpers.set_description(reinforced_pump_item, helpers.pump_description())
data:extend({ reinforced_pump_item })

local rubber_lined_pipe_item = util.table.deepcopy(data.raw.item.pipe)
rubber_lined_pipe_item.name = "afi_rubber-lined-pipe"
rubber_lined_pipe_item.place_result = "afi_rubber-lined-pipe"
rubber_lined_pipe_item.order = "a[pipe]-a[rubber-lined-pipe]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_item)
helpers.set_description(rubber_lined_pipe_item, helpers.pipe_description(rubber_lined.pipeline_extent))
data:extend({ rubber_lined_pipe_item })

local rubber_lined_pipe_to_ground_item = util.table.deepcopy(data.raw.item["pipe-to-ground"])
rubber_lined_pipe_to_ground_item.name = "afi_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_item.place_result = "afi_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_item.order = "a[pipe]-b[rubber-lined-pipe-to-ground]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_to_ground_item)
helpers.set_description(
  rubber_lined_pipe_to_ground_item,
  helpers.underground_pipe_description(rubber_lined.pipeline_extent, rubber_lined.underground_distance)
)
data:extend({ rubber_lined_pipe_to_ground_item })

local rubber_lined_offshore_pump_item = util.table.deepcopy(data.raw.item["offshore-pump"])
rubber_lined_offshore_pump_item.name = "afi_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_item.place_result = "afi_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_item.order = "b[fluid]-a[offshore-pump-3]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_offshore_pump_item)
helpers.set_description(
  rubber_lined_offshore_pump_item,
  helpers.offshore_pump_description(rubber_lined.pipeline_extent)
)
data:extend({ rubber_lined_offshore_pump_item })

local rubber_lined_pump_item = util.table.deepcopy(data.raw.item.pump)
rubber_lined_pump_item.name = "afi_rubber-lined-pump"
rubber_lined_pump_item.place_result = "afi_rubber-lined-pump"
rubber_lined_pump_item.order = "b[fluid]-b[pump-3]"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pump_item)
helpers.set_description(rubber_lined_pump_item, helpers.pump_description())
data:extend({ rubber_lined_pump_item })
