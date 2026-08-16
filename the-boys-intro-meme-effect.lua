-- The Boys Intro Meme Effect
-- Overlay 'The Boys' intro greenscreen video on a random video,
-- pausing the base video at 8.8s for the remainder.

-- Tunable parameters
--   pause_time: time to pause the base video (default: 8.8)

local function getParam(state, name, defaultValue)
  if state ~= nil and state.params ~= nil and state.params[name] ~= nil then
    return state.params[name]
  end

  return defaultValue
end

function run(state)
  local pauseTime = getParam(state, "pause_time", 8.8)

  -- Check if it's time to pause the base video. Keep the original pixel if
  -- the optional TheBoys library is not available instead of failing to load
  -- or crashing at render time.
  if state.time > pauseTime and state.TheBoys ~= nil and state.TheBoys.get_pixel ~= nil then
    local r, g, b = state.TheBoys.get_pixel(state)
    return {r, g, b}
  end

  return {skip=true}
end
