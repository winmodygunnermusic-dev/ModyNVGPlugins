-- Recall Post-Render Effect
-- Uses the "Recall" library.

function run(state)
  -- Check if it's time to recall
  local recallTime = state.params.recallTime or 5 -- Default recall time: 5 seconds
  local clipCount = state.params.clipCount or 20 -- Default clip count: 20
  local delay = state.params.delay or 0 -- Default delay: 0 seconds
  local creationLength = state.params.creationLength or 5 -- Default creation length: 5 seconds

  -- Get current time
  local currentTime = state.time

  -- Check if recall is active
  if currentTime > delay and currentTime < delay + creationLength then
    -- Get source pixel
    local r, g, b = state.r, state.g, state.b

    -- Apply recall effect
    -- NOTE: Since the actual implementation of the "Recall" library is unknown,
    -- we'll assume it provides a function to get the recalled pixel.
    local recalledPixel = recall.getRecalledPixel(state.seed, state.x, state.y, state.frame)
    if recalledPixel then
      r, g, b = recalledPixel.r, recalledPixel.g, recalledPixel.b
    end

    -- Return the recalled pixel
    return {r, g, b}
  else
    -- Return the original pixel
    return {skip=true}
  end
end
