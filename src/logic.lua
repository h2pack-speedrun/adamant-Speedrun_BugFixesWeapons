-- luacheck: globals BugFixesWeaponsInternal
local internal = BugFixesWeaponsInternal

function internal.BuildPatchPlan(plan, _, store)
    for _, b in ipairs(internal.patch_fns) do
        if store.read(b.key) and b.fn then
            b.fn(plan)
        end
    end
end

function internal.RegisterHooks()
    for _, fn in ipairs(internal.hook_fns) do
        fn()
    end
end

return internal
