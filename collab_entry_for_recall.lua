-- Collab Entry for Recall: clean, restrained memory-reel grade.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 35)) / 100 end
function Query()
    return { name = "Collab Entry for Recall", description = "A gentle, consistent color grade intended for collaborative tribute or memory-reel entries.", settings = {{ name = "Strength", value = "35", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat = string.format("%.2f", 0.95 + x * 0.3)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=saturation=" .. sat .. ":contrast=1.03,format=yuv420p\" -af \"loudnorm=I=-16:TP=-1.5:LRA=11\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
