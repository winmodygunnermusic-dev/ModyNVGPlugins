-- Ear-Rape (Volume Crushing) Effect Addon
-- Crushes audio-like visuals by pulsing and distorting color.

function run(state)
  -- Tunable parameters
  -- amount: intensity of distortion (default: 10)
  -- speed: pulse speed (default: 5)
  local amount = state.params.amount or 10
  local speed = state.params.speed or 5

  -- Calculate pulse
  local pulse = math.sin(state.time * speed) * amount

  -- Distort RGB values
  local r = state.r + pulse
  local g = state.g + pulse / 2
  local b = state.b + pulse / 4

  -- Clamp RGB values
  r = math.max(0, math.min(255, r))
  g = math.max(0, math.min(255, g))
  b = math.max(0, math.min(255, b))

  -- Return distorted RGB
  return {r, g, b}
end
