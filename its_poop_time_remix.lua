-- It's Poop Time: lighthearted cartoon color treatment, no graphic content.
-- NVG v1.8.x workshop plugin; no copyrighted song is bundled.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 45)) / 100 end
function Query()
    return { name = "It's Poop Time", description = "A playful warm-toned cartoon grade for your own clip. Add any music you have rights to separately.", settings = {{ name = "Strength", value = "45", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat, contrast = string.format("%.2f", 1 + x * 0.35), string.format("%.2f", 1 + x * 0.12)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"colorbalance=rs=" .. string.format("%.2f", x * 0.12) .. ":gs=" .. string.format("%.2f", x * 0.02) .. ",eq=saturation=" .. sat .. ":contrast=" .. contrast .. "\" -af \"acompressor=threshold=0.15:ratio=2.5\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
