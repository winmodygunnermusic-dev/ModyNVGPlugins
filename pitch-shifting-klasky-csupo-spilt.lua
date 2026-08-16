function run(state)
  -- Pitch shifting / Klasky Csupo Spilt effect
  -- params: 
  --   amount (default: 0.1) - intensity of the effect
  --   speed (default: 10) - speed of the effect

  local amount = state.params.amount or 0.1
  local speed = state.params.speed or 10

  local r, g, b = state.r, state.g, state.b
  local t = state.time * speed
  local p = math.sin(t) * amount

  -- shift red and blue channels
  local r_shifted = math.floor(r * (1 + p))
  local b_shifted = math.floor(b * (1 - p))

  -- clamp values
  r_shifted = math.max(0, math.min(r_shifted, 255))
  b_shifted = math.max(0, math.min(b_shifted, 255))

  return {r_shifted, g, b_shifted}
end
