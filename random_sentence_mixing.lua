-- Random Sentence Mixing: randomized short audio-rate variation.
-- For actual word-level sentence mixing, edit with audio clips you have rights to.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 40)) / 100 end
function Query()
    return { name = "Random Sentence Mixing", description = "Randomized audio remix treatment for your own source; use separately licensed word clips for true sentence mixing.", settings = {{ name = "Strength", value = "40", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local rate = string.format("%.2f", 1 + x * 0.25)
    local echo = string.format("%.2f", x * 0.25)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=saturation=1.12:contrast=1.04\" -af \"atempo=" .. rate .. ",aecho=0.8:0.6:80:" .. echo .. "\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
