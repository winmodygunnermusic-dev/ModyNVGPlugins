-- The Boys Intro Meme Effect
-- Overlay 'The Boys' intro greenscreen video on a random video,
-- pausing the base video at 8.8s for the remainder.

-- Tunable parameters
--   pause_time: time to pause the base video (default: 8.8)
local function run(state)
  -- Check if it's time to pause the base video
  if state.time > state.params.pause_time then
    -- Return the 'The Boys' intro video pixel
    -- Assuming TheBoys library is accessible via state.TheBoys
    -- and has a function to get the current pixel color
    local r, g, b = state.TheBoys.get_pixel(state)
    return {r, g, b}
  else
    -- Keep the original pixel if not paused
    return {skip=true}
  end
end

-- Define default parameters
state.params = state.params or {}
state.params.pause_time = state.params.pause_time or 8.8
