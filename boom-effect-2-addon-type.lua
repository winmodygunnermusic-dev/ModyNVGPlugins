function run(state)
  local r, g, b = state.r, state.g, state.b
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1.0
  local seed = state.seed

  -- Simple pixel boom effect
  local boom_t = math.sin(state.time * speed)
  boom_t = (boom_t + 1) / 2 -- Map to 0-1 range

  -- Apply boom effect
  r = r * (1 - amount * boom_t)
  g = g * (1 - amount * boom_t)
  b = b * (1 - amount * boom_t)

  return {r, g, b}
end
