local steel_pipe_casting_recipe = util.table.deepcopy(data.raw.recipe["casting-pipe"])
steel_pipe_casting_recipe.name = "afi_casting-steel-pipe"
steel_pipe_casting_recipe.enabled = false
steel_pipe_casting_recipe.order = "b[casting]-f-a[casting-steel-pipe]"
steel_pipe_casting_recipe.icon = data.raw.item["afi_steel-pipe"].icon
steel_pipe_casting_recipe.icon_size = data.raw.item["afi_steel-pipe"].icon_size
steel_pipe_casting_recipe.icons = util.table.deepcopy(data.raw.item["afi_steel-pipe"].icons)
steel_pipe_casting_recipe.ingredients = {
  { type = "fluid", name = "molten-iron", amount = 60, fluidbox_multiplier = 10 },
}
steel_pipe_casting_recipe.results = {
  { type = "item", name = "afi_steel-pipe", amount = 1 },
}
data:extend({ steel_pipe_casting_recipe })
local low_pressure_steel_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
low_pressure_steel_pipe_recipe.name = "afi_low-pressure-steel-pipe"
low_pressure_steel_pipe_recipe.enabled = false
low_pressure_steel_pipe_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe", amount = 5 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pipe_recipe.results = {
  { type = "item", name = "afi_low-pressure-steel-pipe", amount = 5 },
}
data:extend({ low_pressure_steel_pipe_recipe })

local low_pressure_steel_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
low_pressure_steel_pipe_to_ground_recipe.name = "afi_low-pressure-steel-pipe-to-ground"
low_pressure_steel_pipe_to_ground_recipe.enabled = false
low_pressure_steel_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_low-pressure-steel-pipe-to-ground", amount = 2 },
}
data:extend({ low_pressure_steel_pipe_to_ground_recipe })

local low_pressure_steel_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
low_pressure_steel_pump_recipe.name = "afi_low-pressure-steel-pump"
low_pressure_steel_pump_recipe.enabled = false
low_pressure_steel_pump_recipe.ingredients = {
  { type = "item", name = "afi_steel-pump", amount = 1 },
  { type = "item", name = "low-density-structure", amount = 1 },
}
low_pressure_steel_pump_recipe.results = {
  { type = "item", name = "afi_low-pressure-steel-pump", amount = 1 },
}
data:extend({ low_pressure_steel_pump_recipe })

local heat_resistant_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
heat_resistant_pipe_recipe.name = "afi_heat-resistant-pipe"
heat_resistant_pipe_recipe.enabled = false
heat_resistant_pipe_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe", amount = 1 },
  { type = "item", name = "calcite", amount = 1 },
}
heat_resistant_pipe_recipe.results = {
  { type = "item", name = "afi_heat-resistant-pipe", amount = 1 },
}
data:extend({ heat_resistant_pipe_recipe })

local heat_resistant_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
heat_resistant_pipe_to_ground_recipe.name = "afi_heat-resistant-pipe-to-ground"
heat_resistant_pipe_to_ground_recipe.enabled = false
heat_resistant_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "afi_steel-pipe-to-ground", amount = 2 },
  { type = "item", name = "calcite", amount = 2 },
}
heat_resistant_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_heat-resistant-pipe-to-ground", amount = 2 },
}
data:extend({ heat_resistant_pipe_to_ground_recipe })

local heat_resistant_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
heat_resistant_pump_recipe.name = "afi_heat-resistant-pump"
heat_resistant_pump_recipe.enabled = false
heat_resistant_pump_recipe.ingredients = {
  { type = "item", name = "afi_steel-pump", amount = 1 },
  { type = "item", name = "calcite", amount = 2 },
}
heat_resistant_pump_recipe.results = {
  { type = "item", name = "afi_heat-resistant-pump", amount = 1 },
}
data:extend({ heat_resistant_pump_recipe })

local tungsten_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
tungsten_pipe_recipe.name = "afi_tungsten-pipe"
tungsten_pipe_recipe.enabled = false
tungsten_pipe_recipe.ingredients = {
  { type = "item", name = "afi_heat-resistant-pipe", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 1 },
}
tungsten_pipe_recipe.results = {
  { type = "item", name = "afi_tungsten-pipe", amount = 1 },
}
data:extend({ tungsten_pipe_recipe })

local tungsten_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
tungsten_pipe_to_ground_recipe.name = "afi_tungsten-pipe-to-ground"
tungsten_pipe_to_ground_recipe.enabled = false
tungsten_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "afi_heat-resistant-pipe-to-ground", amount = 2 },
  { type = "item", name = "tungsten-plate", amount = 2 },
}
tungsten_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_tungsten-pipe-to-ground", amount = 2 },
}
data:extend({ tungsten_pipe_to_ground_recipe })

local tungsten_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
tungsten_pump_recipe.name = "afi_tungsten-pump"
tungsten_pump_recipe.enabled = false
tungsten_pump_recipe.ingredients = {
  { type = "item", name = "afi_heat-resistant-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
}
tungsten_pump_recipe.results = {
  { type = "item", name = "afi_tungsten-pump", amount = 1 },
}
data:extend({ tungsten_pump_recipe })

local tungsten_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
tungsten_offshore_pump_recipe.name = "afi_tungsten-offshore-pump"
tungsten_offshore_pump_recipe.enabled = false
tungsten_offshore_pump_recipe.ingredients = {
  { type = "item", name = "afi_steel-offshore-pump", amount = 1 },
  { type = "item", name = "tungsten-plate", amount = 5 },
}
tungsten_offshore_pump_recipe.results = {
  { type = "item", name = "afi_tungsten-offshore-pump", amount = 1 },
}
data:extend({ tungsten_offshore_pump_recipe })
local foundation_pipe_recipe = util.table.deepcopy(data.raw.recipe.pipe)
foundation_pipe_recipe.name = "afi_foundation-pipe"
foundation_pipe_recipe.enabled = false
foundation_pipe_recipe.ingredients = {
  { type = "item", name = "afi_reinforced-pipe", amount = 5 },
  { type = "item", name = "foundation", amount = 1 },
}
foundation_pipe_recipe.results = {
  { type = "item", name = "afi_foundation-pipe", amount = 5 },
}
data:extend({ foundation_pipe_recipe })

local foundation_pipe_to_ground_recipe = util.table.deepcopy(data.raw.recipe["pipe-to-ground"])
foundation_pipe_to_ground_recipe.name = "afi_foundation-pipe-to-ground"
foundation_pipe_to_ground_recipe.enabled = false
foundation_pipe_to_ground_recipe.ingredients = {
  { type = "item", name = "afi_reinforced-pipe-to-ground", amount = 2 },
  { type = "item", name = "foundation", amount = 1 },
}
foundation_pipe_to_ground_recipe.results = {
  { type = "item", name = "afi_foundation-pipe-to-ground", amount = 2 },
}
data:extend({ foundation_pipe_to_ground_recipe })

local foundation_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
foundation_offshore_pump_recipe.name = "afi_foundation-offshore-pump"
foundation_offshore_pump_recipe.enabled = false
foundation_offshore_pump_recipe.ingredients = {
  { type = "item", name = "afi_reinforced-offshore-pump", amount = 1 },
  { type = "item", name = "foundation", amount = 1 },
  { type = "item", name = "superconductor", amount = 10 },
  { type = "item", name = "lithium-plate", amount = 5 },
}
foundation_offshore_pump_recipe.results = {
  { type = "item", name = "afi_foundation-offshore-pump", amount = 1 },
}
data:extend({ foundation_offshore_pump_recipe })

local foundation_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
foundation_pump_recipe.name = "afi_foundation-pump"
foundation_pump_recipe.enabled = false
foundation_pump_recipe.ingredients = {
  { type = "item", name = "afi_reinforced-pump", amount = 1 },
  { type = "item", name = "foundation", amount = 1 },
  { type = "item", name = "superconductor", amount = 5 },
  { type = "item", name = "lithium-plate", amount = 2 },
}
foundation_pump_recipe.results = {
  { type = "item", name = "afi_foundation-pump", amount = 1 },
}
data:extend({ foundation_pump_recipe })

local high_pressure_foundation_offshore_pump_recipe = util.table.deepcopy(data.raw.recipe["offshore-pump"])
high_pressure_foundation_offshore_pump_recipe.name = "afi_high-pressure-foundation-offshore-pump"
high_pressure_foundation_offshore_pump_recipe.enabled = false
high_pressure_foundation_offshore_pump_recipe.ingredients = {
  { type = "item", name = "afi_foundation-offshore-pump", amount = 1 },
  { type = "item", name = "superconductor", amount = 40 },
  { type = "item", name = "quantum-processor", amount = 10 },
  { type = "item", name = "promethium-asteroid-chunk", amount = 25 },
}
high_pressure_foundation_offshore_pump_recipe.results = {
  { type = "item", name = "afi_high-pressure-foundation-offshore-pump", amount = 1 },
}
data:extend({ high_pressure_foundation_offshore_pump_recipe })

local high_pressure_foundation_pump_recipe = util.table.deepcopy(data.raw.recipe.pump)
high_pressure_foundation_pump_recipe.name = "afi_high-pressure-foundation-pump"
high_pressure_foundation_pump_recipe.enabled = false
high_pressure_foundation_pump_recipe.ingredients = {
  { type = "item", name = "afi_foundation-pump", amount = 1 },
  { type = "item", name = "superconductor", amount = 20 },
  { type = "item", name = "quantum-processor", amount = 5 },
  { type = "item", name = "promethium-asteroid-chunk", amount = 10 },
}
high_pressure_foundation_pump_recipe.results = {
  { type = "item", name = "afi_high-pressure-foundation-pump", amount = 1 },
}
data:extend({ high_pressure_foundation_pump_recipe })
