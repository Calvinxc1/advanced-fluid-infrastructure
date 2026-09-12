-- Stands in for a dependent mod retuning tiers. Runs after this mod's data.lua
-- published the API and before its data-updates.lua builds anything, which is
-- the whole window the API exists to open.
local afi = require("__advanced-fluid-infrastructure__.api")

assert(afi == AdvancedFluidInfrastructure,
  "require and the global must resolve to the same table")
assert(afi.version == 1, "unexpected API version " .. tostring(afi.version))

-- Recorded before the change so data-final-fixes can prove a merge happened
-- rather than a replacement.
_G.afi_config_api_test = {
  steel_icon_tint = afi.get_tier("steel").icon_tint,
}

assert(afi.configure_tier("steel", { pipeline_extent = 120, pumping_speed = 7 }),
  "configuring steel should have applied every field")
assert(afi.configure_tier("iron", { underground_distance = 6 }, "afi-config-api-test"),
  "configuring iron should have applied every field")

-- Rejections. Each returns false and leaves the table untouched, rather than
-- appearing to work.
assert(not afi.configure_tier("no-such-tier", { pumping_speed = 1 }),
  "an unknown tier should be rejected")
assert(not afi.configure_tier("steel", { max_health = 500 }),
  "an unknown field should be rejected")
assert(not afi.configure_tier("steel", { pumping_speed = "fast" }),
  "a wrongly typed value should be rejected")
assert(not afi.configure_tier("steel", "not a table"),
  "a non-table change set should be rejected")
-- high_pressure_foundation builds pumps only, so it carries no
-- underground_distance and nothing would ever read one.
assert(not afi.configure_tier("high_pressure_foundation", { underground_distance = 30 }),
  "a field the tier does not carry should be rejected")
assert(afi.get_tier("high_pressure_foundation").underground_distance == nil,
  "a field the tier does not carry must not be written")

assert(afi.get_tier("steel").max_health == nil,
  "a rejected field must not be written to the tier")
assert(afi.get_tier("steel").pumping_speed == 7,
  "a rejected call must not disturb an earlier accepted value")

local names = afi.tier_names()
assert(#names > 0, "tier_names returned nothing")
