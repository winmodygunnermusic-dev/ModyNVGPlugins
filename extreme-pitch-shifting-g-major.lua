-- Strobe & Shake Effect Addon

-- Tunable parameters
-- amount: strobe intensity (default: 0.5)
-- speed: shake speed (default: 10)

function run(state)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 10

  -- strobe
  local strobe = math.sin(state.time * speed) > 0
  if not strobe then
    return {skip=true}
  end

  -- shake
  local shake_x = math.floor(math.sin(state.time * speed * 1.1) * 5)
  local shake_y = math.floor(math.cos(state.time * speed * 1.1) * 5)
  local r, g, b = state.r, state.g, state.b

  -- apply shake
  local px, py = state.px + shake_x, state.py + shake_y
  if px >= 0 and px < state.width and py >= 0 and py < state.height then
    r, g, b = state.r, state.g, state.b
  else
    -- if pixel is out of bounds, return black
    r, g, b = 0, 0, 0
  end

  -- apply strobe intensity
  r, g, b = math.floor(r * amount), math.floor(g * amount), math.floor(b * amount)

  return {r, g, b}
end
