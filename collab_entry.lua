-- Collab Entry: general-purpose consistent video/audio finish.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 40)) / 100 end
function Query()
    return { name = "Collab Entry", description = "A balanced finishing preset for collaborative video entries, using only the selected source.", settings = {{ name = "Strength", value = "40", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local con = string.format("%.2f", 1.02 + x * 0.12)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=contrast=" .. con .. ":saturation=1.05,format=yuv420p\" -af \"loudnorm=I=-16:TP=-1.5:LRA=11\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
