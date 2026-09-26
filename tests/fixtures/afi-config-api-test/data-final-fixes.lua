-- Asserts that configuration made in this fixture's data.lua actually reached
-- the prototypes this mod built a stage later.
local recorded = _G.afi_config_api_test
assert(recorded, "fixture data.lua did not run")

local afi = AdvancedFluidInfrastructure

-- Resolved through the API: under Krastorio 2 the steel tier is K2's own steel
-- line, so its pipe is not called afi_steel-pipe.
local steel_pipe_name = afi.prototype_name("steel", "pipe")
local steel_pipe = data.raw.pipe[steel_pipe_name]
assert(steel_pipe, steel_pipe_name .. " was never built")
assert(steel_pipe.fluid_box.max_pipeline_extent == 120,
  "steel pipeline_extent did not reach the prototype: "
    .. tostring(steel_pipe.fluid_box.max_pipeline_extent))

local steel_offshore_pump = data.raw["offshore-pump"]["afi_steel-offshore-pump"]
assert(steel_offshore_pump.pumping_speed == 7,
  "steel pumping_speed did not reach the prototype: "
    .. tostring(steel_offshore_pump.pumping_speed))

-- The vanilla prototypes this mod patches in place have to follow the
-- configured iron tier too, not just the tiers it creates.
local vanilla_pipe_to_ground = data.raw["pipe-to-ground"]["pipe-to-ground"]
local underground = nil
for _, connection in pairs(vanilla_pipe_to_ground.fluid_box.pipe_connections or {}) do
  if connection.connection_type == "underground" then
    underground = connection.max_underground_distance
  end
end
assert(underground == 6,
  "iron underground_distance did not reach the vanilla pipe-to-ground: " .. tostring(underground))

-- production-machine-patches.lua reads the steel tier to set the fluid-box
-- extent of every production machine in the load, so a retuned steel tier has
-- to carry through to machines this mod does not own.
local assembler = data.raw["assembling-machine"]["assembling-machine-2"]
assert(assembler.fluid_boxes, "assembling-machine-2 has no fluid boxes to check")
for _, fluid_box in pairs(assembler.fluid_boxes) do
  assert(fluid_box.max_pipeline_extent == 120,
    "production machine extent did not follow the configured steel tier: "
      .. tostring(fluid_box.max_pipeline_extent))
end

-- configure_tier merges: fields it was not given must survive untouched, which
-- is what entities.lua depends on when it binds a tier sub-table to a local.
local steel = afi.get_tier("steel")
assert(steel.icon_tint == recorded.steel_icon_tint,
  "configuring a tier replaced the table instead of merging into it")
assert(steel.underground_distance == 8,
  "an unconfigured field on a configured tier was lost: " .. tostring(steel.underground_distance))

-- This mod builds its prototypes a stage later than the recycler scans for
-- recipes to generate recycling counterparts from, so those counterparts are
-- regenerated explicitly. Without that pass every item this mod adds is
-- silently unrecyclable, which a prototype-name diff catches but no in-game
-- error would.
if mods["recycler"] then
  for _, name in ipairs({
    steel_pipe_name, "afi_rubber-lined-pipe-to-ground", "afi_reinforced-pump",
  }) do
    assert(data.raw.recipe[name .. "-recycling"],
      "missing recycling recipe for " .. name)
  end

  -- Vanilla recipes this mod substitutes its steel pipe into must have that
  -- substitution reflected in what recycling them returns. Under Krastorio 2
  -- the substitution is deliberately skipped and K2's recipe stands.
  local pumpjack = not mods["Krastorio2"] and data.raw.recipe["pumpjack-recycling"]
  if pumpjack then
    local returns_vanilla_pipe = false
    for _, result in pairs(pumpjack.results or {}) do
      if result.name == "pipe" or result[1] == "pipe" then
        returns_vanilla_pipe = true
      end
    end
    assert(not returns_vanilla_pipe,
      "pumpjack-recycling still returns vanilla pipe instead of afi_steel-pipe")
  end
end

-- Tooltips repeat the numbers, so they have to follow configuration too. The
-- entity and the item must agree, or the crafting menu and the placed building
-- describe different tiers. The stats line can sit inside a concatenation, as
-- it does beneath Krastorio 2's own text on K2's steel pipe.
local function stats_line(description)
  if type(description) == "table" and description[1] == "" then
    for index = 2, #description do
      local found = stats_line(description[index])
      if found then
        return found
      end
    end
    return nil
  end
  if type(description) == "table" and description[1] == "description.afi_pipeline-extent" then
    return description
  end
  return nil
end

local pipe_description = stats_line(steel_pipe.localised_description)
assert(pipe_description, "steel pipe tooltip has no pipeline extent line")
assert(pipe_description[2] == "120",
  "entity tooltip still shows the default extent: " .. tostring(pipe_description[2]))
local item_description = stats_line(data.raw.item[steel_pipe_name].localised_description)
assert(item_description and item_description[2] == "120",
  "item tooltip did not follow the entity")

local ptg_description = data.raw["pipe-to-ground"]["pipe-to-ground"].localised_description
assert(ptg_description[3] == "6",
  "vanilla pipe-to-ground tooltip did not follow the configured iron tier: "
    .. tostring(ptg_description[3]))

-- The Vulcanus offshore pumps use a different description key from the water
-- ones. Refreshing rewrites the arguments of whatever key is already there, so
-- the variant has to survive untouched.
if mods["space-age"] then
  local lava = data.raw["offshore-pump"]["afi_calcite-lined-offshore-pump"].localised_description
  assert(lava[1] == "description.afi_lava-offshore-pump-fluid-stats",
    "lava offshore pump lost its description variant: " .. tostring(lava[1]))
end
