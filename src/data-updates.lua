-- Writes the final tier values over the defaults the prototypes were built
-- with, now that every dependent mod's data.lua has had its chance to
-- configure them. See api.lua.
require("prototypes.fluid.tier-apply")

-- Reads the steel tier, so it has to follow the pass above. Running here rather
-- than in data.lua also means it reaches production machines added by mods that
-- load after this one.
require("prototypes.fluid.production-machine-patches")
