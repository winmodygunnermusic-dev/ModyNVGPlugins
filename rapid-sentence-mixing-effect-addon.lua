-- Rapid Sentence Mixing Effect Addon

-- Define the effect function
function run(state)
  -- Tunable parameters
  -- amount: mix speed (default: 0.1)
  -- seed_offset: random seed offset (default: 0)
  local amount = state.params.amount or 0.1
  local seed_offset = state.params.seed_offset or 0

  -- Calculate a unique random seed for this pixel
  local seed = state.seed + seed_offset + state.x + state.y

  -- Rapidly mix the pixel's color with a random color
  local r, g, b = state.r, state.g, state.b
  local mix_r, mix_g, mix_b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
  local mix_amount = math.random() * amount

  r = math.floor(r * (1 - mix_amount) + mix_r * mix_amount)
  g = math.floor(g * (1 - mix_amount) + mix_g * mix_amount)
  b = math.floor(b * (1 - mix_amount) + mix_b * mix_amount)

  -- Return the mixed color
  return {r, g, b}
end
