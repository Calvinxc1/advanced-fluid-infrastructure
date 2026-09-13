-- Publishes the configuration API, then builds every prototype this mod owns
-- with the default tier values.
--
-- Creation happens here, at the ordinary stage, so that passes which scan
-- data.raw during data-updates see these prototypes -- Space Age's recycler
-- above all, which generates a recycling recipe for every recipe present when
-- it runs.
--
-- A dependent mod cannot configure a tier until its own data.lua, which is
-- after this one, so configuration is applied a stage later by
-- prototypes/fluid/tier-apply.lua. See api.lua for the full contract.
require("api")
require("prototypes.fluid")
