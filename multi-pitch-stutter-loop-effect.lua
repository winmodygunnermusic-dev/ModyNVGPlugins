function run(state)
  -- params: 
  --  .speed (float): stutter speed (default: 10.0)
  --  .depth (float): pitch shift amount (default: 2.0)
  local speed = state.params.speed or 10.0
  local depth = state.params.depth or 2.0

  -- stutter phase
  local phase = state.x * 0.01 + state.time * speed

  -- modulate RGB based on stutter phase
  local r = math.sin(phase) * 128 + 128
  local g = math.sin(phase + math.pi * 2 / 3) * 128 + 128
  local b = math.sin(phase + math.pi * 4 / 3) * 128 + 128

  -- apply pitch shift
  r = r * (1 + math.sin(phase * depth) * 0.5)
  g = g * (1 + math.sin(phase * depth + math.pi * 2 / 3) * 0.5)
  b = b * (1 + math.sin(phase * depth + math.pi * 4 / 3) * 0.5)

  -- clamp RGB values
  r = math.min(math.max(r, 0), 255)
  g = math.min(math.max(g, 0), 255)
  b = math.min(math.max(b, 0), 255)

  return {r, g, b}
end
