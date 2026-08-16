function run(state)
  -- params: zoom amount (0.0 - 1.0), zoom center (0.0 - 1.0)
  -- default: zoom = 0.5, centerX = 0.5, centerY = 0.5
  local zoom = state.params.zoom or 0.5
  local centerX = state.params.centerX or 0.5
  local centerY = state.params.centerY or 0.5

  local dx = (state.x / state.width) - centerX
  local dy = (state.y / state.height) - centerY

  local zoomedX = centerX + (dx * (1 - zoom))
  local zoomedY = centerY + (dy * (1 - zoom))

  if zoomedX < 0 or zoomedX >= 1 or zoomedY < 0 or zoomedY >= 1 then
    return {skip=true}
  end

  local zoomedX = math.floor(zoomedX * state.width)
  local zoomedY = math.floor(zoomedY * state.height)

  local r, g, b
  if zoomedX >= 0 and zoomedX < state.width and zoomedY >= 0 and zoomedY < state.height then
    local pixelState = {
      frame = state.frame,
      time = state.time,
      width = state.width,
      height = state.height,
      x = zoomedX,
      y = zoomedY,
      px = zoomedX,
      py = zoomedY,
      params = state.params,
      r = state.r,
      g = state.g,
      b = state.b,
      tick = state.tick,
      seed = state.seed,
    }
    local result = run(pixelState)
    if result then
      r, g, b = result.r, result.g, result.b
    end
  else
    r, g, b = 0, 0, 0
  end

  return {r = r or state.r, g = g or state.g, b = b or state.b}
end
