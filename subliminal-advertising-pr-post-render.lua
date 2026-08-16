-- Subliminal Advertising PR Post-Render Effect
-- Exposes params:
--   amount (default: 0.1) - intensity of the effect
--   speed (default: 10)  - speed of the message change
--   message (default: "Buy Now!") - message to display

function run(state)
  local amount = state.params.amount or 0.1
  local speed = state.params.speed or 10
  local message = state.params.message or "Buy Now!"

  -- Create a font and render the message
  -- Note: NVG does not provide a built-in font system, 
  -- this example is simplified for illustration purposes.

  -- Calculate the position and size of the text
  local textSize = 20
  local textX = state.width / 2 - (#message * textSize / 2)
  local textY = state.height / 2 - textSize / 2

  -- Animate the message
  local frameTime = state.tick()
  local animTime = (state.frame / speed) % 1
  local animChar = math.floor(animTime * #message) + 1
  local animMessage = message:sub(1, animChar)

  -- Draw the text
  if state.x >= textX and state.x < textX + (#animMessage * textSize) and state.y >= textY and state.y < textY + textSize then
    -- Simple text rendering, assumes a fixed-width font
    local charIndex = state.x - textX
    local charCode = animMessage:byte(charIndex / textSize + 1)
    if charCode then
      local r, g, b = 255, 255, 0 -- Yellow
      return {r, g, b, amount}
    end
  end

  -- Leave pixels unchanged if not part of the text
  return {skip=true}
end
