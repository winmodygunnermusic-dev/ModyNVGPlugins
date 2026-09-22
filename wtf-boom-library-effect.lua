-- WTF Boom Library Effect for NVG 2.5.
-- Combines a BOOM visual overlay with optional impact audio.

local function clamp(value, low, high) return math.max(low, math.min(high, value)) end
local function numberSetting(settings, name, defaultValue) return (settings and tonumber(settings[name])) or defaultValue end
local function boolSetting(settings, name, defaultValue)
    local value = settings and settings[name]
    if value == nil then return defaultValue end
    return value == true or value == "1" or value == "true" or value == "True"
end

function Query()
    return {
        name = "WTF Boom Library Effect",
        description = "A configurable BOOM impact effect using optional image overlays and sounds.",
        settings = {
            { name = "Chance", value = "65", type = "number" },
            { name = "Intensity", value = "80", type = "number" },
            { name = "Use Boom Sound", value = "1", type = "bool" }
        },
        libraries = {
            { name = "WTF Boom Images", path = "effects/wtf-boom/image", type = "image", description = "BOOM text and image overlays." },
            { name = "WTF Boom Sounds", path = "effects/wtf-boom/sounds", type = "audio", description = "Impact sounds." }
        }
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    if functions.randomInt(1, 100) > clamp(numberSetting(pluginSettings, "Chance", 65), 0, 100) then functions.fileCopy(options.inputVideo, options.outputVideo) return true end
    local intensity = clamp(numberSetting(pluginSettings, "Intensity", 80), 0, 100)
    local image = functions.getRandomLibraryFile("image", "effects/wtf-boom/image")
    local sound = boolSetting(pluginSettings, "Use Boom Sound", true) and functions.getRandomLibraryFile("audio", "effects/wtf-boom/sounds") or nil
    if (image == nil or image == "") and (sound == nil or sound == "") then functions.fileCopy(options.inputVideo, options.outputVideo) return true end
    local inputs, filters = { "-i \"" .. options.inputVideo .. "\"" }, { "[0:v]eq=contrast=" .. (1 + intensity / 180) .. ":brightness=" .. (intensity / 900) .. "[base]" }
    local current, index = "base", 1
    if image and image ~= "" then
        inputs[#inputs + 1] = "-loop 1 -i \"" .. image .. "\""
        filters[#filters + 1] = "[" .. index .. ":v]scale=iw*min(720/iw\\,720/ih):ih*min(720/iw\\,720/ih)[boom]"
        filters[#filters + 1] = "[base][boom]overlay=(W-w)/2:(H-h)/2:enable='lt(mod(t,2.5),0.22)'[withboom]"
        current, index = "withboom", index + 1
    end
    local audio = "-map 0:a? -c:a aac"
    if sound and sound ~= "" then
        inputs[#inputs + 1] = "-stream_loop -1 -i \"" .. sound .. "\""
        filters[#filters + 1] = "[" .. index .. ":a]volume=" .. (0.3 + intensity / 100) .. ",atrim=duration=3600[impact];[0:a][impact]amix=inputs=2:duration=first[aout]"
        audio = "-map \"[aout]\" -c:a aac"
    end
    functions.runFFmpeg(table.concat(inputs, " ") .. " -filter_complex \"" .. table.concat(filters, ";") .. "\" -map \"[" .. current .. "]\" " .. audio .. " -c:v libx264 -preset veryfast -crf 18 -shortest -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand() end
function StopGeneration() return true end
