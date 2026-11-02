-- FitGirl Repacks Remix: pixel-art/compression-inspired effect only.
-- Does not download, distribute, or modify software packages.
local function strength(s) return math.max(0, math.min(100, tonumber(s and s.Strength) or 50)) / 100 end
function Query()
    return { name = "FitGirl Repacks Remix", description = "Creates a deliberately blocky, low-resolution remix look from your source video. Not affiliated with any repack publisher.", settings = {{ name = "Strength", value = "50", type = "number" }} }
end
function StartGeneration(options, pluginSettings, functions)
    if not functions.ffmpegInstalled() then return false end
    local x = strength(pluginSettings)
    local divisor = math.max(2, math.floor(6 - x * 3))
    local scale = "scale=trunc(iw/" .. divisor .. ")*2:trunc(ih/" .. divisor .. ")*2:flags=neighbor,scale=iw:ih:flags=neighbor"
    functions.runFFmpeg("-i \"" .. options.inputVideo .. "\" -map 0:v:0 -map 0:a? -vf \"" .. scale .. ",noise=alls=" .. tostring(math.floor(8 + x * 18)) .. ":allf=t\" -af \"lowpass=f=12000\" -c:v libx264 -preset veryfast -crf 26 -c:a aac -b:a 160k -y \"" .. options.outputVideo .. "\"")
    return true
end
function PostCommand(commandIndex, outputResult, errorResult, options, pluginSettings, functions) end
function StopGeneration(options, pluginSettings, functions) return true end
