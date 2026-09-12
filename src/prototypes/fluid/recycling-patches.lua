-- Regenerates the recycling recipes for this mod's items.
--
-- Space Age's recycler generates a "<recipe>-recycling" counterpart for every
-- recipe in the load, and it does that from its own data-updates.lua. This mod
-- builds its prototypes from data-updates.lua too -- that is what gives
-- dependent mods a window to configure tiers in, see api.lua -- and the
-- recycler is a base mod, so it always runs first. Its scan therefore happens
-- before this mod's recipes exist, and without this pass every item this mod
-- adds would be silently unrecyclable.
--
-- generate_recycling_recipe is the same entry point recycler/data-updates.lua
-- calls for the base game's own recipes. It handles the "recycling" technology
-- unlock as well as the recipe itself, so calling it here produces exactly what
-- an earlier scan would have.

if not mods["recycler"] then
  return
end

local ok, recycling = pcall(require, "__recycler__.recycling")
if not ok then
  log("AFI: recycler present but its recycling library could not be loaded; " ..
    "this mod's items will not be recyclable")
  return
end

-- Snapshot the names first. generate_recycling_recipe inserts into
-- data.raw.recipe, and mutating a table while iterating it with pairs is
-- undefined in Lua.
local pending = {}
for name in pairs(data.raw.recipe) do
  if string.sub(name, 1, 4) == "afi_" and not data.raw.recipe[name .. "-recycling"] then
    table.insert(pending, name)
  end
end
table.sort(pending)

for _, name in ipairs(pending) do
  recycling.generate_recycling_recipe(data.raw.recipe[name])
end

-- Carry this mod's ingredient substitutions into recycling recipes the
-- recycler generated before those substitutions were made.
--
-- The recycler builds a recycling recipe's results from its source recipe's
-- ingredients. This mod swaps vanilla pipe for its steel tier in several
-- vanilla recipes, but does so from data-updates.lua, by which point those
-- counterparts already exist and still return vanilla pipe. Rewriting the
-- results is enough: the recipes themselves are correct, only the item they
-- name is stale.
local function replace_result(recipe, from, to)
  if not recipe then
    return
  end
  for _, result in pairs(recipe.results or {}) do
    if result.name == from then
      result.name = to
    elseif result[1] == from then
      result[1] = to
    end
  end
end

for _, substitution in ipairs(AdvancedFluidInfrastructure._substitutions or {}) do
  for _, recipe_name in ipairs(substitution.recipes) do
    replace_result(
      data.raw.recipe[recipe_name .. "-recycling"],
      substitution.from,
      substitution.to
    )
  end
end
