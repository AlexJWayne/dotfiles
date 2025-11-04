---@param callback fun()
return function(callback)
    sbar.exec("aerospace list-workspaces --all --json --format '%{workspace}%{workspace-is-focused}'", function(spaces)
        for _, space in ipairs(spaces) do
            local space_data                = data[space.workspace] or {
                items = { apps = {} },
            }
            data[space.workspace]           = space_data
            data[space.workspace].apps      = {}
            data[space.workspace].workspace = space.workspace
            data[space.workspace].focused   = space['workspace-is-focused']
        end

        sbar.exec("aerospace list-windows --all --json --format '%{app-bundle-id}%{app-name}%{workspace}%{app-pid}'",
            function(windows)
                for _, window in ipairs(windows) do
                    data[window.workspace].apps[window['app-name']] = {
                        workspace = window['workspace'],
                        name = window['app-name'],
                        bundle_id = window['app-bundle-id'],
                        pid = window['app-pid'],
                    }
                end

                callback()
            end)
    end)
end
