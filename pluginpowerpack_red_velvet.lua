-- PluginPowerPack / Red Velvet: rich red color treatment.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 55)) / 100 end
function Query()
    return { name = "PluginPowerPack - Red Velvet", description = "A compact red-toned color preset for source footage; no third-party media is included.", settings = {{ name = "Strength", value = "55", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local red, sat = string.format("%.2f", x * 0.22), string.format("%.2f", 1 + x * 0.45)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"colorbalance=rs=" .. red .. ":bs=-0.08,eq=saturation=" .. sat .. ":contrast=1.08\" -af \"acompressor=threshold=0.15:ratio=2\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
