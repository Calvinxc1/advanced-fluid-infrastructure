local optional_dependencies = require("prototypes.fluid.optional-dependencies")

require("prototypes.fluid.vanilla-patches")
require("prototypes.fluid.production-machine-patches")
require("prototypes.fluid.entities")
require("prototypes.fluid.items")
require("prototypes.fluid.recipes")
require("prototypes.fluid.technologies")

-- Tiers that only exist under Space Age: the space-platform, Vulcanus, and
-- foundation lines. Everything above is the base-game ladder, which tops out
-- at the reinforced tier.
if optional_dependencies.has_space_age then
  require("prototypes.fluid.space-age.entities")
  require("prototypes.fluid.space-age.items")
  require("prototypes.fluid.space-age.recipes")
  require("prototypes.fluid.space-age.technologies")
end

-- Runs last: it places every item this mod owns into its crafting menu row,
-- and the Space Age tiers must already exist by then.
require("prototypes.fluid.menu-layout")

-- Must follow every recipe this mod owns, including the Space Age ones.
require("prototypes.fluid.recycling-patches")
