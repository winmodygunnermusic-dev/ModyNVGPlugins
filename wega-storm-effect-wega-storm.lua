-- Wega Storm Effect
-- A chaotic storm of pixels

function run(state)
  -- Tunable parameters
  -- amount: storm intensity (default: 0.5)
  -- speed: storm speed (default: 100)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 100

  -- Calculate storm offset
  local offset = math.sin(state.time * speed) * 10

  -- Randomize pixel coordinates
  local rand_x = state.seed + state.x * 57 + state.y * 133
  local rand_y = state.seed + state.x * 133 + state.y * 57
  local r_x = math.random(rand_x, rand_x + 100) - 50 + offset
  local r_y = math.random(rand_y, rand_y + 100) - 50

  -- Apply storm effect
  if math.random() < amount then
    local r, g, b = state.r, state.g, state.b
    -- Change color based on storm offset
    r = math.min(255, math.max(0, r + math.sin(state.time * speed + r_x) * 50))
    g = math.min(255, math.max(0, g + math.sin(state.time * speed + r_y) * 50))
    b = math.min(255, math.max(0, b + math.sin(state.time * speed + r_x + r_y) * 50))
    return {r, g, b}
  else
    -- Leave pixel unchanged
    return {skip=true}
  end
end
