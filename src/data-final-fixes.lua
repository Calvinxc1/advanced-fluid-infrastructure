if mods["RampantArsenalFork"] then
  local rampant_reinforced_pipes = {
    ["reinforced-pipe-rampant-arsenal"] = true,
    ["reinforced-pipe-to-ground-rampant-arsenal"] = true,
  }
  local removed_recipes = {}

  local function ingredient_or_result_references_removed_pipe(entry)
    return entry and (rampant_reinforced_pipes[entry.name] or rampant_reinforced_pipes[entry[1]])
  end

  local function recipe_references_removed_pipe(recipe)
    for _, ingredient in pairs(recipe.ingredients or {}) do
      if ingredient_or_result_references_removed_pipe(ingredient) then
        return true
      end
    end
    for _, result in pairs(recipe.results or {}) do
      if ingredient_or_result_references_removed_pipe(result) then
        return true
      end
    end
    return recipe.result and rampant_reinforced_pipes[recipe.result]
  end

  local function remove_recipe(name)
    removed_recipes[name] = true
    if data.raw.recipe then
      data.raw.recipe[name] = nil
    end
  end

  for name in pairs(rampant_reinforced_pipes) do
    if data.raw.pipe then
      data.raw.pipe[name] = nil
    end
    if data.raw["pipe-to-ground"] then
      data.raw["pipe-to-ground"][name] = nil
    end
    if data.raw.item then
      data.raw.item[name] = nil
    end
    remove_recipe(name)

    -- The recycler feature auto-generates a "<name>-recycling" recipe (and a
    -- matching unlock-recipe effect on the vanilla "recycling" technology)
    -- for craftable items, including these removed pipes. That generation
    -- reacts to items/recipes appearing but does not reliably retract the
    -- technology's unlock-recipe effect once the source item disappears
    -- again later in the data stage, so it has to be removed explicitly
    -- here rather than relying on the generic ingredient/result scan below
    -- to always still see it.
    remove_recipe(name .. "-recycling")
  end

  local recipes_to_remove = {}
  for name, recipe in pairs(data.raw.recipe or {}) do
    if recipe_references_removed_pipe(recipe) then
      recipes_to_remove[name] = true
    end
  end
  for name in pairs(recipes_to_remove) do
    remove_recipe(name)
  end

  for _, technology in pairs(data.raw.technology or {}) do
    local effects = technology.effects
    if effects then
      for index = #effects, 1, -1 do
        local effect = effects[index]
        if effect.type == "unlock-recipe" and removed_recipes[effect.recipe] then
          table.remove(effects, index)
        end
      end
    end
  end

  if data.raw.technology then
    data.raw.technology["rampant-arsenal-technology-reinforced-pipes"] = nil
  end
end

-- RampantFixed's demolisher scales branch adds a non-freezing fluid line by
-- deepcopying the vanilla pipe, pipe-to-ground, and pump. This mod patches
-- those same vanilla prototypes in vanilla-patches.lua, so depending on which
-- mod wins the load order those copies can inherit our changes wholesale.
--
-- info.json declares `? RampantFixed`, which pins RampantFixed ahead of us and
-- means the copies are normally taken from clean vanilla. This block runs after
-- both mods regardless, so it asserts the intended result either way rather
-- than relying on the ordering alone.
--
-- Their prototypes exist only when the startup setting below is enabled, so an
-- absent prototype here means the player turned the branch off.
if mods["RampantFixed"] then
  local scales_content = settings.startup["rampantFixed--spaceAge-AddDemolisherScalesContent"]
  if not scales_content or scales_content.value then
    local iron_extent = require("prototypes.fluid.constants").iron.pipeline_extent

    local function untangle(category, name, extent)
      local prototype = data.raw[category] and data.raw[category][name]
      if not prototype then
        return
      end

      -- Never route a freeze-immune pipe into our tiers: every one of them
      -- freezes, so an upgrade planner would silently downgrade an Aquilo
      -- network's defining property.
      prototype.next_upgrade = nil

      -- Their line carries no surface restrictions of its own. Ours are a
      -- statement about our tiers, not about theirs.
      prototype.surface_conditions = nil

      -- Without this mod their pipes are ordinary vanilla pipes, so iron-tier
      -- throughput preserves the standing their author designed for. Set
      -- explicitly so it does not depend on who loaded first.
      if extent and prototype.fluid_box then
        prototype.fluid_box.max_pipeline_extent = extent
      end
    end

    untangle("pipe", "non-freezing-pipe-rampant", iron_extent)
    untangle("pipe-to-ground", "non-freezing-pipe-to-ground-rampant", iron_extent)
    -- Pumps are pipeline segment boundaries, so this mod never sets pump
    -- extent; leave theirs alone too.
    untangle("pump", "non-freezing-pump-rampant", nil)
  end
end
