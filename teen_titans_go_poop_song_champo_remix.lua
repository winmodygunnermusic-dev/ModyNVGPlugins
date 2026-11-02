-- Teen Titans Go! Poop Song Champo Remix: cartoonish non-explicit treatment.
-- No song, show footage, or other copyrighted media is bundled.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 45)) / 100 end
function Query()
    return { name = "Teen Titans Go! Poop Song - Champo Remix", description = "A playful cartoon color/audio treatment for user-provided footage. No copyrighted song or show media is included.", settings = {{ name = "Strength", value = "45", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat = string.format("%.2f", 1.1 + x * 0.55)
    local echo = string.format("%.2f", 0.1 + x * 0.2)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=saturation=" .. sat .. ":contrast=1.08,unsharp=5:5:0.5\" -af \"aecho=0.8:0.65:100:" .. echo .. "\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
