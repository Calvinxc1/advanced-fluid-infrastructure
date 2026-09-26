-- Space Exploration integration, data-updates half: runs after SE's own
-- data-updates, where SE adds its Krastorio 2 compatibility technologies.
--
-- SE's long space pipes are storage tanks rather than pipes, so tier-apply.lua
-- does not reach them. They are pipe segments of the space branch and take its
-- final pipeline extent here, after tier-apply has applied any configuration,
-- with the matching stats line beneath SE's own description.

local constants = require("prototypes.fluid.constants")
local helpers = require("prototypes.fluid.helpers")

local extent = constants.low_pressure_steel.pipeline_extent

for name, tank in pairs(data.raw["storage-tank"]) do
  if string.sub(name, 1, 18) == "se-space-pipe-long" then
    helpers.set_fluid_box_extent(tank.fluid_box, extent)
    if tank.localised_description then
      tank.localised_description = { "", tank.localised_description, "\n", helpers.pipe_description(extent) }
    end
  end
end

-- Technologies whose recipes SE's tree no longer guarantees the inputs for.
local function leads_through(technology_name, target, seen)
  if technology_name == target then
    return true
  end
  seen = seen or {}
  if seen[technology_name] then
    return false
  end
  seen[technology_name] = true
  local technology = data.raw.technology[technology_name]
  for _, prerequisite in pairs(technology and technology.prerequisites or {}) do
    if leads_through(prerequisite, target, seen) then
      return true
    end
  end
  return false
end

local function require_first(technology_name, prerequisite_name)
  local technology = data.raw.technology[technology_name]
  if technology and data.raw.technology[prerequisite_name]
      and not leads_through(technology_name, prerequisite_name) then
    technology.prerequisites = technology.prerequisites or {}
    table.insert(technology.prerequisites, prerequisite_name)
  end
end

-- The steel offshore pump needs engine units; SE places Engine beside K2's
-- steel fluid handling rather than before it.
require_first("kr-steel-fluid-handling", "engine")
-- SE moves the charged matter stabilizer to its own advanced matter processing
-- (created in SE's data-updates), which K2's singularity card does not lead
-- through.
require_first("afi_high-pressure-foundation-pumping", "se-kr-advanced-matter-processing")
