-- Sentence Mixing Effect Addon

-- Define the effect function
function run(state)
  -- Tunable parameters
  -- amount: mixing amount (default: 0.5)
  -- speed: mixing speed (default: 1.0)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1.0

  -- Calculate the mixed color
  local r = state.r
  local g = state.g
  local b = state.b
  if state.tick() * speed > amount then
    r = math.random(0, 255)
    g = math.random(0, 255)
    b = math.random(0, 255)
  end

  -- Return the mixed color
  return {r, g, b}
end
