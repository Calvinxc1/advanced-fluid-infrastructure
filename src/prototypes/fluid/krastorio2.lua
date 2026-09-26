-- Krastorio 2 integration. Loaded from prototypes/fluid.lua only when K2 is
-- present, after every tier exists and before the menu layout runs.
--
-- The rule is that this mod's tier numbers carry and K2's recipes, ingredients
-- and unlocks are followed:
--
--   * K2's steel pipe, pipe to ground and pump become this mod's steel tier.
--     K2's own recipes consume its steel pipe, so the K2 line stays and this
--     mod's duplicates are removed. The steel tier's numbers reach the K2
--     prototypes through tier-apply.lua, which resolves the steel tier's names
--     through optional_dependencies.name().
--   * K2's steel-fluid-handling technology is the one steel unlock; this mod's
--     two steel technologies are removed and their remaining unlocks move to it.
--   * K2's steel pipes join only other steel pipes, so iron and steel lines can
--     run side by side. Every tier above iron is made from steel pipe, so every
--     one of them joins the steel family too, and upgrading a steel line keeps
--     it sealed off from neighbouring iron pipes.
--
-- Offshore pump power follows the vanilla offshore pump, which K2 makes
-- electric; see prototypes/fluid/offshore-power.lua.

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")
local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local steel = constants.steel
local substitutions = optional_dependencies.substitutions()

local function owned(name)
  return string.sub(name, 1, 4) == "afi_"
end

local function substitute_entries(entries)
  for _, entry in pairs(entries or {}) do
    if entry.name and substitutions[entry.name] then
      entry.name = substitutions[entry.name]
    end
  end
end

-- Recipes: ingredients and results that named this mod's steel prototypes now
-- name K2's.
for name, recipe in pairs(data.raw.recipe) do
  if owned(name) then
    substitute_entries(recipe.ingredients)
    substitute_entries(recipe.results)
  end
end

-- Upgrade chains that stepped through this mod's steel prototypes.
for _, category in pairs({ "pipe", "pipe-to-ground", "pump", "offshore-pump" }) do
  for name, prototype in pairs(data.raw[category] or {}) do
    if owned(name) and prototype.next_upgrade and substitutions[prototype.next_upgrade] then
      prototype.next_upgrade = substitutions[prototype.next_upgrade]
    end
  end
end

-- Technologies. A removed technology hands every unlock that still exists to
-- its replacement, then prerequisites are rewritten and de-duplicated.
local removed = {}
for ours in pairs(substitutions) do
  removed[ours] = true
end

for ours, theirs in pairs(substitutions) do
  local technology = data.raw.technology[ours]
  local replacement = data.raw.technology[theirs]
  if technology and replacement then
    for _, effect in pairs(technology.effects or {}) do
      if not (effect.type == "unlock-recipe" and removed[effect.recipe]) then
        replacement.effects = replacement.effects or {}
        table.insert(replacement.effects, util.table.deepcopy(effect))
      end
    end
  end
end

for name, technology in pairs(data.raw.technology) do
  if owned(name) and technology.prerequisites then
    local seen, prerequisites = {}, {}
    for _, prerequisite in pairs(technology.prerequisites) do
      prerequisite = substitutions[prerequisite] or prerequisite
      if not seen[prerequisite] then
        seen[prerequisite] = true
        table.insert(prerequisites, prerequisite)
      end
    end
    technology.prerequisites = prerequisites
  end
end

-- Recipes that consume a steel-tier item need K2's steel unlock researched
-- first. In the base game that is implied through oil-gathering, which
-- vanilla-patches.lua makes require the steel tier; under K2 that edit is
-- skipped to keep K2's tree, so the requirement is stated directly on every
-- technology that unlocks such a recipe and does not already lead through it.
local steel_unlock_name = optional_dependencies.name("afi_steel-pipe-infrastructure")
local steel_unlock = data.raw.technology[steel_unlock_name]

if steel_unlock then
  local steel_items = {}
  for _, effect in pairs(steel_unlock.effects or {}) do
    local recipe = effect.type == "unlock-recipe" and data.raw.recipe[effect.recipe]
    for _, result in pairs(recipe and recipe.results or {}) do
      steel_items[result.name] = true
    end
  end

  local function leads_through(technology_name, seen)
    if technology_name == steel_unlock_name then
      return true
    end
    seen = seen or {}
    if seen[technology_name] then
      return false
    end
    seen[technology_name] = true
    local technology = data.raw.technology[technology_name]
    for _, prerequisite in pairs(technology and technology.prerequisites or {}) do
      if leads_through(prerequisite, seen) then
        return true
      end
    end
    return false
  end

  local function needs_steel(recipe_name)
    local recipe = owned(recipe_name) and data.raw.recipe[recipe_name]
    for _, ingredient in pairs(recipe and recipe.ingredients or {}) do
      if steel_items[ingredient.name] then
        return true
      end
    end
    return false
  end

  for name, technology in pairs(data.raw.technology) do
    for _, effect in pairs(technology.effects or {}) do
      if effect.type == "unlock-recipe" and needs_steel(effect.recipe) and not leads_through(name) then
        technology.prerequisites = technology.prerequisites or {}
        table.insert(technology.prerequisites, 1, steel_unlock_name)
        break
      end
    end
  end
end

-- Remove the duplicates. This runs in data.lua, before any pass (the recycler
-- above all) has generated anything from them.
for ours in pairs(substitutions) do
  for _, category in pairs({ "pipe", "pipe-to-ground", "pump", "item", "recipe", "technology" }) do
    if data.raw[category] then
      data.raw[category][ours] = nil
    end
  end
end

-- The Space Age steel-pipe casting recipe copied its icon from this mod's
-- steel pipe item; it now casts K2's.
local casting = data.raw.recipe["afi_casting-steel-pipe"]
local kr_steel_pipe_item = data.raw.item["kr-steel-pipe"]
if casting and kr_steel_pipe_item then
  casting.icon = kr_steel_pipe_item.icon
  casting.icon_size = kr_steel_pipe_item.icon_size
  casting.icons = util.table.deepcopy(kr_steel_pipe_item.icons)
end

-- The K2 steel line as the steel tier: where it upgrades to, where it may be
-- placed, and the tier's stats line beneath K2's own description.
local function describe(prototype, own_key, stats)
  if not prototype then
    return
  end
  if own_key then
    prototype.localised_description = { "", { own_key }, "\n", stats }
  else
    prototype.localised_description = stats
  end
end

local steel_line = {
  {
    category = "pipe",
    name = "kr-steel-pipe",
    upgrade = "afi_rubber-lined-pipe",
    own_key = "entity-description.kr-steel-pipe",
    stats = helpers.pipe_description(steel.pipeline_extent),
  },
  {
    category = "pipe-to-ground",
    name = "kr-steel-pipe-to-ground",
    upgrade = "afi_rubber-lined-pipe-to-ground",
    own_key = "entity-description.kr-steel-pipe-to-ground",
    stats = helpers.underground_pipe_description(steel.pipeline_extent, steel.underground_distance),
  },
  {
    category = "pump",
    name = "kr-steel-pump",
    upgrade = "afi_rubber-lined-pump",
    stats = helpers.pump_description(),
  },
}

for _, member in pairs(steel_line) do
  local entity = data.raw[member.category][member.name]
  if entity then
    entity.next_upgrade = member.upgrade
    helpers.disallow_space_platforms_and_vulcanus(entity)
    describe(entity, member.own_key, member.stats)
    describe(data.raw.item[member.name], member.own_key, util.table.deepcopy(member.stats))
  end
end

-- Every pipe tier above iron joins the steel family, on its underground
-- connections as well, exactly as K2's steel pipe to ground does.
for _, category in pairs({ "pipe", "pipe-to-ground" }) do
  for name, prototype in pairs(data.raw[category]) do
    if owned(name) and prototype.fluid_box then
      for _, connection in pairs(prototype.fluid_box.pipe_connections or {}) do
        connection.connection_category = "kr-steel-pipe"
      end
    end
  end
end

-- K2 has no steel offshore pump, so this mod's stays. Its recipe mirrors K2's
-- steel pump rather than the base-game steel plate recipe.
local steel_offshore_pump_recipe = data.raw.recipe["afi_steel-offshore-pump"]
if steel_offshore_pump_recipe then
  steel_offshore_pump_recipe.ingredients = {
    { type = "item", name = "offshore-pump", amount = 1 },
    { type = "item", name = "kr-steel-gear-wheel", amount = 4 },
    { type = "item", name = "engine-unit", amount = 1 },
    { type = "item", name = "kr-steel-beam", amount = 1 },
    { type = "item", name = "kr-steel-pipe", amount = 1 },
  }
end
