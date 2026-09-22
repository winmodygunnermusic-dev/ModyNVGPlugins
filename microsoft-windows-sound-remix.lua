-- Microsoft Windows Sound Remix Library for NVG 2.5.
-- Add only media you are licensed to use to the declared library folders.

local function setting(settings, name, defaultValue)
    local value = settings and settings[name]
    if value == nil then return defaultValue end
    return value == true or value == "1" or value == "true"
end

local function pick(functions, path)
    local file = functions.getRandomLibraryFile("audio", path)
    return file ~= nil and file ~= "" and file or nil
end

function Query()
    return {
        name = "Microsoft Windows Sound Remix",
        description = "Mixes an optional Windows event sound and visual error overlay into a remix.",
        settings = {
            { name = "Use Event Sound", value = "1", type = "bool" },
            { name = "Use Error Image", value = "1", type = "bool" }
        },
        libraries = {
            { name = "Windows Error Sounds", path = "microsoft-windows/error", type = "audio", description = "Error and warning sounds." },
            { name = "Windows Startup Sounds", path = "microsoft-windows/startup", type = "audio", description = "Startup sounds." },
            { name = "Windows Shutdown Sounds", path = "microsoft-windows/shutdown", type = "audio", description = "Shutdown sounds." },
            { name = "Windows Logon Sounds", path = "microsoft-windows/logon", type = "audio", description = "Logon sounds." },
            { name = "Windows Logoff Sounds", path = "microsoft-windows/logoff", type = "audio", description = "Logoff sounds." },
            { name = "Windows Images", path = "microsoft-windows/images", type = "image", description = "Error dialogs, desktop images and other visuals." },
            { name = "Windows More", path = "microsoft-windows/more", type = "video", description = "Additional Windows-themed remix clips." }
        }
    }
end

function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local sound = nil
    if setting(pluginSettings, "Use Event Sound", true) then
        local folders = { "microsoft-windows/error", "microsoft-windows/startup", "microsoft-windows/shutdown", "microsoft-windows/logon", "microsoft-windows/logoff" }
        sound = pick(functions, folders[functions.randomInt(1, #folders)])
    end
    local image = setting(pluginSettings, "Use Error Image", true) and functions.getRandomLibraryFile("image", "microsoft-windows/images") or nil
    if (image == nil or image == "") and sound == nil then functions.fileCopy(options.inputVideo, options.outputVideo) return true end
    local inputs, filters = { "-i \"" .. options.inputVideo .. "\"" }, {}
    local current, index = "base", 1
    filters[#filters + 1] = "[0:v]format=rgba[base]"
    if image and image ~= "" then
        inputs[#inputs + 1] = "-loop 1 -i \"" .. image .. "\""
        filters[#filters + 1] = "[" .. index .. ":v]scale=iw*min(640/iw\\,360/ih):ih*min(640/iw\\,360/ih)[dialog]"
        filters[#filters + 1] = "[base][dialog]overlay=(W-w)/2:(H-h)/2:enable='lt(mod(t,4),1.1)'[withdialog]"
        current, index = "withdialog", index + 1
    end
    local audio = "-map 0:a? -c:a aac"
    if sound then
        inputs[#inputs + 1] = "-i \"" .. sound .. "\""
        filters[#filters + 1] = "[" .. index .. ":a]volume=0.55,apad[event];[0:a][event]amix=inputs=2:duration=first[aout]"
        audio = "-map \"[aout]\" -c:a aac"
    end
    functions.runFFmpeg(table.concat(inputs, " ") .. " -filter_complex \"" .. table.concat(filters, ";") .. "\" -map \"[" .. current .. "]\" " .. audio .. " -c:v libx264 -preset veryfast -crf 18 -shortest -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand() end
function StopGeneration() return true end
