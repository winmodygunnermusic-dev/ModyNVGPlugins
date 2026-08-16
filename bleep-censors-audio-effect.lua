-- Bleep Censors Audio Effect (visual representation)
-- Replaces pixels with a "bleep" effect when audio would be censored

function run(state)
  -- params: 
  --   amount (0-100): intensity of bleep effect (default: 50)
  --   speed (1-100): speed of bleep effect (default: 10)
  local amount = state.params.amount or 50
  local speed = state.params.speed or 10

  -- Simple noise function for bleep effect
  local function noise(x, y, t)
    return (math.sin((x + y + t) * speed) * amount) / 100
  end

  -- Apply bleep effect
  local t = state.tick()
  local n = noise(state.x, state.y, t)
  if n > 0.5 then
    -- Bleep pixel
    return {255, 255, 255}
  else
    -- Leave pixel unchanged
    return {skip=true}
  end
end
