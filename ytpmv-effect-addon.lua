-- NVG workshop metadata and safe parameter helpers.

local function getParam(state, name, defaultValue)
    if state ~= nil and state.params ~= nil and state.params[name] ~= nil then
        return state.params[name]
    end

    return defaultValue
end

function Query(localeName, localizationTokens)
    return {
        ["settings"] = {
            {
                ["name"] = "Display Name",
                ["value"] = "Ytpmv Effect Addon",
                ["type"] = "label"
            },
            {
                ["name"] = "Description",
                ["value"] = "YTP-style NVG pixel effect with safe default parameters.",
                ["type"] = "label"
            },
        {
            ["name"] = "amount",
            ["value"] = 10,
            ["type"] = "number"
        },
        {
            ["name"] = "speed",
            ["value"] = 1,
            ["type"] = "number"
        },
        }
    }
end

-- YTPMV (YouTube Poop-style Moving Video) effect
-- params: 
--   amount (default=10): pixel displacement amount
--   speed (default=1): pixel movement speed

function run(state)
  local amount = getParam(state, "amount", 10)
  local speed = getParam(state, "speed", 1)
  local tick = state.tick()
  local x = state.x
  local y = state.y
  local px = state.px
  local py = state.py
  local r = state.r
  local g = state.g
  local b = state.b

  -- Simple displacement
  local dispx = math.floor(math.sin((x + tick * speed) * 0.01) * amount)
  local dispy = math.floor(math.cos((y + tick * speed) * 0.01) * amount)
  local newx = px + dispx
  local newy = py + dispy

  -- Boundary checking (prevent out of bounds)
  newx = math.max(0, math.min(newx, state.width - 1))
  newy = math.max(0, math.min(newy, state.height - 1))

  -- Get the color from the displaced position
  local s = state.seed
  math.randomseed(s + x + y)
  local sample_r, sample_g, sample_b
  if math.random() < 0.05 then -- 5% chance to introduce a 'glitch'
    sample_r = math.random(0, 255)
    sample_g = math.random(0, 255)
    sample_b = math.random(0, 255)
  else
    sample_r = state.r
    sample_g = state.g
    sample_b = state.b
  end

  -- Return the color
  return {r=sample_r, g=sample_g, b=sample_b}
end
