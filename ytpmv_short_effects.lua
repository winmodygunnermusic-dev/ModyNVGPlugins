```lua
-- YTPMV Short Effects
-- Nonsensical Video Generator
-- Short/simple YTPMV-style effect addon

function Query()
    return {
        ["name"] = "YTPMV Short Effects",
        ["description"] = "Short chaotic effects for YTPMV-style edits.",
        ["version"] = "1.0",

        ["libraries"] = {
            "video",
            "audio"
        },

        ["settings"] = {
            {
                ["name"] = "Effect",
                ["value"] = "Stutter",
                ["type"] = "label"
            }
        }
    }
end

function Process(job)
    -- Short YTPMV effect:
    -- repeat a tiny section of the source clip,
    -- creating a rhythmic stutter.

    local duration = job:getDuration()

    if duration <= 0 then
        return
    end

    local slice = math.min(0.12, duration / 4)

    job:cut(0, slice)
    job:duplicate(3)

    -- Quick rhythmic speed variation
    job:speed(1.25)

    -- Return to normal timing
    job:speed(0.8)
end
```

**Addon name:** `YTPMV Short Effects`

**Suggested short-effect library:**

* `Stutter` — repeats a tiny clip slice
* `Beat Cut` — rapid rhythmic cuts
* `Micro Reverse` — reverses a very short section
* `Pitch Snap` — quick pitch jump
* `Speed Burst` — brief acceleration
* `Frame Repeat` — repeats a frame/mini-loop
* `Echo Hit` — short audio echo
* `Chaos Cut` — tiny randomized clip cuts

```

**Important:** the exact processing API depends on NVG's Lua API available to your version; the official documentation shows that addon scripts use the Lua effect API, but the example above is a **concept/template**, not guaranteed drop-in code for v1.8.1.2.

If you want, I can make a **realistic `ytpmv_library.lua` with 20 short YTPMV effects** using the documented NVG API rather than placeholder processing calls.
```
