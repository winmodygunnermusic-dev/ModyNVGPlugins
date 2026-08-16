function run(state)
  -- params: amount (default 0.5), speed (default 1.0)
  -- amount: mix intensity (0 = no mix, 1 = full mix)
  -- speed: mix speed (higher = faster mix)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1.0

  -- get source and destination pixel colors
  local r1, g1, b1 = state.r, state.g, state.b
  local r2, g2, b2 = state.seed % 256, (state.seed * 13) % 256, (state.seed * 37) % 256

  -- calculate mix factor
  local t = math.sin((state.time * speed) + state.seed) * 0.5 + 0.5
  t = t * amount

  -- mix pixel colors
  local r = math.floor(r1 * (1 - t) + r2 * t)
  local g = math.floor(g1 * (1 - t) + g2 * t)
  local b = math.floor(b1 * (1 - t) + b2 * t)

  return {r, g, b}
end
