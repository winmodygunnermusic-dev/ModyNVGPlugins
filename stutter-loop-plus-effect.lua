-- Stutter Loop Plus Effect
-- A stuttering loop effect with an additional "plus" offset.

function run(state)
  -- params: 
  --   amount (default=10): number of stutter steps
  --   speed (default=5): speed of stutter
  --   offset (default=0.5): plus offset
  local amount = state.params.amount or 10
  local speed = state.params.speed or 5
  local offset = state.params.offset or 0.5

  -- calculate stutter index
  local stutter_idx = math.floor(state.time * speed) % amount

  -- add plus offset
  local final_idx = (stutter_idx + math.floor(state.x * offset)) % amount

  -- map stutter index to color
  local r = math.sin(final_idx / amount * math.pi * 2) * 128 + 128
  local g = math.sin((final_idx + amount / 3) / amount * math.pi * 2) * 128 + 128
  local b = math.sin((final_idx + 2 * amount / 3) / amount * math.pi * 2) * 128 + 128

  return {r, g, b}
end
