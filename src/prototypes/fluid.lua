local optional_dependencies = require("prototypes.fluid.optional-dependencies")

require("prototypes.fluid.vanilla-patches")
require("prototypes.fluid.entities")
require("prototypes.fluid.items")
require("prototypes.fluid.recipes")
require("prototypes.fluid.technologies")

-- Tiers that only exist under Space Age: the space-platform and Vulcanus
-- lines. Everything above is the base-game ladder, which tops out at the
-- reinforced tier.
if optional_dependencies.has_space_age then
  require("prototypes.fluid.space-age.entities")
  require("prototypes.fluid.space-age.items")
  require("prototypes.fluid.space-age.recipes")
  require("prototypes.fluid.space-age.technologies")
end

-- The foundation and high-pressure foundation tiers, for loads with a late
-- game to put them in. Space Age supplies their recipes and technologies
-- above; Krastorio 2 without Space Age supplies its own.
if optional_dependencies.has_space_age or optional_dependencies.has_krastorio2 then
  require("prototypes.fluid.foundation.entities")
  require("prototypes.fluid.foundation.items")
end
if optional_dependencies.has_krastorio2 and not optional_dependencies.has_space_age then
  require("prototypes.fluid.krastorio2-foundation")
end

-- Needs every tier to exist, and has to land before the menu layout places
-- items by name.
if optional_dependencies.has_krastorio2 then
  require("prototypes.fluid.krastorio2")
end

-- After the K2 pass, whose steel family and foundation technologies it builds on.
if optional_dependencies.has_space_exploration then
  require("prototypes.fluid.space-exploration")
end

-- Runs last: it places every item this mod owns into its crafting menu row,
-- and the Space Age tiers must already exist by then.
require("prototypes.fluid.menu-layout")
