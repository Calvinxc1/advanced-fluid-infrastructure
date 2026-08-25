local helpers = require("prototypes.fluid.helpers")
local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local function make_steel_fluid_technology(name, icon, effects, order)
  local technology = util.table.deepcopy(data.raw.technology["fluid-handling"])
  technology.name = name
  technology.icon = icon
  technology.icon_size = 256
  technology.prerequisites = {
    "fluid-handling",
  }
  technology.effects = effects
  technology.unit = {
    count = 100,
    ingredients = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
    },
    time = 30,
  }
  technology.upgrade = true
  technology.order = order
  return technology
end

local function make_rubber_lined_fluid_technology(name, icon, prerequisites, effects, order)
  local technology = util.table.deepcopy(data.raw.technology["fluid-handling"])
  technology.name = name
  technology.icon = icon
  technology.icon_size = 256
  technology.icons = nil
  technology.prerequisites = prerequisites
  technology.effects = effects
  technology.unit = {
    count = 250,
    ingredients = {
      { "automation-science-pack", 1 },
      { "logistic-science-pack", 1 },
      { "chemical-science-pack", 1 },
    },
    time = 30,
  }
  technology.upgrade = true
  technology.order = order
  return technology
end

data:extend({
  make_steel_fluid_technology(
    "afi_steel-pipe-infrastructure",
    "__advanced-fluid-infrastructure__/graphics/technology/steel-fluid-pipes.png",
    {
      { type = "unlock-recipe", recipe = "afi_steel-pipe" },
      { type = "unlock-recipe", recipe = "afi_steel-pipe-to-ground" },
    },
    "d-a-a"
  ),
  make_steel_fluid_technology(
    "afi_steel-pump-infrastructure",
    "__advanced-fluid-infrastructure__/graphics/technology/steel-fluid-pumps.png",
    {
      { type = "unlock-recipe", recipe = "afi_steel-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_steel-pump" },
    },
    "d-a-b"
  ),
  make_rubber_lined_fluid_technology(
    "afi_rubber-lined-pipe-infrastructure",
    "__advanced-fluid-infrastructure__/graphics/technology/rubber-lined-fluid-pipes.png",
    {
      "lubricant",
    },
    {
      { type = "unlock-recipe", recipe = "afi_rubber-lined-pipe" },
      { type = "unlock-recipe", recipe = "afi_rubber-lined-pipe-to-ground" },
    },
    "d-a-e"
  ),
  make_rubber_lined_fluid_technology(
    "afi_rubber-lined-pump-infrastructure",
    "__advanced-fluid-infrastructure__/graphics/technology/rubber-lined-fluid-pumps.png",
    {
      "afi_steel-pump-infrastructure",
      "lubricant",
    },
    {
      { type = "unlock-recipe", recipe = "afi_rubber-lined-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_rubber-lined-pump" },
    },
    "d-a-f"
  ),
  {
    type = "technology",
    name = "afi_reinforced-pipe-infrastructure",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/reinforced-fluid-pipes.png",
    icon_size = 256,
    -- Base game drops the Vulcanus tungsten tier, so reinforced hangs directly
    -- off rubber-lined and is gated on purple and yellow science instead.
    -- low-density-structure is implied transitively by utility-science-pack;
    -- concrete, which unlocks refined concrete, is not implied by anything
    -- above it and so is named explicitly.
    prerequisites = optional_dependencies.select(
      {
        "afi_rubber-lined-pipe-infrastructure",
        "afi_tungsten-pipe-infrastructure",
        "carbon-fiber",
      },
      {
        "afi_rubber-lined-pipe-infrastructure",
        "production-science-pack",
        "utility-science-pack",
        "concrete",
      }
    ),
    effects = {
      { type = "unlock-recipe", recipe = "afi_reinforced-pipe" },
      { type = "unlock-recipe", recipe = "afi_reinforced-pipe-to-ground" },
    },
    unit = {
      count = 1000,
      ingredients = optional_dependencies.select(
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
          { "chemical-science-pack", 1 },
          { "space-science-pack", 1 },
          { "metallurgic-science-pack", 1 },
          { "agricultural-science-pack", 1 },
        },
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
          { "chemical-science-pack", 1 },
          { "production-science-pack", 1 },
          { "utility-science-pack", 1 },
        }
      ),
      time = 60,
    },
    upgrade = true,
    order = "d-a-i",
  },
  {
    type = "technology",
    name = "afi_reinforced-pump-infrastructure",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/reinforced-fluid-pumps.png",
    icon_size = 256,
    -- Base game drops the Vulcanus tungsten tier, so reinforced hangs directly
    -- off rubber-lined and is gated on purple and yellow science instead.
    -- low-density-structure is implied transitively by utility-science-pack;
    -- concrete, which unlocks refined concrete, is not implied by anything
    -- above it and so is named explicitly.
    prerequisites = optional_dependencies.select(
      {
        "afi_rubber-lined-pump-infrastructure",
        "afi_tungsten-pump-infrastructure",
        "carbon-fiber",
      },
      {
        "afi_rubber-lined-pump-infrastructure",
        "production-science-pack",
        "utility-science-pack",
        "concrete",
      }
    ),
    effects = {
      { type = "unlock-recipe", recipe = "afi_reinforced-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_reinforced-pump" },
    },
    unit = {
      count = 1000,
      ingredients = optional_dependencies.select(
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
          { "chemical-science-pack", 1 },
          { "space-science-pack", 1 },
          { "metallurgic-science-pack", 1 },
          { "agricultural-science-pack", 1 },
        },
        {
          { "automation-science-pack", 1 },
          { "logistic-science-pack", 1 },
          { "chemical-science-pack", 1 },
          { "production-science-pack", 1 },
          { "utility-science-pack", 1 },
        }
      ),
      time = 60,
    },
    upgrade = true,
    order = "d-a-j",
  },
})

helpers.add_unlock("steam-power", "pipe")
helpers.add_unlock("steam-power", "pipe-to-ground")
helpers.add_unlock("steam-power", "offshore-pump")
