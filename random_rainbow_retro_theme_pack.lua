-- Generated Retro / Meme NVG Effect and User-Media Library Pack
-- No copyrighted logos, screenshots, music, or video clips are bundled.
-- Add media you have rights to use through NVG's Library tab.
--
-- Compatible interface modeled on the repository's existing NVG plugins:
-- Query(), StartGeneration(options, pluginSettings, functions),
-- PostCommand(), and StopGeneration().

local themes = {
    {
        name = "Windows 2000 Effect Library",
        path = "windows_2000",
        type = "image",
        description = "User-provided Windows 2000-inspired screens and graphics.",
        filter = "eq=contrast=1.08:saturation=0.88"
    },
    {
        name = "Boot Screen Startup Effect Library",
        path = "boot_startup_screens",
        type = "video",
        description = "User-provided retro computer boot and startup screen clips.",
        filter = "fade=t=in:st=0:d=0.7,eq=contrast=1.08"
    },
    {
        name = "THX x3 Screaming Video Crossover Library",
        path = "thx_scream_crossover_x3",
        type = "video",
        description = "User-provided crossover clips; the selected clip appears in three short bursts.",
        filter = "eq=contrast=1.12:saturation=1.15",
        tripleBurst = true
    },
    {
        name = "THX Logo Effect Library",
        path = "thx_logo",
        type = "image",
        description = "User-provided THX-style logo images. No logo artwork is included.",
        filter = "eq=contrast=1.12"
    },
    {
        name = "Ironic YTP Effect Library",
        path = "ironic_ytp",
        type = "video",
        description = "User-provided ironic YTP clips and overlays.",
        filter = "fps=18,eq=saturation=1.25"
    },
    {
        name = "Spacetoon Template Library",
        path = "spacetoon_templates",
        type = "image",
        description = "User-provided Spacetoon-inspired templates and cards.",
        filter = "eq=saturation=1.20"
    },
    {
        name = "Pokemon Effect Library",
        path = "pokemon",
        type = "image",
        description = "User-provided Pokemon-themed stills and overlays.",
        filter = "eq=saturation=1.28"
    },
    {
        name = "Super Mario Effect Library",
        path = "super_mario",
        type = "image",
        description = "User-provided Super Mario-themed stills and overlays.",
        filter = "eq=saturation=1.30:contrast=1.04"
    }
}

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function numberSetting(settings, name, defaultValue)
    local value = tonumber(settings and settings[name])
    if value == nil then
        return defaultValue
    end
    return value
end

local function copyInput(options, functions)
    functions.fileCopy(options.inputVideo, options.outputVideo)
    return true
end

function Query()
    local libraryList = {}
    for _, theme in ipairs(themes) do
        libraryList[#libraryList + 1] = {
            name = theme.name,
            path = theme.path,
            type = theme.type,
            description = theme.description
        }
    end

    return {
        name = "Random Rainbow Dance & Retro Theme Pack",
        description = "Randomized rainbow dance processing plus user-media overlays for retro startup screens, THX, ironic YTP, Spacetoon, Pokemon, and Super Mario themes.",
        settings = {
            {
                name = "Theme (0=random, 1-8=library)",
                value = "0",
                type = "number",
                tooltip = "0 chooses a random library; 1-8 select the corresponding library listed in this plugin."
            },
            {
                name = "Rainbow Dance Chance",
                value = "70",
                type = "number",
                tooltip = "Chance from 0 to 100 to add a generated cycling-rainbow dance treatment."
            },
            {
                name = "Overlay Chance",
                value = "85",
                type = "number",
                tooltip = "Chance from 0 to 100 to add an available user-library asset."
            },
            {
                name = "Overlay Opacity",
                value = "35",
                type = "number",
                tooltip = "Overlay opacity from 0 to 100 percent."
            },
            {
                name = "Overlay Size",
                value = "45",
                type = "number",
                tooltip = "Overlay width as a percent of the output width."
            }
        },
        libraries = libraryList
    }
end

local function chooseTheme(themeSetting, functions)
    local index = math.floor(clamp(themeSetting, 0, #themes))
    if index == 0 then
        index = functions.randomInt(1, #themes)
    end
    return themes[index]
end

local function buildVideoFilter(theme, addRainbow, functions)
    local filters = {}
    if theme and theme.filter then
        filters[#filters + 1] = theme.filter
    end

    if addRainbow then
        filters[#filters + 1] = "hue=h='mod(t*42,360)':s=1.45"
        filters[#filters + 1] = "rotate='0.025*sin(2*PI*t)':ow=iw:oh=ih:c=black@0"
        if functions.randomInt(1, 2) == 1 then
            filters[#filters + 1] = "hflip"
        end
    end

    if #filters == 0 then
        filters[1] = "null"
    end
    return table.concat(filters, ",")
end

function StartGeneration(options, pluginSettings, functions)
    if not options or not options.inputVideo or not options.outputVideo then
        return false
    end

    if not functions or not functions.ffmpegInstalled or not functions.ffmpegInstalled() then
        return copyInput(options, functions)
    end

    pluginSettings = pluginSettings or {}
    local chance = clamp(numberSetting(pluginSettings, "Rainbow Dance Chance", 70), 0, 100)
    local overlayChance = clamp(numberSetting(pluginSettings, "Overlay Chance", 85), 0, 100)
    local opacity = clamp(numberSetting(pluginSettings, "Overlay Opacity", 35), 0, 100) / 100
    local size = clamp(numberSetting(pluginSettings, "Overlay Size", 45), 5, 100)
    local theme = chooseTheme(numberSetting(pluginSettings, "Theme (0=random, 1-8=library)", 0), functions)
    local addRainbow = functions.randomInt(1, 100) <= chance

    local asset
    if functions.randomInt(1, 100) <= overlayChance then
        asset = functions.getRandomLibraryFile(theme.type, theme.path)
    end

    local width = math.max(2, math.floor(tonumber(options.width) or 1280))
    local height = math.max(2, math.floor(tonumber(options.height) or 720))
    local videoFilter = buildVideoFilter(theme, addRainbow, functions)

    if not asset or asset == "" then
        functions.runFFmpeg(
            "-i \"" .. options.inputVideo .. "\" -vf \"" .. videoFilter .. "\" " ..
            "-map 0:v:0 -map 0:a? -c:v libx264 -preset veryfast -crf 20 " ..
            "-c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\""
        )
        return true
    end

    local overlayWidth = math.max(2, math.floor(width * size / 100))
    local alpha = string.format("%.3f", opacity)
    local inputArgs
    if theme.type == "image" then
        inputArgs = "-i \"" .. options.inputVideo .. "\" -loop 1 -i \"" .. asset .. "\""
    else
        inputArgs = "-i \"" .. options.inputVideo .. "\" -stream_loop -1 -i \"" .. asset .. "\""
    end

    local filter = "[0:v]scale=" .. width .. ":" .. height .. "," .. videoFilter .. "[base];" ..
        "[1:v]scale=" .. overlayWidth .. ":-1:force_original_aspect_ratio=decrease," ..
        "format=rgba,colorchannelmixer=aa=" .. alpha .. "[sticker];"

    if theme.tripleBurst then
        -- Each overlay consumes its input pad, so split the prepared clip
        -- before using it for the three separate bursts.
        filter = filter ..
            "[sticker]split=3[sticker1][sticker2][sticker3];" ..
            "[base][sticker1]overlay=x=(W-w)/2:y=(H-h)/2:enable='between(t,0,2)'[first];" ..
            "[first][sticker2]overlay=x=(W-w)/2:y=(H-h)/2:enable='between(t,4,6)'[second];" ..
            "[second][sticker3]overlay=x=(W-w)/2:y=(H-h)/2:enable='between(t,8,10)'[outv]"
    else
        filter = filter .. "[base][sticker]overlay=x=(W-w)/2:y=(H-h)/2:shortest=0:format=auto[outv]"
    end

    functions.runFFmpeg(
        inputArgs .. " -filter_complex \"" .. filter .. "\" -map \"[outv]\" -map 0:a? " ..
        "-c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 192k -y \"" .. options.outputVideo .. "\""
    )
    return true
end

function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions)
end

function StopGeneration(options, pluginSettings, functions)
    return true
end
