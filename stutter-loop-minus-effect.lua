-- Stutter Loop Minus Effect
-- Creates a stuttering loop effect where pixels are subtracted from the source
-- in a loop that appears to move backwards.

function run(state)
  -- Tunable parameters
  -- amount: controls the intensity of the subtraction (default: 50)
  -- speed: controls the speed of the loop (default: 10)
  local amount = state.params.amount or 50
  local speed = state.params.speed or 10

  -- Calculate the loop offset
  local loopOffset = math.floor(state.time * speed) % state.width

  -- Calculate the distance from the loop offset
  local dist = (state.x - loopOffset + state.width) % state.width

  -- If the distance is within the amount, subtract from the source pixel
  if dist < amount then
    return {
      r = state.r - (state.r * (dist / amount)),
      g = state.g - (state.g * (dist / amount)),
      b = state.b - (state.b * (dist / amount)),
    }
  else
    -- Otherwise, return the original pixel
    return {skip=true}
  end
end
