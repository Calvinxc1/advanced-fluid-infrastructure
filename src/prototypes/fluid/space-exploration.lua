-- Space Exploration integration. Loaded from prototypes/fluid.lua only when SE
-- is present, after every tier exists and after the Krastorio 2 pass.
--
-- SE's space pipes are usable everywhere, in space and on the ground, and left
-- alone they carry the engine-default pipeline extent (320) from rocket
-- science on, which bypasses every tier of this mod up to foundation. Where
-- the foundation tier exists above them (see
-- optional_dependencies.has_space_branch) they become this mod's space branch,
-- the role Space Age's platform-only low-pressure steel tier plays:
--
--   * se-space-pipe and se-space-pipe-to-ground carry the low_pressure_steel
--     tier's numbers. tier-apply.lua reaches them through
--     optional_dependencies.name(); SE's long space pipes, which are storage
--     tanks, get the same extent and stats line in
--     prototypes/fluid/space-exploration-updates.lua.
--   * Foundation stays on the main, ground-only upgrade path from reinforced.
--     Factorio requires an upgrade target to share its source's collision mask
--     and SE gives space-capable pipes their own, so one foundation pipe cannot
--     both follow reinforced and go into space. Space instead gets a standalone
--     space foundation pipe and pipe to ground: foundation's numbers, crafted
--     from a foundation pipe, outside every upgrade chain.
--
-- Pumps need nothing: SE never blocks pump-type entities from space.

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")
local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local space = constants.low_pressure_steel

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

if optional_dependencies.has_space_branch then
  local space_branch = {
    {
      category = "pipe",
      name = "se-space-pipe",
      stats = helpers.pipe_description(space.pipeline_extent),
    },
    {
      category = "pipe-to-ground",
      name = "se-space-pipe-to-ground",
      own_key = "entity-description.se-space-pipe-to-ground",
      stats = helpers.underground_pipe_description(space.pipeline_extent, space.underground_distance),
    },
  }

  for _, member in pairs(space_branch) do
    local entity = data.raw[member.category][member.name]
    if entity then
      describe(entity, member.own_key, member.stats)
      describe(data.raw.item[member.name], member.own_key, util.table.deepcopy(member.stats))

      -- Under K2 every tier above iron is a steel-family pipe, and the space
      -- branch has to join the space foundation pipes beside it.
      if optional_dependencies.has_krastorio2 then
        for _, connection in pairs(entity.fluid_box.pipe_connections or {}) do
          connection.connection_category = "kr-steel-pipe"
        end
      end
    end
  end

  -- The space foundation variants: deepcopies of the finished foundation
  -- prototypes (so they carry its stats, tint and, under K2, its steel-family
  -- connections), flagged so SE's data-final-fixes leaves them placeable in
  -- space. tier-apply.lua keeps their numbers in step with the foundation tier.
  local variants = {
    { category = "pipe", source = "afi_foundation-pipe", name = "afi_space-foundation-pipe" },
    { category = "pipe-to-ground", source = "afi_foundation-pipe-to-ground", name = "afi_space-foundation-pipe-to-ground" },
  }

  for _, variant in pairs(variants) do
    local source = data.raw[variant.category][variant.source]
    local source_item = data.raw.item[variant.source]
    local source_recipe = data.raw.recipe[variant.source]
    if source and source_item and source_recipe then
      local entity = util.table.deepcopy(source)
      entity.name = variant.name
      entity.minable.result = variant.name
      entity.next_upgrade = nil
      entity.se_allow_in_space = true
      data:extend({ entity })

      local item = util.table.deepcopy(source_item)
      item.name = variant.name
      item.place_result = variant.name
      data:extend({ item })

      local recipe = util.table.deepcopy(source_recipe)
      recipe.name = variant.name
      recipe.enabled = false
      recipe.ingredients = { { type = "item", name = variant.source, amount = 1 } }
      recipe.results = { { type = "item", name = variant.name, amount = 1 } }
      data:extend({ recipe })

      helpers.add_unlock("afi_foundation-pipe-infrastructure", variant.name)
    end
  end
end
