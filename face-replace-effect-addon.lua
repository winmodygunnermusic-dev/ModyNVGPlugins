-- Face-Replace Effect Addon
-- Replaces a face with a playful, oscillating pattern.

function run(state)
  -- Tunable parameters
  -- amount: face detection sensitivity (default: 0.5)
  -- speed: oscillation speed (default: 1.0)
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1.0

  -- Load face detection model (simplified for demonstration purposes)
  -- In a real implementation, use a library like OpenCV or a face detection API
  local faceDetected = (state.x + state.y) % 100 < 50

  if faceDetected then
    -- Oscillating pattern
    local oscillation = math.sin((state.time * speed) + (state.x * 0.01) + (state.y * 0.01))
    local r = math.floor((oscillation + 1) / 2 * 255)
    local g = math.floor((oscillation * 0.5 + 0.5) * 255)
    local b = math.floor((1 - oscillation) / 2 * 255)

    return {r, g, b}
  else
    -- Leave non-face pixels unchanged
    return {skip=true}
  end
end
