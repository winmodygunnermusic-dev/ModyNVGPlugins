math.randomseed(12345)

function run(state)
  -- params: 
  --   amount (default=0.5): transition blend amount
  --   speed (default=1.0): transition speed
  --   size (default=0.2): transition overlay size
  local amount = state.params.amount or 0.5
  local speed = state.params.speed or 1.0
  local size = state.params.size or 0.2

  -- random seed for per-effect stability
  local seed = state.seed

  -- overlay center
  math.randomseed(seed)
  local ox = math.floor(state.width * (math.random() % 1))
  local oy = math.floor(state.height * (math.random() % 1))

  -- distance from overlay center
  local dx = state.x - ox
  local dy = state.y - oy
  local dist = math.sqrt(dx * dx + dy * dy)

  -- blend
  local t = (dist / (state.width * size)) 
  t = math.max(0, math.min(1, t))

  -- handle edge cases
  if t > 1 then 
    return {skip=true}
  end

  -- interpolate
  local r, g, b = state.r, state.g, state.b
  if t < amount then 
    -- transition from source
    local nr, ng, nb = state.r, state.g, state.b
    r = math.floor(nr * (1 - t / amount) + r * (t / amount))
    g = math.floor(ng * (1 - t / amount) + g * (t / amount))
    b = math.floor(nb * (1 - t / amount) + b * (t / amount))
  else 
    -- transition to target
    local tr, tg, tb = 255 - state.r, 255 - state.g, 255 - state.b
    r = math.floor(r * (1 - (t - amount) / (1 - amount)) + tr * ((t - amount) / (1 - amount)))
    g = math.floor(g * (1 - (t - amount) / (1 - amount)) + tg * ((t - amount) / (1 - amount)))
    b = math.floor(b * (1 - (t - amount) / (1 - amount)) + tb * ((t - amount) / (1 - amount)))
  end

  return {r, g, b}
end
