-- NVG 2.5 Remix Library
-- A library-driven video, image, music and keyframe remix effect.

local function numberSetting(settings, name, defaultValue)
    local value = settings and tonumber(settings[name])
    return value or defaultValue
end

local function boolSetting(settings, name, defaultValue)
    if not settings or settings[name] == nil then
        return defaultValue
    end

    local value = settings[name]
    return value == true or value == "1" or value == "true" or value == "True"
end

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function libraryFile(functions, mediaType, path)
    local file = functions.getRandomLibraryFile(mediaType, path)
    if file == nil or file == "" then
        return nil
    end

    return file
end

function Query()
    return {
        name = "Version 2.5 Remix Library",
        description = "Library-driven dance, music, keyframe and animation remix effect for NVG 2.5.",
        settings = {
            { name = "Chance", value = "100", type = "number" },
            { name = "Dance Amount", value = "70", type = "number" },
            { name = "Keyframe Amount", value = "65", type = "number" },
            { name = "Use Video Remix", value = "1", type = "bool" },
            { name = "Use Image Overlay", value = "1", type = "bool" },
            { name = "Use Music", value = "1", type = "bool" }
        },
        libraries = {
            { name = "Sounds", path = "sounds", type = "audio", description = "General sound effects and music hits." },
            { name = "Images", path = "images", type = "image", description = "General image overlays." },
            { name = "Videos", path = "videos", type = "video", description = "General remix source videos." },
            { name = "Effects", path = "effects", type = "video", description = "Effect clips and visual elements." },
            { name = "Text", path = "text", type = "image", description = "Text cards, captions and title graphics." },
            { name = "Keyframe", path = "keyframe", type = "image", description = "Keyframe images and animated overlays." },
            { name = "Animation", path = "animation", type = "video", description = "Animated clips for remix inserts." },
            { name = "Dance Videos", path = "video/dance", type = "video", description = "Dance clips used by the dance remix." },
            { name = "Remix Videos", path = "video/remix", type = "video", description = "Video clips used for remixes." },
            { name = "Dance Images", path = "image/dance", type = "image", description = "Dance-themed image overlays." },
            { name = "Remix Images", path = "image/remix", type = "image", description = "Remix-themed image overlays." },
            { name = "Music Effects", path = "music/effects", type = "audio", description = "Music effects, beats and transitions." }
        }
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then
        return false
    end

    if functions.randomInt(1, 100) > clamp(numberSetting(pluginSettings, "Chance", 100), 0, 100) then
        functions.fileCopy(options.inputVideo, options.outputVideo)
        return true
    end

    local width = tonumber(options.width) or 1280
    local height = tonumber(options.height) or 720
    local dance = clamp(numberSetting(pluginSettings, "Dance Amount", 70), 0, 100)
    local keyframe = clamp(numberSetting(pluginSettings, "Keyframe Amount", 65), 0, 100)
    local remixVideo = boolSetting(pluginSettings, "Use Video Remix", true) and libraryFile(functions, "video", "video/remix") or nil
    local overlay = boolSetting(pluginSettings, "Use Image Overlay", true) and (libraryFile(functions, "image", "keyframe") or libraryFile(functions, "image", "image/remix")) or nil
    local music = boolSetting(pluginSettings, "Use Music", true) and (libraryFile(functions, "audio", "music/effects") or libraryFile(functions, "audio", "sounds")) or nil
    local inputs = { "-i \"" .. options.inputVideo .. "\"" }
    local filters = {}
    local current = "base"
    local inputIndex = 1

    filters[#filters + 1] = "[0:v]scale=" .. width .. ":" .. height .. ",crop='iw/(1+" .. (keyframe / 700) .. "*sin(t*2.4))':'ih/(1+" .. (keyframe / 700) .. "*sin(t*2.4))':'(iw-ow)/2+(iw-ow)/2*sin(t*1.7)':'(ih-oh)/2+(ih-oh)/2*cos(t*2.1)',scale=" .. width .. ":" .. height .. ",eq=saturation=" .. (1 + dance / 250) .. "[base]"

    if remixVideo then
        inputs[#inputs + 1] = "-stream_loop -1 -i \"" .. remixVideo .. "\""
        filters[#filters + 1] = "[" .. inputIndex .. ":v]scale=" .. math.floor(width * 0.32) .. ":" .. math.floor(height * 0.32) .. ",setpts=PTS-STARTPTS[remix]"
        filters[#filters + 1] = "[" .. current .. "][remix]overlay=x='(W-w)*(0.5+0.45*sin(t*1.9))':y='(H-h)*(0.5+0.45*cos(t*1.3))':enable='lt(mod(t,3),1.2)'[withremix]"
        current = "withremix"
        inputIndex = inputIndex + 1
    end

    if overlay then
        inputs[#inputs + 1] = "-loop 1 -i \"" .. overlay .. "\""
        filters[#filters + 1] = "[" .. inputIndex .. ":v]scale=" .. math.floor(width * 0.24) .. ":-1,format=rgba[art]"
        filters[#filters + 1] = "[" .. current .. "][art]overlay=x='(W-w)*abs(sin(t*2.1))':y='(H-h)*abs(cos(t*1.6))':enable='lt(mod(t,2),0.7)'[withart]"
        current = "withart"
        inputIndex = inputIndex + 1
    end

    local audioMap = "-map 0:a? -c:a aac"
    if music then
        inputs[#inputs + 1] = "-stream_loop -1 -i \"" .. music .. "\""
        filters[#filters + 1] = "[" .. inputIndex .. ":a]volume=0.35,atrim=duration=3600[music];[0:a][music]amix=inputs=2:duration=first:dropout_transition=0[aout]"
        audioMap = "-map \"[aout]\" -c:a aac"
    end

    functions.runFFmpeg(table.concat(inputs, " ") .. " -filter_complex \"" .. table.concat(filters, ";") .. "\" -map \"[" .. current .. "]\" " .. audioMap .. " -c:v libx264 -preset veryfast -crf 18 -shortest -y \"" .. options.outputVideo .. "\"")
    return true
end

function PostCommand() end
function StopGeneration() return true end
