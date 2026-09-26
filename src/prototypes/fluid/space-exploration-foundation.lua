-- Recipes and technologies for the foundation and high-pressure foundation
-- tiers under Space Exploration without Krastorio 2. (SE excludes Space Age;
-- with K2 present, prototypes/fluid/krastorio2-foundation.lua supplies them.)
--
-- The tier values are this mod's own; the materials map the Space Age recipes
-- role for role onto SE's:
--
--   foundation tile (structure)      -> heavy composite
--   superconductor (pump machinery)  -> superconductive cable
--   lithium plate (pump control)     -> holmium solenoid
--   quantum processor                -> quantum processor
--   promethium asteroid chunk        -> naquium plate
--
-- Foundation sits at SE tier 3 (heavy composite, superconductive cable) and
-- high-pressure foundation at deep space 3 (naquium processor), where the K2
-- recipes put them under SE with Krastorio 2. Research counts follow SE's
-- scale for those tiers; the science packs are taken from the SE technologies
-- each one follows, in prototypes/fluid/space-exploration-updates.lua, after SE
-- has settled its own costs.

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
    item("se-heavy-composite", 1),
  }, 5),
  recipe("afi_foundation-pipe-to-ground", "pipe-to-ground", {
    item("afi_reinforced-pipe-to-ground", 2),
    item("se-heavy-composite", 1),
  }, 2),
  recipe("afi_foundation-offshore-pump", "offshore-pump", {
    item("afi_reinforced-offshore-pump", 1),
    item("se-heavy-composite", 1),
    item("se-superconductive-cable", 10),
    item("se-holmium-solenoid", 5),
  }),
  recipe("afi_foundation-pump", "pump", {
    item("afi_reinforced-pump", 1),
    item("se-heavy-composite", 1),
    item("se-superconductive-cable", 5),
    item("se-holmium-solenoid", 2),
  }),
  recipe("afi_high-pressure-foundation-offshore-pump", "offshore-pump", {
    item("afi_foundation-offshore-pump", 1),
    item("se-superconductive-cable", 40),
    item("se-quantum-processor", 10),
    item("se-naquium-plate", 25),
  }),
  recipe("afi_high-pressure-foundation-pump", "pump", {
    item("afi_foundation-pump", 1),
    item("se-superconductive-cable", 20),
    item("se-quantum-processor", 5),
    item("se-naquium-plate", 10),
  }),
})

-- Science packs come from the prerequisites: set here, and again in
-- data-updates once SE has settled its own costs.
data:extend({
  {
    type = "technology",
    name = "afi_foundation-pipe-infrastructure",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/foundation-fluid-pipes.png",
    icon_size = 256,
    prerequisites = {
      "afi_reinforced-pipe-infrastructure",
      "se-heavy-composite",
      "se-superconductive-cable",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_foundation-pipe" },
      { type = "unlock-recipe", recipe = "afi_foundation-pipe-to-ground" },
    },
    unit = { count = 400, ingredients = {}, time = 60 },
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
      "se-heavy-composite",
      "se-superconductive-cable",
      "se-holmium-solenoid",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_foundation-pump" },
    },
    unit = { count = 400, ingredients = {}, time = 60 },
    upgrade = true,
    order = "d-a-l",
  },
  {
    type = "technology",
    name = "afi_high-pressure-foundation-pumping",
    icon = "__advanced-fluid-infrastructure__/graphics/technology/high-pressure-foundation-fluid-pumps.png",
    icon_size = 256,
    localised_description = { "technology-description.afi_high-pressure-foundation-pumping-space-exploration" },
    prerequisites = {
      "afi_foundation-pump-infrastructure",
      "se-naquium-processor",
      "se-quantum-processor",
      "se-processing-naquium",
    },
    effects = {
      { type = "unlock-recipe", recipe = "afi_high-pressure-foundation-offshore-pump" },
      { type = "unlock-recipe", recipe = "afi_high-pressure-foundation-pump" },
    },
    unit = { count = 1000, ingredients = {}, time = 120 },
    upgrade = true,
    order = "d-a-m",
  },
})

local helpers = require("prototypes.fluid.helpers")
for _, name in pairs({
  "afi_foundation-pipe-infrastructure",
  "afi_foundation-pump-infrastructure",
  "afi_high-pressure-foundation-pumping",
}) do
  helpers.inherit_science_packs(name)
end
