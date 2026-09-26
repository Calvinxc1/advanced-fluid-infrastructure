-- Recipes and technologies for the foundation and high-pressure foundation
-- tiers under Krastorio 2 without Space Age. With Space Age present its own
-- recipes and technologies (prototypes/fluid/space-age/) are used instead.
--
-- Without these tiers a K2 base-game load topped out at reinforced (600/s)
-- from purple/yellow science onward, through the matter, advanced and
-- singularity stages where K2's fusion steam, matter plants and antimatter
-- ask the most of fluid infrastructure. The tier values are this mod's own;
-- only the materials and unlocks are K2's, mapped from the Space Age recipes
-- role for role:
--
--   foundation tile (structure)      -> imersium beam
--   superconductor (pump machinery)  -> imersium gear wheel
--   lithium plate (pump control)     -> energy control unit
--   quantum processor                -> AI core
--   promethium asteroid chunk        -> charged matter stabilizer
--
-- Foundation sits after K2's imersium processing and advanced tech card, and
-- is researched with the pack set K2 uses at that stage. High-pressure
-- foundation sits after K2's singularity tech card.

local function recipe(name, template, ingredients, amount)
  local prototype = util.table.deepcopy(data.raw.recipe[template])
  prototype.name = name
  prototype.enabled = false
  prototype.ingredients = ingredients
  prototype.results = { { type = "item", name = name, amount = amount or 1 } }
  return prototype
end

local function item(name, amount)
  return { type = "item", name = name, amount = amount }
end

data:extend({
  recipe("afi_foundation-pipe", "pipe", {
    item("afi_reinforced-pipe", 5),
    item("kr-imersium-beam", 1),
  }, 5),
  recipe("afi_foundation-pipe-to-ground", "pipe-to-ground", {
    item("afi_reinforced-pipe-to-ground", 2),
    item("kr-imersium-beam", 1),
  }, 2),
  recipe("afi_foundation-offshore-pump", "offshore-pump", {
    item("afi_reinforced-offshore-pump", 1),
    item("kr-imersium-beam", 1),
    item("kr-imersium-gear-wheel", 10),
    item("kr-energy-control-unit", 5),
  }),
  recipe("afi_foundation-pump", "pump", {
    item("afi_reinforced-pump", 1),
    item("kr-imersium-beam", 1),
    item("kr-imersium-gear-wheel", 5),
    item("kr-energy-control-unit", 2),
  }),
  recipe("afi_high-pressure-foundation-offshore-pump", "offshore-pump", {
    item("afi_foundation-offshore-pump", 1),
    item("kr-imersium-gear-wheel", 40),
    item("kr-ai-core", 10),
    item("kr-charged-matter-stabilizer", 25),
  }),
  recipe("afi_high-pressure-foundation-pump", "pump", {
    item("afi_foundation-pump", 1),
    item("kr-imersium-gear-wheel", 20),
    item("kr-ai-core", 5),
    item("kr-charged-matter-stabilizer", 10),
  }),
})

local ADVANCED_STAGE = {
  { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
  { "kr-matter-tech-card", 1 },
  { "kr-advanced-tech-card", 1 },
}

local SINGULARITY_STAGE = {
  { "production-science-pack", 1 },
  { "utility-science-pack", 1 },
  { "space-science-pack", 1 },
  { "kr-matter-tech-card", 1 },
  { "kr-advanced-tech-card", 1 },
  { "kr-singularity-tech-card", 1 },
}

data:extend({
  {
    type = "technology",
    name = "afi_foundation-pipe-infrastructure",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/foundation-fluid-pipes.png",
    icon_size = 256,
    prerequisites = {
      "afi_reinforced-pipe-infrastructure",
      "kr-advanced-tech-card",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_foundation-pipe" },
      { type = "unlock-recipe", recipe = "afi_foundation-pipe-to-ground" },
    },
    unit = { count = 2500, ingredients = ADVANCED_STAGE, time = 60 },
    upgrade = true,
    order = "d-a-k",
  },
  {
    type = "technology",
    name = "afi_foundation-pump-infrastructure",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/foundation-fluid-pumps.png",
    icon_size = 256,
    prerequisites = {
      "afi_reinforced-pump-infrastructure",
      "kr-advanced-tech-card",
      "kr-energy-control-unit",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_foundation-pump" },
    },
    unit = { count = 2500, ingredients = ADVANCED_STAGE, time = 60 },
    upgrade = true,
    order = "d-a-l",
  },
  {
    type = "technology",
    name = "afi_high-pressure-foundation-pumping",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/high-pressure-foundation-fluid-pumps.png",
    icon_size = 256,
    localised_description = { "technology-description.afi_high-pressure-foundation-pumping-krastorio2" },
    prerequisites = {
      "afi_foundation-pump-infrastructure",
      "kr-singularity-tech-card",
      "kr-ai-core",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_high-pressure-foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_high-pressure-foundation-pump" },
    },
    unit = { count = 5000, ingredients = SINGULARITY_STAGE, time = 120 },
    upgrade = true,
    order = "d-a-m",
  },
})
