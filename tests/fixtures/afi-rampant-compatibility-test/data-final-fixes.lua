local removed_pipes = {
  "reinforced-pipe-rampant-arsenal",
  "reinforced-pipe-to-ground-rampant-arsenal",
}
local removed_recipes = {
  "reinforced-pipe-rampant-arsenal",
  "reinforced-pipe-to-ground-rampant-arsenal",
  "rampant-arsenal-recycling-positional-ingredient",
  "rampant-arsenal-recycling-keyed-result",
  "rampant-arsenal-recycling-single-result",
}

for _, name in pairs(removed_pipes) do
  assert(not data.raw.pipe[name], name .. " pipe prototype was not removed")
  assert(not data.raw["pipe-to-ground"][name], name .. " pipe-to-ground prototype was not removed")
  assert(not data.raw.item[name], name .. " item prototype was not removed")
end

for _, name in pairs(removed_recipes) do
  assert(not data.raw.recipe[name], name .. " recipe was not removed")
end

assert(
  not data.raw.technology["rampant-arsenal-technology-reinforced-pipes"],
  "Rampant Arsenal reinforced pipe technology was not removed"
)

for _, effect in pairs(data.raw.technology["rampant-arsenal-recycling-technology"].effects) do
  assert(effect.type ~= "unlock-recipe", "removed recipe unlock was not removed")
end
