-- The Nutshack Remix: user-source remix treatment, no bundled media.
-- NVG v1.8.x workshop plugin.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 55)) / 100 end
function Query()
    return { name = "The Nutshack Remix", description = "Applies a punchy, colorful remix grade to your source clip; add your own audio in your editor.", settings = {{ name = "Strength", value = "55", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local sat, contrast = string.format("%.2f", 1 + x * 0.7), string.format("%.2f", 1 + x * 0.18)
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"eq=saturation=" .. sat .. ":contrast=" .. contrast .. ",unsharp=5:5:0.4\" -af \"aecho=0.8:0.7:90:0.18\" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
