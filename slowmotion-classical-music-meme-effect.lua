-- Slowmotion Classical Music Meme Effect

-- params: speed (default: 0.5), volume (default: 1.0)
--          seed (ignored, for debugging)

function run(state)
  -- Choose a random speed if not set
  local speed = state.params.speed or 0.5
  if state.frame == 0 then
    state.seed = state.seed or math.random(9999)
  end

  -- Slow down the video
  local slowmo_factor = speed
  local new_r, new_g, new_b
  if state.tick() < 1 / 60 / slowmo_factor then
    -- Duplicate frame to simulate slow motion
    new_r, new_g, new_b = state.r, state.g, state.b
  else
    -- Interpolate between frames to simulate slow motion
    local prev_frame_data = state.prev_frame_data
    if prev_frame_data then
      local t = (state.tick() * 60 * slowmo_factor) % 1
      new_r = math.floor(state.r * t + prev_frame_data.r * (1 - t))
      new_g = math.floor(state.g * t + prev_frame_data.g * (1 - t))
      new_b = math.floor(state.b * t + prev_frame_data.b * (1 - t))
    else
      new_r, new_g, new_b = state.r, state.g, state.b
    end
  end

  -- Store current frame data for interpolation
  state.prev_frame_data = {r = state.r, g = state.g, b = state.b}

  -- Play classical music (implementation depends on NVG's audio handling)
  -- For demonstration purposes, assume classical music audio is handled elsewhere
  -- local volume = state.params.volume or 1.0
  -- play_classical_music(volume)

  return {r = new_r, g = new_g, b = new_b}
end
