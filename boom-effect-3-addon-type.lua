-- Boom Effect 3: A radial explosion effect
function run(state)
  -- params: 
  --   amount (default: 0.5) - explosion intensity
  --   speed (default: 100) - explosion speed
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 100

  -- distance from center of screen
  local dx = state.x - state.width / 2
  local dy = state.y - state.height / 2
  local dist = math.sqrt(dx * dx + dy * dy)

  -- explosion wave
  local wave = math.max(0, 1 - (dist / (speed * state.time)))

  -- boom color
  local r, g, b = 255, 128, 0  -- orange

  -- lerp color with wave
  local lerpedR, lerpedG, lerpedB = 
    math.floor(r * wave * amount),
    math.floor(g * wave * amount),
    math.floor(b * wave * amount)

  -- return pixel color
  if wave > 0 then
    return {lerpedR, lerpedG, lerpedB}
  else
    return {skip=true}
  end
end
