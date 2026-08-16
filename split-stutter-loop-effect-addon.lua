function run(state)
  -- params: loop length in frames (default 8), stutter amount (default 0.5)
  local loopLength = state.params.loopLength or 8
  local stutterAmount = state.params.stutterAmount or 0.5

  -- calculate stutter offset
  local stutterOffset = math.floor(state.frame * stutterAmount) % loopLength

  -- check if we're in a stutter
  if stutterOffset < math.floor(loopLength * 0.5) then
    -- return original pixel color
    return {state.r, state.g, state.b}
  else
    -- displace pixel
    local newX = (state.x + stutterOffset) % state.width
    local newY = state.y
    -- sample from source at displaced coordinates
    local r, g, b = state.r, state.g, state.b
    -- implement displacement with pixel wrapping or border handling if needed
    -- here we are just reusing source pixel for demonstration
    return {r, g, b}
  end
end
