function run(state)
  -- params: amount (default 0.1), stutter rate (default 10)
  local amount = state.params.amount or 0.1
  local stutterRate = state.params.stutterRate or 10
  
  -- generate stutter effect
  local frameStutter = math.floor(state.frame / stutterRate)
  local pixelStutter = math.floor((state.x + state.y) / stutterRate)
  
  if frameStutter % 2 == 0 and pixelStutter % 2 == 0 then
    -- do nothing
    return nil
  elseif frameStutter % 2 == 0 and pixelStutter % 2 ~= 0 then
    -- displace pixel
    local displaceX = math.sin(state.time * 10) * amount * state.width
    local displaceY = math.cos(state.time * 10) * amount * state.height
    local displacedR, displacedG, displacedB = 
      state.r, state.g, state.b
    -- simulate displacement
    local displacedPX = state.px + displaceX
    local displacedPY = state.py + displaceY
    -- (for this simple example, just return original color)
    return {r=state.r, g=state.g, b=state.b}
  elseif frameStutter % 2 ~= 0 and pixelStutter % 2 == 0 then
    -- temporal displacement
    local temporalDisplace = math.sin(state.time * stutterRate) * amount * 255
    return {r=state.r + temporalDisplace, g=state.g + temporalDisplace, b=state.b + temporalDisplace}
  elseif frameStutter % 2 ~= 0 and pixelStutter % 2 ~= 0 then
    -- return stuttered pixel
    return {r=state.r * 0.5, g=state.g * 0.5, b=state.b * 0.5}
  end
end
