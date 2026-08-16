-- Sex-O-Phone Effect Addon
-- Distorts pixels based on a sine wave to create a psychedelic phone-like effect

function run(state)
  local amount = state.params.amount or 10  -- distortion amount (default: 10)
  local speed = state.params.speed or 1   -- wave speed (default: 1)

  local wave = math.sin((state.time * speed) + (state.x * 0.01))
  local distortion = wave * (amount / 100)

  local new_x = state.x + (distortion * state.width)
  local new_y = state.y

  -- boundary checking
  new_x = math.max(0, math.min(new_x, state.width - 1))
  new_y = math.max(0, math.min(new_y, state.height - 1))

  local src_r, src_g, src_b
  if new_x ~= state.x or new_y ~= state.y then
    -- get pixel at distorted position
    local distorted_state = state
    distorted_state.x = new_x
    distorted_state.y = new_y
    src_r, src_g, src_b = distorted_state.r, distorted_state.g, distorted_state.b
  else
    -- use original pixel if no distortion
    src_r, src_g, src_b = state.r, state.g, state.b
  end

  return {r = src_r, g = src_g, b = src_b}
end
