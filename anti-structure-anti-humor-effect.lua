-- Anti-Structure / Anti-Humor Effect Addon

-- params: 
--   amount (default: 0.5) controls the proportion of pixels to invert
--   speed (default: 1) controls how fast the inversion changes

function run(state)
  local r, g, b = state.r, state.g, state.b
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1

  if state.tick() * speed % 1 < amount then
    -- Invert the pixel color
    r, g, b = 255 - r, 255 - g, 255 - b
  end

  return {r, g, b}
end
