-- Random Cuts Effect
-- Generates a video with randomly cut frames.

function run(state)
  -- params: 
  --   amount (default: 0.5) - proportion of pixels to cut
  --   speed (default: 10) - speed of cutting (higher = faster)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 10

  -- Calculate probability of cutting a pixel
  local prob = amount * (state.tick() * speed)

  -- Randomly decide if pixel should be cut
  if math.random() < prob then
    -- Cut pixel: return black
    return {r = 0, g = 0, b = 0}
  else
    -- Don't cut pixel: return original color
    return {r = state.r, g = state.g, b = state.b}
  end
end
