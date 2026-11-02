-- Slurmcore: neon sci-fi color and echo treatment.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 60)) / 100 end
function Query()
    return { name = "Slurmcore", description = "Applies a neon, synthetic sci-fi grade and gentle echo to your source clip.", settings = {{ name = "Strength", value = "60", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat, con = string.format("%.2f", 1.2 + x * 0.8), string.format("%.2f", 1.05 + x * 0.25)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"hue=h=25:s=" .. sat .. ",eq=contrast=" .. con .. ",curves=preset=strong_contrast\" -af \"aecho=0.8:0.6:120:0.2\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
