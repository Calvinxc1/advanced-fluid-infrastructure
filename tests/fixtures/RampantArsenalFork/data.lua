local reinforced_pipe = "reinforced-pipe-rampant-arsenal"
local reinforced_pipe_to_ground = "reinforced-pipe-to-ground-rampant-arsenal"

local pipe = table.deepcopy(data.raw.pipe.pipe)
pipe.name = reinforced_pipe
pipe.minable = {mining_time = 0.1, result = reinforced_pipe}

local pipe_to_ground = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
pipe_to_ground.name = reinforced_pipe_to_ground
pipe_to_ground.minable = {mining_time = 0.1, result = reinforced_pipe_to_ground}

local pipe_item = table.deepcopy(data.raw.item.pipe)
pipe_item.name = reinforced_pipe
pipe_item.place_result = reinforced_pipe

local pipe_to_ground_item = table.deepcopy(data.raw.item["pipe-to-ground"])
pipe_to_ground_item.name = reinforced_pipe_to_ground
pipe_to_ground_item.place_result = reinforced_pipe_to_ground

local recycling_technology = table.deepcopy(data.raw.technology.logistics)
recycling_technology.name = "rampant-arsenal-recycling-technology"
recycling_technology.effects = {
  {type = "unlock-recipe", recipe = "rampant-arsenal-recycling-positional-ingredient"},
  {type = "unlock-recipe", recipe = "rampant-arsenal-recycling-keyed-result"},
  {type = "unlock-recipe", recipe = "rampant-arsenal-recycling-single-result"},
}

local reinforced_pipes_technology = table.deepcopy(data.raw.technology.logistics)
reinforced_pipes_technology.name = "rampant-arsenal-technology-reinforced-pipes"
reinforced_pipes_technology.effects = {
  {type = "unlock-recipe", recipe = reinforced_pipe},
  {type = "unlock-recipe", recipe = reinforced_pipe_to_ground},
}

data:extend({
  pipe,
  pipe_to_ground,
  pipe_item,
  pipe_to_ground_item,
  {
    type = "recipe",
    name = reinforced_pipe,
    enabled = false,
    ingredients = {{type = "item", name = "iron-plate", amount = 1}},
    results = {{type = "item", name = reinforced_pipe, amount = 1}},
  },
  {
    type = "recipe",
    name = reinforced_pipe_to_ground,
    enabled = false,
    ingredients = {{type = "item", name = "iron-plate", amount = 1}},
    results = {{type = "item", name = reinforced_pipe_to_ground, amount = 1}},
  },
  {
    type = "recipe",
    name = "rampant-arsenal-recycling-positional-ingredient",
    enabled = false,
    ingredients = {{reinforced_pipe, 1}},
    results = {{type = "item", name = "iron-plate", amount = 1}},
  },
  {
    type = "recipe",
    name = "rampant-arsenal-recycling-keyed-result",
    enabled = false,
    ingredients = {{type = "item", name = "iron-plate", amount = 1}},
    results = {{type = "item", name = reinforced_pipe_to_ground, amount = 1}},
  },
  {
    type = "recipe",
    name = "rampant-arsenal-recycling-single-result",
    enabled = false,
    ingredients = {{type = "item", name = "iron-plate", amount = 1}},
    result = reinforced_pipe,
  },
  recycling_technology,
  reinforced_pipes_technology,
})
