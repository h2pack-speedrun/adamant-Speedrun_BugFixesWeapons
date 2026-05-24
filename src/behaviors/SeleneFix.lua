return {
    option = {
        type = "checkbox",
        alias = "SeleneFix",
        label = "Aspect of Selene Fix",
        default = true,
        tooltip =
        "Aspect of Selene properly registers its hex so you get offered PoS directly. Skyfall is full moonglow."
    },
    patches = {
        {
            key = "SeleneFix",
            fn = function(plan)
                local seleneReq = {
                    PathFalse = { "CurrentRun", "Hero", "TraitDictionary", "SuitHexAspect" }
                }
                plan:appendUnique(NamedRequirementsData, "SpellDropRequirements", seleneReq)
            end
        },
    },
    hooks = {
        function(host, store)
            host.hooks.wrap("StartNewRun", function(baseFunc, prevRun, args)
                if not store.read("SeleneFix") or not host.isEnabled() then
                    return baseFunc(prevRun, args)
                end
                local currentRun = baseFunc(prevRun, args)
                if HeroHasTrait("SuitHexAspect") then
                    RecordUse(nil, "SpellDrop")
                end
                return currentRun
            end)

            host.hooks.wrap("SpawnRoomReward", function(baseFunc, eventSource, args)
                if not store.read("SeleneFix") or not host.isEnabled() then
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
        end,
    },
}
