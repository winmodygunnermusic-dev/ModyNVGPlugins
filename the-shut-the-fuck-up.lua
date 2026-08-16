function run(state)
  -- params: 
  --   amount (default: 5) - speed multiplier
  --   seed_offset (default: 0) - random seed offset

  local amount = state.params.amount or 5
  local seed_offset = state.params.seed_offset or 0

  local r, g, b = state.r, state.g, state.b
  local frame = state.frame
  local speed = state.tick()

  local sped_up_frame = math.floor(frame * amount)

  -- Add a tiny bit of randomness to prevent banding
  local noise = (math.sin((sped_up_frame + state.seed + seed_offset) * 12.9898) * 43758.5453) % 1
  noise = noise * 2 - 1

  -- Exaggerate the colors
  r = math.min(255, math.max(0, r + noise * 50))
  g = math.min(255, math.max(0, g + noise * 50))
  b = math.min(255, math.max(0, b + noise * 50))

  return {r, g, b}
end
