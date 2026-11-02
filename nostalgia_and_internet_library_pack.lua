-- NVG Nostalgia & Internet Overlay Library Pack
-- Library declarations only; no copyrighted media is bundled or fetched.
-- Add media you have rights to through NVG's Library tab.

local overlayLibraries = {
    { name = "Ironic YTP Clips", path = "ironic_ytp", type = "video", description = "User-provided ironic YTP-style clips." },
    { name = "Random GIF Overlays", path = "random_gif_overlays", type = "video", description = "User-provided animated GIF/video overlays." },
    { name = "Collab Entry GIFs", path = "collab_entry_gifs", type = "video", description = "Animated overlays for collaborative entries." },
    { name = "Keymate Images", path = "keymate_images", type = "image", description = "User-provided Keymate-themed still images." },
    { name = "Old Internet", path = "old_internet", type = "image", description = "Web-era graphics and images." },
    { name = "Geocities GIFs", path = "geocities_gifs", type = "video", description = "User-provided Geocities-style animated graphics." },
    { name = "Cartoon Network Coming Up", path = "cartoon_network_coming_up", type = "image", description = "Coming-up card images supplied by the user." },
    { name = "Pokemon", path = "pokemon", type = "image", description = "User-provided Pokemon-themed still images." },
    { name = "Spacetoon Planet", path = "spacetoon_planet", type = "image", description = "User-provided Spacetoon Planet images." },
    { name = "Cocolin Jesmar", path = "cocolin_jesmar", type = "image", description = "User-provided Cocolin/JESMAR images." },
    { name = "Egyptian Idents", path = "egyptian_idents", type = "video", description = "User-provided Egyptian TV ident clips." },
    { name = "Littlest Pet Shop", path = "littlest_pet_shop", type = "image", description = "User-provided Littlest Pet Shop still images." },
    { name = "Koky Kids", path = "koky_kids", type = "image", description = "User-provided Koky Kids still images." },
    { name = "Microsoft Live", path = "microsoft_live", type = "image", description = "User-provided Microsoft Live-era graphics." },
    { name = "2000s Overlays", path = "2000s_overlays", type = "image", description = "User-provided 2000s-era graphics and overlays." },
    { name = "Commercial Overlays", path = "commercial_overlays", type = "video", description = "Short commercial clips you are licensed to use." }
}

local function numberSetting(settings, name, defaultValue)
    local value = tonumber(settings and settings[name])
    return value or defaultValue
end

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function findLibraryAsset(functions)
    local count = #overlayLibraries
    local first = functions.randomInt(1, count)

    for offset = 0, count - 1 do
        local item = overlayLibraries[((first + offset - 1) % count) + 1]
        local path = functions.getRandomLibraryFile(item.type, item.path)
        if path ~= nil and path ~= "" then
            return item, path
        end
    end

    return nil, nil
end

function Query()
    local libraries = {}
    for _, item in ipairs(overlayLibraries) do
        libraries[#libraries + 1] = item
    end

    return {
        name = "Nostalgia & Internet Overlay Library Pack",
        description = "Adds one randomly selected user-library image or video overlay to your source clip. Media is not bundled.",
        settings = {
            { name = "Chance", value = "100", type = "number", tooltip = "Percentage chance to apply an overlay." },
            { name = "Overlay Opacity", value = "35", type = "number", tooltip = "Overlay opacity from 0 to 100 percent." },
            { name = "Overlay Size", value = "35", type = "number", tooltip = "Approximate overlay width as a percent of the output width." }
        },
        libraries = libraries
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then
        functions.fileCopy(options.inputVideo, options.outputVideo)
        return true
    end

    local chance = clamp(numberSetting(pluginSettings, "Chance", 100), 0, 100)
    if functions.randomInt(1, 100) > chance then
        functions.fileCopy(options.inputVideo, options.outputVideo)
        return true
    end

    local library, asset = findLibraryAsset(functions)
    if library == nil or asset == nil then
        functions.fileCopy(options.inputVideo, options.outputVideo)
        return true
    end

    local opacity = clamp(numberSetting(pluginSettings, "Overlay Opacity", 35), 0, 100) / 100
    local size = clamp(numberSetting(pluginSettings, "Overlay Size", 35), 5, 100)
    local width = math.max(2, tonumber(options.width) or 1280)
    local height = math.max(2, tonumber(options.height) or 720)
    local overlayWidth = math.max(2, math.floor(width * size / 100))
    local alpha = string.format("%.3f", opacity)
    local inputs

    if library.type == "image" then
        inputs = "-i \"" .. options.inputVideo .. "\" -loop 1 -i \"" .. asset .. "\""
    else
        inputs = "-i \"" .. options.inputVideo .. "\" -stream_loop -1 -i \"" .. asset .. "\""
    end

    local filter = "[0:v]scale=" .. width .. ":" .. height .. "[base];" ..
        "[1:v]scale=" .. overlayWidth .. ":-1:force_original_aspect_ratio=decrease,format=rgba," ..
        "colorchannelmixer=aa=" .. alpha .. "[sticker];" ..
        "[base][sticker]overlay=x='(W-w)*abs(sin(t*0.73))':y='(H-h)*abs(cos(t*0.61))':" ..
        "enable='lt(mod(t,6),3)'[outv]"

    functions.runFFmpeg(
        inputs .. " -filter_complex \"" .. filter .. "\" -map \"[outv]\" -map 0:a? " ..
        "-c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\""
    )
    return true
end

function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
