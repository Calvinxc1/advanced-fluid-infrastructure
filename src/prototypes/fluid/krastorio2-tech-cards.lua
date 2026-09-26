-- Krastorio 2 tech cards for this mod's technologies.
--
-- Krastorio 2 Spaced Out adds K2's tech cards to Space Age technologies (the
-- advanced card to foundation; the advanced, matter and singularity cards to
-- promethium science), so a technology of ours that follows one of them would
-- otherwise be cheaper to research than the technology it builds on. Each of
-- this mod's technologies takes the K2 cards its prerequisites carry, repeated
-- until nothing changes so the cards pass along this mod's own chains too.
--
-- Where K2 adds no cards to a prerequisite (Krastorio 2 with or without Space
-- Age) this changes nothing. Runs in data-updates, after Spaced Out has added
-- its cards there. The basic tech card is left alone: Spaced Out removes it
-- everywhere, and K2 places it itself.

local function is_carried_card(name)
  return name ~= "kr-basic-tech-card" and string.match(name, "^kr%-.+%-tech%-card$") ~= nil
end

local function ingredient_name(ingredient)
  return ingredient.name or ingredient[1]
end

local function cards(technology)
  local found = {}
  for _, ingredient in pairs(technology.unit and technology.unit.ingredients or {}) do
    local name = ingredient_name(ingredient)
    if is_carried_card(name) then
      found[name] = true
    end
  end
  return found
end

local changed = true
while changed do
  changed = false
  for name, technology in pairs(data.raw.technology) do
    if string.sub(name, 1, 4) == "afi_" and technology.unit then
      local have = cards(technology)
      for _, prerequisite_name in pairs(technology.prerequisites or {}) do
        local prerequisite = data.raw.technology[prerequisite_name]
        for card in pairs(prerequisite and cards(prerequisite) or {}) do
          if not have[card] then
            have[card] = true
            table.insert(technology.unit.ingredients, { card, 1 })
            changed = true
          end
        end
      end
    end
  end
end
