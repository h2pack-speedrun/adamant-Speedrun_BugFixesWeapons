local internal = BugFixesWeaponsInternal
local option_fns = internal.option_fns
local patch_fns = internal.patch_fns
local hook_fns = internal.hook_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "SeleneFix",
        label = "Aspect of Selene Fix",
        default = true,
        tooltip =
        "Aspect of Selene properly registers its hex so you get offered PoS directly. Skyfall is full moonglow."
    })

table.insert(patch_fns, {
    key = "SeleneFix",
    fn = function(plan)
        local seleneReq = {
            PathFalse = { "CurrentRun", "Hero", "TraitDictionary", "SuitHexAspect" }
        }
        plan:appendUnique(NamedRequirementsData, "SpellDropRequirements", seleneReq)
    end
})

table.insert(hook_fns, function()
    modutil.mod.Path.Wrap("StartNewRun", function(baseFunc, prevRun, args)
        if not store.read("SeleneFix") or not lib.isEnabled(store, public.definition.modpack) then
            return baseFunc(prevRun, args)
        end
        local currentRun = baseFunc(prevRun, args)
        if HeroHasTrait("SuitHexAspect") then
            RecordUse(nil, "SpellDrop")
        end
        return currentRun
    end)

    modutil.mod.Path.Wrap("SpawnRoomReward", function(baseFunc, eventSource, args)
        if not store.read("SeleneFix") or not lib.isEnabled(store, public.definition.modpack) then
            return baseFunc(eventSource, args)
        end
        if HeroHasTrait("SuitHexAspect") and HeroHasTrait("SpellTalentKeepsake") and game.CurrentRun.CurrentRoom.BiomeStartRoom then
            args = args or {}
            if args.WaitUntilPickup then
                args.RewardOverride = "TalentDrop"
                args.LootName = nil
            end
        end
        return baseFunc(eventSource, args)
    end)
end)
