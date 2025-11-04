---@diagnostic disable: lowercase-global

---@type any
sbar = sbar

---@type {
---    [string]: {
---        workspace: string,
---        focused: boolean,
---        items: {
---            space: unknown,
---            bracket: unknown,
---            apps_bracket: unknown,
---            padding: unknown,
---            apps: { [string]: unknown },
---        },
---        apps: { [string]: {
---            workspace: string,
---            name: string,
---            bundle_id: string,
---            pid: number,
---        } }[],
---    },
---}
data = {}


---@type string
current_app_name = ""


do_animate = false

animate = function(fn)
    if do_animate then
        sbar.animate("tanh", 10, function()
            fn()
        end)
    else
        fn()
    end
end
