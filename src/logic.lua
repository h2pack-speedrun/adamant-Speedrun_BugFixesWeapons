local module = {}
local data = nil

function module.buildPatchPlan(plan, _, store)
    for _, b in ipairs(data.patches) do
        if store.read(b.key) and b.fn then
            b.fn(plan)
        end
    end
end

function module.registerHooks(host, store)
    for _, fn in ipairs(data.hooks) do
        fn(host, store)
    end
end

function module.bind(moduleData)
    data = moduleData
    return module
end

return module
