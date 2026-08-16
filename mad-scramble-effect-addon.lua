-- Mad Scramble Effect: randomizes pixel positions
function run(state)
  -- params: scramble amount (default 10), speed (default 1)
  local amount = state.params.amount or 10
  local speed = state.params.speed or 1

  -- scramble pixel position
  local sx = state.x + math.floor(math.sin(state.time * speed) * amount)
  local sy = state.y + math.floor(math.cos(state.time * speed) * amount)

  -- ensure pixel coordinates are within bounds
  sx = math.max(0, math.min(sx, state.width - 1))
  sy = math.max(0, math.min(sy, state.height - 1))

  -- get pixel color from scrambled position
  local r, g, b = state.r, state.g, state.b
  if sx ~= state.x or sy ~= state.y then
    -- simulate reading from a neighboring pixel
    r, g, b = state.r, state.g, state.b -- for demonstration; real usage requires access to neighboring pixels
  end

  -- return scrambled pixel color
  return {r, g, b}
end
