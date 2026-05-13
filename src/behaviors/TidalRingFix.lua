return {
    option = {
        type = "checkbox",
        alias = "TidalRingFix",
        label = "Tidal Ring Fix",
        default = true,
        tooltip =
        "Fixes Tidal Ring not hitting the same mob twice with Circe."
    },
    patches = {
        {
            key = "TidalRingFix",
            fn = function(plan)
                if not ProjectileData or not ProjectileData.PoseidonCastSplashSplinter then return end
                plan:set(ProjectileData.PoseidonCastSplashSplinter, "ImmunityDuration", 0)
            end
        },
    },
}
