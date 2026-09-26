-- The foundation and high-pressure foundation tiers: items.
--
-- Built whenever a load has a late game to put them in: Space Age, or
-- Krastorio 2. The prototypes are the same in both; only the recipes and
-- technologies differ, and those live with the mod that supplies their
-- materials (prototypes/fluid/space-age/ and prototypes/fluid/krastorio2-foundation.lua).

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local foundation = constants.foundation
local high_pressure_foundation = constants.high_pressure_foundation

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
