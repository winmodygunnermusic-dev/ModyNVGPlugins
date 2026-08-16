-- Sudden Visual Cuts & Flash Frames Addon

-- Effect: Randomly flash a pixel to a random color
function run(state)
  -- params: 
  --   amount (0-1): chance of flashing (default: 0.1)
  --   speed (1-100): flash frequency (default: 10)
  local amount = state.params.amount or 0.1
  local speed = state.params.speed or 10

  -- Randomly flash pixel
  if math.random() < amount * (1 / (speed * state.tick() / 100)) then
    -- Generate random color
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)
    return {r, g, b}
  end
  -- Leave pixel unchanged
  return {skip=true}
end
