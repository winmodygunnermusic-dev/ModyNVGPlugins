function run(state)
  -- params: 
  --   amount (default=1.0): controls the density of the material texture
  local amount = state.params.amount or 1.0
  
  -- Material texture (example: simple grid)
  local gridSize = 20
  local x = math.floor(state.x * gridSize / state.width) % 2
  local y = math.floor(state.y * gridSize / state.height) % 2
  local materialColor = (x + y) % 2 == 0 and 128 or 255
  
  -- Blend with source pixel
  local r = state.r * (1 - amount) + materialColor * amount
  local g = state.g * (1 - amount) + materialColor * amount
  local b = state.b * (1 - amount) + materialColor * amount
  
  return {math.floor(r), math.floor(g), math.floor(b)}
end
