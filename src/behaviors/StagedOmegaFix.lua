return {
    option = {
        type = "checkbox",
        alias = "StagedOmegaFix",
        label = "Axe and Blade Omega Channel Fix",
        default = true,
        tooltip =
        "Fixes Axe OAtk, Blade OSpec not benefiting correctly from channeling bonus."
    },
    patches = {
        {
            key = "StagedOmegaFix",
            fn = function(plan)
                plan:set(WeaponData.WeaponDaggerThrow, "MinWeaponChargeTime", 0.05)
                plan:set(WeaponData.WeaponAxeSpin, "MinWeaponChargeTime", 0.05)
            end
        },
    },
}
