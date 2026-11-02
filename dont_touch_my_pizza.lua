-- Don't Touch My Pizza: playful framing and warm color effect.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 50)) / 100 end
function Query()
    return { name = "Don't Touch My Pizza", description = "Adds a warm, punchy color grade and gentle vignette to your source video.", settings = {{ name = "Strength", value = "50", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat = string.format("%.2f", 1 + x * 0.6)
    local vig = string.format("%.3f", 0.15 + x * 0.35)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"colorbalance=rs=0.08:gs=0.02,eq=saturation=" .. sat .. ",vignette=PI*" .. vig .. "\" -af \"acompressor=threshold=0.12:ratio=2\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
