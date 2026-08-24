local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local steel_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
steel_pipe_recipe.name = "afi_steel-pipe"
steel_pipe_recipe.enabled = false
steel_pipe_recipe.ingredients = {
  { type = "item", name = "pipe", amount = 1 },
  { type = "item", name = "steel-plate", amount = 1 },
}
steel_pipe_recipe.results = {
  { type = "item", name = "afi_steel-pipe", amount = 1 },
}
data:extend({ steel_pipe_recipe })

local steel_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
steel_pipe_to_ground_recipe.name = "afi_steel-pipe-to-ground"
steel_pipe_to_ground_recipe.enabled = false
steel_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "pipe-to-ground", amount = 2 },
  { type = "item", name = "steel-plate", amount = 4 },
}
steel_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_steel-pipe-to-ground", amount = 2 },
}
data:extend({ steel_pipe_to_ground_recipe })

local steel_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
steel_offshore_pump_recipe.name = "afi_steel-offshore-pump"
steel_offshore_pump_recipe.enabled = false
steel_offshore_pump_recipe.ingredients = {
  { type = "item", name = "offshore-pump", amount = 1 },
  { type = "item", name = "steel-plate", amount = 5 },
  { type = "item", name = "engine-unit", amount = 1 },
}
steel_offshore_pump_recipe.results = {
  { type = "item", name = "afi_steel-offshore-pump", amount = 1 },
}
data:extend({ steel_offshore_pump_recipe })

local steel_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
steel_pump_recipe.name = "afi_steel-pump"
steel_pump_recipe.enabled = false
steel_pump_recipe.ingredients = {
  { type = "item", name = "pump", amount = 1 },
  { type = "item", name = "steel-plate", amount = 5 },
  { type = "item", name = "engine-unit", amount = 1 },
}
steel_pump_recipe.results = {
  { type = "item", name = "afi_steel-pump", amount = 1 },
}
data:extend({ steel_pump_recipe })

local rubber_lined_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
rubber_lined_pipe_recipe.name = "afi_rubber-lined-pipe"
rubber_lined_pipe_recipe.enabled = false
rubber_lined_pipe_recipe.categories = { "crafting-with-fluid" }
rubber_lined_pipe_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 1 },
  { type = "fluid", name = "lubricant", amount = 5 },
}
rubber_lined_pipe_recipe.results = {
  { type = "item", name = "afi_rubber-lined-pipe", amount = 1 },
}
data:extend({ rubber_lined_pipe_recipe })

local rubber_lined_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
rubber_lined_pipe_to_ground_recipe.name = "afi_rubber-lined-pipe-to-ground"
rubber_lined_pipe_to_ground_recipe.enabled = false
rubber_lined_pipe_to_ground_recipe.categories = { "crafting-with-fluid" }
rubber_lined_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "plastic-bar", amount = 4 },
  { type = "fluid", name = "lubricant", amount = 20 },
}
rubber_lined_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_rubber-lined-pipe-to-ground", amount = 2 },
}
data:extend({ rubber_lined_pipe_to_ground_recipe })

local rubber_lined_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
rubber_lined_offshore_pump_recipe.name = "afi_rubber-lined-offshore-pump"
rubber_lined_offshore_pump_recipe.enabled = false
rubber_lined_offshore_pump_recipe.categories = { "crafting-with-fluid" }
rubber_lined_offshore_pump_recipe.ingredients = {
  { type = "item", name = "afi_steel-offshore-pump", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 5 },
  { type = "fluid", name = "lubricant", amount = 30 },
}
rubber_lined_offshore_pump_recipe.results = {
  { type = "item", name = "afi_rubber-lined-offshore-pump", amount = 1 },
}
data:extend({ rubber_lined_offshore_pump_recipe })

local rubber_lined_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
rubber_lined_pump_recipe.name = "afi_rubber-lined-pump"
rubber_lined_pump_recipe.enabled = false
rubber_lined_pump_recipe.categories = { "crafting-with-fluid" }
rubber_lined_pump_recipe.ingredients = {
  { type = "item", name = "afi_steel-pump", amount = 1 },
  { type = "item", name = "plastic-bar", amount = 5 },
  { type = "fluid", name = "lubricant", amount = 30 },
}
rubber_lined_pump_recipe.results = {
  { type = "item", name = "afi_rubber-lined-pump", amount = 1 },
}
data:extend({ rubber_lined_pump_recipe })

local reinforced_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
reinforced_pipe_recipe.name = "afi_reinforced-pipe"
reinforced_pipe_recipe.enabled = false
reinforced_pipe_recipe.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("afi_rubber-lined-pipe", 1),
  optional_dependencies.reinforcement_ingredients(1)
)
reinforced_pipe_recipe.results = {
  { type = "item", name = "afi_reinforced-pipe", amount = 1 },
}
data:extend({ reinforced_pipe_recipe })

local reinforced_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
reinforced_pipe_to_ground_recipe.name = "afi_reinforced-pipe-to-ground"
reinforced_pipe_to_ground_recipe.enabled = false
reinforced_pipe_to_ground_recipe.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("afi_rubber-lined-pipe-to-ground", 2),
  optional_dependencies.reinforcement_ingredients(4)
)
reinforced_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_reinforced-pipe-to-ground", amount = 2 },
}
data:extend({ reinforced_pipe_to_ground_recipe })

local reinforced_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
reinforced_offshore_pump_recipe.name = "afi_reinforced-offshore-pump"
reinforced_offshore_pump_recipe.enabled = false
reinforced_offshore_pump_recipe.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("afi_rubber-lined-offshore-pump", 1),
  optional_dependencies.reinforcement_ingredients(5)
)
reinforced_offshore_pump_recipe.results = {
  { type = "item", name = "afi_reinforced-offshore-pump", amount = 1 },
}
data:extend({ reinforced_offshore_pump_recipe })

local reinforced_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
reinforced_pump_recipe.name = "afi_reinforced-pump"
reinforced_pump_recipe.enabled = false
reinforced_pump_recipe.ingredients = optional_dependencies.ingredients(
  optional_dependencies.item("afi_rubber-lined-pump", 1),
  optional_dependencies.reinforcement_ingredients(5)
)
reinforced_pump_recipe.results = {
  { type = "item", name = "afi_reinforced-pump", amount = 1 },
}
data:extend({ reinforced_pump_recipe })
