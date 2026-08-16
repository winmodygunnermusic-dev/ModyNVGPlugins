function run(state)
  -- Settings
  local minDelay = state.params.minDelay or 0.1
  local maxDelay = state.params.maxDelay or 0.75
  local minSFXCount = state.params.minSFXCount or 5
  local maxSFXCount = state.params.maxSFXCount or 10
  local useSpadinnerLibrary = state.params.useSpadinnerLibrary or 1

  -- Simple color shift for demonstration
  local r, g, b = state.r, state.g, state.b
  if state.tick() < minDelay then
    r = math.sin(state.time * 2) * 128 + 128
    g = math.sin(state.time * 3) * 128 + 128
    b = math.sin(state.time * 4) * 128 + 128
  end

  return {r, g, b}
end
