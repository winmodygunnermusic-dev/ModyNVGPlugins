-- YTP Source Shuffle: safe alternative to the requested abusive theme.
-- Generates a randomized but mild color/audio treatment of the selected clip.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 35)) / 100 end
function Query()
    return { name = "YTP Source Shuffle", description = "A neutral YTP-style source treatment with randomized hue and gentle audio modulation; no harmful subject matter or bundled media.", settings = {{ name = "Strength", value = "35", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local hue = math.random(-math.floor(25 * x), math.floor(25 * x))
    local sat = string.format("%.2f", 1 + x * 0.4)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"hue=h=" .. hue .. ":s=" .. sat .. ",eq=contrast=1.05\" -af \"tremolo=f=4:d=" .. string.format("%.2f", x * 0.15) .. "\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
