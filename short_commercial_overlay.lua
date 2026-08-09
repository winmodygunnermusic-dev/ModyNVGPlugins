-- Short Commercial Overlay
-- Nonsensical Video Generator Workshop addon
-- NVG v1.8.x

function Query()
    return {
        ["name"] = "Short Commercial Overlay",

        ["settings"] = {
            {
                ["name"] = "Chance",
                ["value"] = "35",
                ["type"] = "number"
            },
            {
                ["name"] = "Max Duration",
                ["value"] = "4",
                ["type"] = "number"
            }
        },

        ["libraries"] = {
            {
                ["name"] = "Commercials",
                ["type"] = "video",
                ["description"] = "Short commercial clips used as overlays."
            }
        }
    }
end

function Effect(job)
    -- Random chance to activate the commercial overlay.
    local chance = tonumber(job.settings["Chance"]) or 35

    if math.random(1, 100) > chance then
        return
    end

    -- Pick a short commercial from the addon library.
    local commercial = job.library["video"]["Commercials"]

    if commercial == nil then
        return
    end

    -- Apply the selected commercial as a short overlay.
    -- Keep the clip brief for a sudden YTP-style interruption.
    local maxDuration =
        tonumber(job.settings["Max Duration"]) or 4

    -- The exact render operation should use the video-effect
    -- functions supplied by the NVG template for your installed version.
    --
    -- Recommended behavior:
    -- 1. Select a random Commercials video.
    -- 2. Limit it to Max Duration seconds.
    -- 3. Scale it to the source video.
    -- 4. Composite it over the current clip.
    -- 5. Preserve the original audio unless the commercial
    --    intentionally contains its own audio.
end
```

### Library structure

Create the addon through **Addons → Workshop Effect Management**, then use the generated template rather than replacing the entire API structure manually. NVG's Workshop documentation specifically recommends creating an effect from its built-in template and editing the resulting Lua file.

Use:

```text
NonsensicalVideoGenerator/
└── plugins/
    └── workshop/
        └── short_commercial_overlay/
            └── short_commercial_overlay.lua
```

And put your media in the addon's:

```text
Commercials/
├── commercial_01.mp4
├── commercial_02.mp4
├── commercial_03.mp4
├── commercial_04.mp4
└── commercial_05.mp4
```

**Effect behavior:**

```text
Normal video
     ↓
35% activation chance
     ↓
Random Commercials clip
     ↓
0–4 second duration
     ↓
Full-frame / overlay
     ↓
Return to original video
```

For a more YTP-like result, use **0.5–3 second** commercials, occasional hard cuts, oversized logos, fake product ads, and abrupt transitions. NVG already treats overlays as a video-library category, and community effects can create their own video/audio libraries.
