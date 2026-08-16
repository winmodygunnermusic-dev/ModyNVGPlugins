function run(state)
  -- params: 
  --   amount (0-1): cut position (default: 0.5)
  local amount = state.params.amount or 0.5

  if state.y < state.height * amount then
    return {r = state.r, g = state.g, b = state.b}
  else
    return {skip = true}
  end
end
