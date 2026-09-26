-- Resolves everything that differs between a Space Age load and a base-game
-- load. The presence flag is computed once here, and prototype files consume
-- the resolvers below rather than branching on `mods` themselves, so this file
-- is the single auditable answer to "what changes without Space Age?".
--
-- Whole tiers that only exist under Space Age are not handled here; they live
-- in prototypes/fluid/space-age/ and are required conditionally from
-- prototypes/fluid.lua.

local optional_dependencies = {}

optional_dependencies.has_space_age = mods["space-age"] ~= nil
optional_dependencies.has_krastorio2 = mods["Krastorio2"] ~= nil
optional_dependencies.has_space_exploration = mods["space-exploration"] ~= nil

-- SE's space pipes become the space branch only when the foundation tier
-- exists above them to upgrade into. SE excludes Space Age, so under SE that
-- means Krastorio 2 is present; SE on its own keeps its space pipes as they are.
optional_dependencies.has_space_branch =
  optional_dependencies.has_space_exploration and optional_dependencies.has_krastorio2

-- Krastorio 2 ships its own steel pipe, pipe to ground and pump, and its own
-- recipes consume them. Under K2 those prototypes are this mod's steel tier:
-- they carry the steel tier's numbers, and everything that would have named
-- this mod's steel prototype names K2's instead. The steel offshore pump has no
-- K2 counterpart and stays. See prototypes/fluid/krastorio2.lua.
local KRASTORIO2_STEEL_TIER = {
  ["afi_steel-pipe"] = "kr-steel-pipe",
  ["afi_steel-pipe-to-ground"] = "kr-steel-pipe-to-ground",
  ["afi_steel-pump"] = "kr-steel-pump",
  ["afi_steel-pipe-infrastructure"] = "kr-steel-fluid-handling",
  ["afi_steel-pump-infrastructure"] = "kr-steel-fluid-handling",
}

-- Space Exploration's space pipes are this mod's space branch: the role Space
-- Age's platform-only low-pressure steel tier plays, which SE (being
-- incompatible with Space Age) never builds. They carry that tier's numbers.
-- Unlike the K2 steel line these are not duplicates of anything this mod
-- builds, so they are not substitutions() and nothing is removed.
-- See prototypes/fluid/space-exploration.lua.
local SPACE_EXPLORATION_SPACE_BRANCH = {
  ["afi_low-pressure-steel-pipe"] = "se-space-pipe",
  ["afi_low-pressure-steel-pipe-to-ground"] = "se-space-pipe-to-ground",
}

-- The prototype that fills a role in this load. Names without a substitute
-- come back unchanged.
function optional_dependencies.name(name)
  if optional_dependencies.has_krastorio2 and KRASTORIO2_STEEL_TIER[name] then
    return KRASTORIO2_STEEL_TIER[name]
  end
  if optional_dependencies.has_space_branch and SPACE_EXPLORATION_SPACE_BRANCH[name] then
    return SPACE_EXPLORATION_SPACE_BRANCH[name]
  end
  return name
end

-- Every substitution active in this load, as { ours = theirs }.
function optional_dependencies.substitutions()
  if optional_dependencies.has_krastorio2 then
    return KRASTORIO2_STEEL_TIER
  end
  return {}
end

local function ingredient(type, name, amount)
  return { type = type, name = name, amount = amount }
end

function optional_dependencies.item(name, amount)
  return { ingredient("item", name, amount) }
end

function optional_dependencies.fluid(name, amount)
  return { ingredient("fluid", name, amount) }
end

local function add_ingredient(result, indexes, source)
  local key = source.type .. ":" .. source.name
  local existing = indexes[key]
  if existing then
    existing.amount = existing.amount + source.amount
    return
  end

  local copy = util.table.deepcopy(source)
  indexes[key] = copy
  table.insert(result, copy)
end

-- Flattens any number of ingredient groups into one list, merging duplicate
-- entries by summing their amounts. A recipe may not list the same item twice,
-- so merging is a correctness requirement rather than tidiness.
function optional_dependencies.ingredients(...)
  local result = {}
  local indexes = {}

  for _, group in ipairs({ ... }) do
    for _, source in ipairs(group) do
      add_ingredient(result, indexes, source)
    end
  end

  return result
end

-- The pair of materials that turn a rubber-lined component into a reinforced
-- one. Space Age uses its own composites; the base game substitutes refined
-- concrete and low-density structure at the same quantities.
function optional_dependencies.reinforcement_ingredients(amount)
  if optional_dependencies.has_space_age then
    return {
      ingredient("item", "tungsten-plate", amount),
      ingredient("item", "carbon-fiber", amount),
    }
  end

  return {
    ingredient("item", "refined-concrete", amount),
    ingredient("item", "low-density-structure", amount),
  }
end

-- Picks between a Space Age value and a base-game value. Used for technology
-- prerequisite lists and research units, which differ in gating rather than in
-- shape.
function optional_dependencies.select(space_age, fallback)
  if optional_dependencies.has_space_age then
    return space_age
  end

  return fallback
end

return optional_dependencies
