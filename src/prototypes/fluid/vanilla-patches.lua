local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local iron = constants.iron

data.raw.pipe.pipe.fast_replaceable_group = "pipe"
helpers.disallow_space_platforms_and_vulcanus(data.raw.pipe.pipe)
helpers.set_fluid_box_extent(data.raw.pipe.pipe.fluid_box, iron.pipeline_extent)
data.raw.pipe.pipe.next_upgrade = "afi_steel-pipe"
helpers.set_description(data.raw.pipe.pipe, helpers.pipe_description(iron.pipeline_extent))

data.raw["pipe-to-ground"]["pipe-to-ground"].fast_replaceable_group = "pipe"
helpers.disallow_space_platforms_and_vulcanus(data.raw["pipe-to-ground"]["pipe-to-ground"])
helpers.set_underground_distance(data.raw["pipe-to-ground"]["pipe-to-ground"], iron.underground_distance)
helpers.set_fluid_box_extent(data.raw["pipe-to-ground"]["pipe-to-ground"].fluid_box, iron.pipeline_extent)
data.raw["pipe-to-ground"]["pipe-to-ground"].next_upgrade = "afi_steel-pipe-to-ground"
helpers.set_description(
  data.raw["pipe-to-ground"]["pipe-to-ground"],
  helpers.underground_pipe_description(iron.pipeline_extent, iron.underground_distance)
)

data.raw["offshore-pump"]["offshore-pump"].fast_replaceable_group = "offshore-pump"
helpers.disallow_space_platforms_and_vulcanus(data.raw["offshore-pump"]["offshore-pump"])
helpers.set_fluid_box_extent(data.raw["offshore-pump"]["offshore-pump"].fluid_box, iron.pipeline_extent)
data.raw["offshore-pump"]["offshore-pump"].pumping_speed = iron.pumping_speed
data.raw["offshore-pump"]["offshore-pump"].next_upgrade = "afi_steel-offshore-pump"
helpers.set_description(
  data.raw["offshore-pump"]["offshore-pump"],
  helpers.offshore_pump_description(iron.pipeline_extent)
)

data.raw.pump.pump.fast_replaceable_group = "pump"
helpers.disallow_space_platforms_and_vulcanus(data.raw.pump.pump)
data.raw.pump.pump.pumping_speed = iron.pumping_speed
data.raw.pump.pump.next_upgrade = "afi_steel-pump"
helpers.set_description(data.raw.pump.pump, helpers.pump_description())

local function replace_recipe_ingredient(recipe, old_name, new_name)
  if not recipe then
    return
  end

  for _, ingredient in pairs(recipe.ingredients or {}) do
    if ingredient.name == old_name then
      ingredient.name = new_name
    elseif ingredient[1] == old_name then
      ingredient[1] = new_name
    end
  end

  replace_recipe_ingredient(recipe.normal, old_name, new_name)
  replace_recipe_ingredient(recipe.expensive, old_name, new_name)
end

local function add_technology_prerequisite(technology_name, prerequisite_name)
  local technology = data.raw.technology[technology_name]
  if not technology then
    return
  end

  technology.prerequisites = technology.prerequisites or {}
  for _, existing_prerequisite in pairs(technology.prerequisites) do
    if existing_prerequisite == prerequisite_name then
      return
    end
  end
  table.insert(technology.prerequisites, prerequisite_name)
end

for _, recipe_name in pairs({
  "heat-exchanger",
  "flamethrower-turret",
  "oil-refinery",
  "pumpjack",
  "steam-turbine",
}) do
  replace_recipe_ingredient(data.raw.recipe[recipe_name], "pipe", "afi_steel-pipe")
end

add_technology_prerequisite("oil-gathering", "afi_steel-pipe-infrastructure")
add_technology_prerequisite("flamethrower", "afi_steel-pipe-infrastructure")
