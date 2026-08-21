local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local steel = constants.steel
local reinforced = constants.reinforced
local rubber_lined = constants.rubber_lined

local steel_pipe = util.table.deepcopy(data.raw.pipe.pipe)
steel_pipe.name = "afi_steel-pipe"
steel_pipe.minable.result = "afi_steel-pipe"
steel_pipe.max_health = 150
helpers.disallow_space_platforms_and_vulcanus(steel_pipe)
helpers.apply_steel_icon_tint(steel_pipe)
helpers.set_fluid_box_extent(steel_pipe.fluid_box, steel.pipeline_extent)
steel_pipe.next_upgrade = "afi_rubber-lined-pipe"
helpers.set_description(steel_pipe, helpers.pipe_description(steel.pipeline_extent))
data:extend({ steel_pipe })

local steel_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
steel_pipe_to_ground.name = "afi_steel-pipe-to-ground"
steel_pipe_to_ground.minable.result = "afi_steel-pipe-to-ground"
steel_pipe_to_ground.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_pipe_to_ground)
helpers.apply_steel_icon_tint(steel_pipe_to_ground)
helpers.set_underground_distance(steel_pipe_to_ground, steel.underground_distance)
helpers.set_fluid_box_extent(steel_pipe_to_ground.fluid_box, steel.pipeline_extent)
steel_pipe_to_ground.next_upgrade = "afi_rubber-lined-pipe-to-ground"
helpers.set_description(
  steel_pipe_to_ground,
  helpers.underground_pipe_description(steel.pipeline_extent, steel.underground_distance)
)
data:extend({ steel_pipe_to_ground })

local steel_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
steel_offshore_pump.name = "afi_steel-offshore-pump"
steel_offshore_pump.minable.result = "afi_steel-offshore-pump"
steel_offshore_pump.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_offshore_pump)
steel_offshore_pump.pumping_speed = steel.pumping_speed
helpers.apply_steel_icon_tint(steel_offshore_pump)
helpers.set_fluid_box_extent(steel_offshore_pump.fluid_box, steel.pipeline_extent)
steel_offshore_pump.next_upgrade = "afi_rubber-lined-offshore-pump"
helpers.set_description(
  steel_offshore_pump,
  helpers.offshore_pump_description(steel.pipeline_extent)
)
data:extend({ steel_offshore_pump })

local steel_pump = util.table.deepcopy(data.raw.pump.pump)
steel_pump.name = "afi_steel-pump"
steel_pump.minable.result = "afi_steel-pump"
steel_pump.max_health = 200
helpers.disallow_space_platforms_and_vulcanus(steel_pump)
steel_pump.pumping_speed = steel.pumping_speed
steel_pump.next_upgrade = "afi_rubber-lined-pump"
helpers.apply_steel_icon_tint(steel_pump)
helpers.set_description(steel_pump, helpers.pump_description())
data:extend({ steel_pump })

local reinforced_pipe = util.table.deepcopy(data.raw.pipe.pipe)
reinforced_pipe.name = "afi_reinforced-pipe"
reinforced_pipe.minable.result = "afi_reinforced-pipe"
reinforced_pipe.max_health = 260
helpers.disallow_space_platforms(reinforced_pipe)
helpers.apply_reinforced_icon_tint(reinforced_pipe)
helpers.apply_reinforced_entity_tint(reinforced_pipe)
helpers.set_resistances(reinforced_pipe, reinforced.resistances)
helpers.set_fluid_box_extent(reinforced_pipe.fluid_box, reinforced.pipeline_extent)
helpers.set_description(reinforced_pipe, helpers.pipe_description(reinforced.pipeline_extent))
-- Reinforced is the terminal tier in a base-game load. These prototypes are
-- deepcopies of the vanilla ones, which vanilla-patches.lua has already
-- pointed at the steel tier, so the inherited next_upgrade must be cleared
-- explicitly. prototypes/fluid/space-age/entities.lua re-points it at the
-- foundation tier when Space Age is present.
reinforced_pipe.next_upgrade = nil
data:extend({ reinforced_pipe })

local reinforced_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
reinforced_pipe_to_ground.name = "afi_reinforced-pipe-to-ground"
reinforced_pipe_to_ground.minable.result = "afi_reinforced-pipe-to-ground"
reinforced_pipe_to_ground.max_health = 320
helpers.disallow_space_platforms(reinforced_pipe_to_ground)
helpers.apply_reinforced_icon_tint(reinforced_pipe_to_ground)
helpers.apply_reinforced_entity_tint(reinforced_pipe_to_ground)
helpers.set_resistances(reinforced_pipe_to_ground, reinforced.resistances)
helpers.set_underground_distance(reinforced_pipe_to_ground, reinforced.underground_distance)
helpers.set_fluid_box_extent(reinforced_pipe_to_ground.fluid_box, reinforced.pipeline_extent)
helpers.set_description(
  reinforced_pipe_to_ground,
  helpers.underground_pipe_description(reinforced.pipeline_extent, reinforced.underground_distance)
)
reinforced_pipe_to_ground.next_upgrade = nil
data:extend({ reinforced_pipe_to_ground })

local reinforced_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
reinforced_offshore_pump.name = "afi_reinforced-offshore-pump"
reinforced_offshore_pump.minable.result = "afi_reinforced-offshore-pump"
reinforced_offshore_pump.max_health = 330
helpers.disallow_space_platforms(reinforced_offshore_pump)
reinforced_offshore_pump.pumping_speed = reinforced.pumping_speed
helpers.apply_reinforced_icon_tint(reinforced_offshore_pump)
helpers.apply_reinforced_entity_tint(reinforced_offshore_pump)
helpers.set_resistances(reinforced_offshore_pump, reinforced.resistances)
helpers.set_fluid_box_extent(reinforced_offshore_pump.fluid_box, reinforced.pipeline_extent)
helpers.set_description(
  reinforced_offshore_pump,
  helpers.offshore_pump_description(reinforced.pipeline_extent)
)
reinforced_offshore_pump.next_upgrade = nil
data:extend({ reinforced_offshore_pump })

local reinforced_pump = util.table.deepcopy(data.raw.pump.pump)
reinforced_pump.name = "afi_reinforced-pump"
reinforced_pump.minable.result = "afi_reinforced-pump"
reinforced_pump.max_health = 330
helpers.disallow_space_platforms(reinforced_pump)
reinforced_pump.pumping_speed = reinforced.pumping_speed
helpers.apply_reinforced_icon_tint(reinforced_pump)
helpers.apply_reinforced_entity_tint(reinforced_pump)
helpers.set_resistances(reinforced_pump, reinforced.resistances)
helpers.set_description(reinforced_pump, helpers.pump_description())
reinforced_pump.next_upgrade = nil
data:extend({ reinforced_pump })

local rubber_lined_pipe = util.table.deepcopy(data.raw.pipe.pipe)
rubber_lined_pipe.name = "afi_rubber-lined-pipe"
rubber_lined_pipe.minable.result = "afi_rubber-lined-pipe"
rubber_lined_pipe.max_health = 180
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pipe)
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pipe)
helpers.set_fluid_box_extent(rubber_lined_pipe.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_pipe.next_upgrade = "afi_reinforced-pipe"
helpers.set_description(rubber_lined_pipe, helpers.pipe_description(rubber_lined.pipeline_extent))
data:extend({ rubber_lined_pipe })

local rubber_lined_pipe_to_ground = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
rubber_lined_pipe_to_ground.name = "afi_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground.minable.result = "afi_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground.max_health = 230
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pipe_to_ground)
helpers.apply_rubber_lined_icon_tint(rubber_lined_pipe_to_ground)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pipe_to_ground)
helpers.set_underground_distance(rubber_lined_pipe_to_ground, rubber_lined.underground_distance)
helpers.set_fluid_box_extent(rubber_lined_pipe_to_ground.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_pipe_to_ground.next_upgrade = "afi_reinforced-pipe-to-ground"
helpers.set_description(
  rubber_lined_pipe_to_ground,
  helpers.underground_pipe_description(rubber_lined.pipeline_extent, rubber_lined.underground_distance)
)
data:extend({ rubber_lined_pipe_to_ground })

local rubber_lined_offshore_pump = util.table.deepcopy(data.raw["offshore-pump"]["offshore-pump"])
rubber_lined_offshore_pump.name = "afi_rubber-lined-offshore-pump"
rubber_lined_offshore_pump.minable.result = "afi_rubber-lined-offshore-pump"
rubber_lined_offshore_pump.max_health = 240
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_offshore_pump)
rubber_lined_offshore_pump.pumping_speed = rubber_lined.pumping_speed
helpers.apply_rubber_lined_icon_tint(rubber_lined_offshore_pump)
helpers.apply_rubber_lined_entity_tint(rubber_lined_offshore_pump)
helpers.set_fluid_box_extent(rubber_lined_offshore_pump.fluid_box, rubber_lined.pipeline_extent)
rubber_lined_offshore_pump.next_upgrade = "afi_reinforced-offshore-pump"
helpers.set_description(
  rubber_lined_offshore_pump,
  helpers.offshore_pump_description(rubber_lined.pipeline_extent)
)
data:extend({ rubber_lined_offshore_pump })

local rubber_lined_pump = util.table.deepcopy(data.raw.pump.pump)
rubber_lined_pump.name = "afi_rubber-lined-pump"
rubber_lined_pump.minable.result = "afi_rubber-lined-pump"
rubber_lined_pump.max_health = 240
helpers.disallow_space_platforms_and_vulcanus(rubber_lined_pump)
rubber_lined_pump.pumping_speed = rubber_lined.pumping_speed
rubber_lined_pump.next_upgrade = "afi_reinforced-pump"
helpers.apply_rubber_lined_icon_tint(rubber_lined_pump)
helpers.apply_rubber_lined_entity_tint(rubber_lined_pump)
helpers.set_description(rubber_lined_pump, helpers.pump_description())
data:extend({ rubber_lined_pump })
