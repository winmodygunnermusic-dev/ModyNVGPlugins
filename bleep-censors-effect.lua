-- Bleep Censors Effect
-- --------------------

-- Pixel "bleep" censor effect, randomly applies a box around pixels
function run(state)
  -- Tunable parameters
  -- amount: 0.0 (none) to 1.0 (all)
  local amount = state.params.amount or 0.5
  -- size: box size (default 5)
  local size = state.params.size or 5

  -- Determine if we should censor this pixel
  if math.random() < amount then
    -- Calculate box coordinates
    local box_x = math.floor(state.x / size) * size
    local box_y = math.floor(state.y / size) * size

    -- If pixel is within a box, censor it
    if box_x <= state.x and state.x < box_x + size and
       box_y <= state.y and state.y < box_y + size then
      -- Randomly pick a color for the censor
      local censor_r = math.random(0, 255)
      local censor_g = math.random(0, 255)
      local censor_b = math.random(0, 255)
      return {censor_r, censor_g, censor_b}
    end
  end

  -- Leave pixel unchanged if not censored
  return {skip=true}
end
