-- Krastorio 2 integration, data-updates half: runs after K2's (and, when
-- present, Space Exploration's) own data-updates, which rewrite base
-- technologies.
--
-- Oil gathering waits on the whole steel tier, as it does without K2. Under
-- K2 one technology, K2's steel fluid handling, unlocks both steel pipe and
-- steel pump, so it is the one prerequisite added.

local optional_dependencies = require("prototypes.fluid.optional-dependencies")

local steel_unlock = optional_dependencies.name("afi_steel-pipe-infrastructure")
local oil_gathering = data.raw.technology["oil-gathering"]

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

if oil_gathering and data.raw.technology[steel_unlock] and not leads_through("oil-gathering", steel_unlock) then
  oil_gathering.prerequisites = oil_gathering.prerequisites or {}
  table.insert(oil_gathering.prerequisites, steel_unlock)
end
