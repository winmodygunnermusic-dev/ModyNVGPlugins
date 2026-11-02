-- Unexpected John Cena: brief, low-intensity impact-style grade.
-- No celebrity footage or audio is included; use media you have rights to.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 45)) / 100 end
function Query()
    return { name = "Unexpected John Cena", description = "Adds a bold contrast and bass-impact treatment to your own clip.", settings = {{ name = "Strength", value = "45", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local c, sat = string.format("%.2f", 1 + x * 0.35), string.format("%.2f", 1 + x * 0.25)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=contrast=" .. c .. ":saturation=" .. sat .. ",vignette=PI/5\" -af \"equalizer=f=90:t=q:w=1:g=4\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
