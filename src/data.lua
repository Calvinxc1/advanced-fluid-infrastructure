-- Publishes the configuration API and builds nothing. Prototypes are built
-- from data-updates.lua so that a mod depending on this one can retune a tier
-- from its own data.lua, in the window between the two stages. See api.lua for
-- the full ordering contract.
require("api")
