-- Writes the final tier values over the defaults the prototypes were built
-- with, now that every dependent mod's data.lua has had its chance to
-- configure them. See api.lua.
require("prototypes.fluid.tier-apply")

-- Copies the vanilla offshore pump's final power source onto every tier, now
-- that overhauls this mod loads after (Krastorio 2) have set it, and under K2
-- prices pump power by tier. Reads final speeds, so it follows tier-apply.
require("prototypes.fluid.offshore-power")

-- Reads the steel tier, so it has to follow the pass above. Running here rather
-- than in data.lua also means it reaches production machines added by mods that
-- load after this one.
require("prototypes.fluid.production-machine-patches")

-- Hands this mod's technologies the K2 tech cards their prerequisites carry,
-- after Krastorio 2 Spaced Out has added its cards to Space Age technologies.
if mods["Krastorio2"] then
  require("prototypes.fluid.krastorio2-tech-cards")
end
