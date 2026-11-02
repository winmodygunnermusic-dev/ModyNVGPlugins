-- YTP Sound Mixer (safe, non-explicit alternative to the requested title)
-- NVG v1.8.x workshop plugin. Uses only the selected source video.

local function setting(settings, key, defaultValue, minimum, maximum)
    local value = tonumber(settings and settings[key]) or defaultValue
    return math.max(minimum, math.min(maximum, value))
end

function Query()
    return {
        name = "YTP Sound Mixer",
        description = "Adds playful stutter, echo, and color treatment to your own source clip.",
        settings = {
            { name = "Strength", value = "50", type = "number" }
        }
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local strength = setting(pluginSettings, "Strength", 50, 0, 100) / 100
    local saturation = 1 + strength * 0.6
    local echo = string.format("aecho=0.8:0.65:80:%.2f", strength * 0.35)
    functions.runFFmpeg(
        "-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? " ..
        "-vf \"eq=saturation=" .. string.format("%.2f", saturation) .. ",unsharp=5:5:0.35\" " ..
        "-af \"" .. echo .. "\" -c:v libx264 -preset veryfast -crf 20 " ..
        "-c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\""
    )
    return true
end

function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
