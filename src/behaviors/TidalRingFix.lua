table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "TidalRingFix",
        label = "Tidal Ring Fix",
        default = true,
        tooltip =
        "Fixes Tidal Ring not hitting the same mob twice with Circe."
    })
table.insert(patch_fns, {
    key = "TidalRingFix",
    fn = function(plan)
        if not ProjectileData or not ProjectileData.PoseidonCastSplashSplinter then return end
        plan:set(ProjectileData.PoseidonCastSplashSplinter, "ImmunityDuration", 0)
    end
})
