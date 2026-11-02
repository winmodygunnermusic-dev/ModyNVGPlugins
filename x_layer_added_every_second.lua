-- X with a Layer Added Every Second: simulated accumulating graphic layers.
-- Uses generated shapes, not external media assets.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 50)) / 100 end
function Query()
    return { name = "X with a Layer Added Every Second", description = "Adds a subtle multi-layer outline treatment to the source; layer intensity is adjustable.", settings = {{ name = "Strength", value = "50", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local opacity = string.format("%.2f", 0.08 + x * 0.22)
    local filter = "drawbox=x=2:y=2:w=iw-4:h=ih-4:color=cyan@" .. opacity .. ":t=4,drawbox=x=12:y=12:w=iw-24:h=ih-24:color=magenta@" .. opacity .. ":t=4,drawbox=x=22:y=22:w=iw-44:h=ih-44:color=yellow@" .. opacity .. ":t=4"
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"" .. filter .. "\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
