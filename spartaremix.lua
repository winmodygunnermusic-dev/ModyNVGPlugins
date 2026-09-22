-- Sparta Remix v2.5
-- Nonsensical Video Generator workshop plugin.
--
-- This plugin registers the v2.5 shared library layout.  NVG creates the
-- folders; no copyrighted media is bundled by this plugin.

local function settingNumber(settings, name, defaultValue)
    local value = settings and tonumber(settings[name])
    return value or defaultValue
end

local function settingBool(settings, name, defaultValue)
    if settings == nil or settings[name] == nil then
        return defaultValue
    end

    local value = settings[name]
    return value == true or value == "1" or value == "true" or value == "True"
end

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

function Query(localeName, localizationTokens)
    return {
        ["name"] = "Sparta Remix",
        ["description"] = "140 BPM Sparta-style stutter remix with optional library music.",
        ["settings"] = {
            { ["name"] = "Version", ["value"] = "2.5", ["type"] = "label" },
            { ["name"] = "BPM", ["value"] = "140", ["type"] = "number", ["tooltip"] = "Remix tempo; supported range is 60 to 240 BPM." },
            { ["name"] = "Use Sparta Music", ["value"] = "1", ["type"] = "bool", ["tooltip"] = "Mix a random sound from the Sparta Remix Audio library when available." },
            { ["name"] = "Music Volume", ["value"] = "0.30", ["type"] = "float", ["tooltip"] = "Volume of the optional Sparta library sound." },
            { ["name"] = "Output FPS", ["value"] = "30", ["type"] = "number", ["tooltip"] = "Frame rate used for the final remix." }
        },
        ["libraries"] = {
            { ["name"] = "Project Sounds", ["path"] = "sounds", ["type"] = "audio", ["tooltip"] = "General project sounds and short audio samples." },
            { ["name"] = "Project Images", ["path"] = "images", ["type"] = "image", ["tooltip"] = "General images, textures, and visual source material." },
            { ["name"] = "Project Videos", ["path"] = "videos", ["type"] = "video", ["tooltip"] = "General project video source material." },
            { ["name"] = "Effect Videos", ["path"] = "effects", ["type"] = "video", ["tooltip"] = "Effect clips, transitions, and visual processing material." },
            { ["name"] = "Text Images", ["path"] = "text", ["type"] = "image", ["tooltip"] = "Text cards, captions, and title images." },
            { ["name"] = "Keyframe Images", ["path"] = "keyframe", ["type"] = "image", ["tooltip"] = "Keyframe artwork and pan/zoom image sources." },
            { ["name"] = "Animation Videos", ["path"] = "animation", ["type"] = "video", ["tooltip"] = "Animated clips and frame-animation videos." },
            { ["name"] = "Sparta Remix Audio", ["path"] = "spartaremix", ["type"] = "audio", ["tooltip"] = "WAV, MP3, OGG, M4A, or FLAC music and sound effects." },
            { ["name"] = "Dance Videos", ["path"] = "dance", ["type"] = "video", ["tooltip"] = "Optional dance clips for the NVG video library." },
            { ["name"] = "Remix Videos", ["path"] = "remix", ["type"] = "video", ["tooltip"] = "Optional remix source clips." },
            { ["name"] = "Dance Images", ["path"] = "dance_images", ["type"] = "image", ["tooltip"] = "Dance thumbnails, stickers, and image overlays." },
            { ["name"] = "Remix Images", ["path"] = "remix_images", ["type"] = "image", ["tooltip"] = "Remix text cards, animation frames, and keyframe artwork." },
            { ["name"] = "Remix Keyframes", ["path"] = "remix_keyframes", ["type"] = "image", ["tooltip"] = "Remix-specific keyframe images and animation poses." },
            { ["name"] = "Music Effects", ["path"] = "music_effects", ["type"] = "audio", ["tooltip"] = "Music-effect hits and transitions." },
            { ["name"] = "WTF Boom Effects", ["path"] = "wtf_boom", ["type"] = "audio", ["tooltip"] = "Boom, impact, and WTF sound effects." },
            { ["name"] = "Tennis Videos", ["path"] = "tennis", ["type"] = "video", ["tooltip"] = "Tennis clips and overlays for shared effects." },
            { ["name"] = "Commercial Videos", ["path"] = "commercials", ["type"] = "video", ["tooltip"] = "Commercial clips and commercial overlay material." },
            { ["name"] = "Commercial Overlays", ["path"] = "commercial_overlays", ["type"] = "image", ["tooltip"] = "Commercial logos, title cards, bugs, and overlay images." },
            { ["name"] = "Windows Event Sounds", ["path"] = "windows_events", ["type"] = "audio", ["tooltip"] = "Microsoft Windows error, startup, shutdown, logon, and logoff sounds." },
            { ["name"] = "Windows Event Images", ["path"] = "windows_event_images", ["type"] = "image", ["tooltip"] = "Microsoft Windows error dialogs, startup, shutdown, logon, logoff, and other images." }
        }
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then
        return false
    end

    local bpm = clamp(settingNumber(pluginSettings, "BPM", 140), 60, 240)
    local fps = math.floor(clamp(settingNumber(pluginSettings, "Output FPS", 30), 12, 60))
    local beat = 60 / bpm
    local shortCut = string.format("%.3f", beat / 7)
    local longCut = string.format("%.3f", beat * 0.35)
    local tempA = "spartaremix_a.mp4"
    local tempB = "spartaremix_b.mp4"
    local tempC = "spartaremix_c.mp4"
    local tempAudio = "spartaremix_source_audio.m4a"

    for _, path in ipairs({ tempA, tempB, tempC, tempAudio }) do
        if functions.fileExists(path) then
            functions.fileDelete(path)
        end
    end

    -- Use separate clips so seeking is accurate and no input file is renamed.
    functions.runFFmpeg("-ss 0 -t " .. longCut .. " -i \"" .. options.inputVideo .. "\" -map 0:v:0 -an -c:v libx264 -preset veryfast -crf 18 -y \"" .. tempA .. "\"")
    functions.runFFmpeg("-ss " .. shortCut .. " -t " .. shortCut .. " -i \"" .. options.inputVideo .. "\" -map 0:v:0 -an -c:v libx264 -preset veryfast -crf 18 -y \"" .. tempB .. "\"")
    functions.runFFmpeg("-ss 0 -t " .. shortCut .. " -i \"" .. options.inputVideo .. "\" -map 0:v:0 -an -c:v libx264 -preset veryfast -crf 18 -y \"" .. tempC .. "\"")

    -- Extracting optional source audio first prevents a music-enabled render
    -- from failing on a silent input video.
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:a? -vn -c:a aac -y \"" .. tempAudio .. "\"")

    local pattern = { tempA, tempA, tempC, tempA, tempB, tempB, tempC, tempB, tempA, tempC, tempB, tempB }
    local inputs = { "-i \"" .. options.inputVideo .. "\"" }
    for _, clip in ipairs(pattern) do
        inputs[#inputs + 1] = "-i \"" .. clip .. "\""
    end

    local concat = ""
    for index = 1, #pattern do
        concat = concat .. "[" .. index .. ":v]"
    end
    local filters = concat .. "concat=n=" .. #pattern .. ":v=1:a=0[remixv]"
    local music = nil
    if settingBool(pluginSettings, "Use Sparta Music", true) then
        music = functions.getRandomLibraryFile("audio", "spartaremix")
    end

    local audioArguments = "-map 0:a? -c:a aac "
    if music ~= nil and music ~= "" then
        local musicIndex = #pattern + 1
        inputs[#inputs + 1] = "-stream_loop -1 -i \"" .. music .. "\""
        local volume = clamp(settingNumber(pluginSettings, "Music Volume", 0.30), 0, 2)
        if functions.fileExists(tempAudio) then
            local sourceAudioIndex = musicIndex + 1
            inputs[#inputs + 1] = "-i \"" .. tempAudio .. "\""
            filters = filters .. ";[" .. sourceAudioIndex .. ":a][" .. musicIndex .. ":a]amix=inputs=2:duration=first:weights='1 " .. tostring(volume) .. "':normalize=0[audio]"
            audioArguments = "-map \"[audio]\" -c:a aac "
        else
            -- The library track remains a valid audio fallback for silent videos.
            audioArguments = "-map " .. musicIndex .. ":a -c:a aac "
        end
    end

    functions.runFFmpeg(table.concat(inputs, " ") .. " -filter_complex \"" .. filters .. "\" -map \"[remixv]\" " .. audioArguments .. "-r " .. fps .. " -c:v libx264 -preset veryfast -crf 18 -shortest -y \"" .. options.outputVideo .. "\"")

    for _, path in ipairs({ tempA, tempB, tempC, tempAudio }) do
        if functions.fileExists(path) then
            functions.fileDelete(path)
        end
    end

    return true
end

function StopGeneration(options, pluginSettings, functions)
    return true
end
