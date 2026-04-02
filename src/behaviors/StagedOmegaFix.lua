local internal = BugFixesWeaponsInternal
local option_fns = internal.option_fns
local patch_fns = internal.patch_fns

table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "StagedOmegaFix",
        label = "Axe and Blade Omega Channel Fix",
        default = true,
        tooltip =
        "Fixes Axe OAtk, Blade OSpec not benefiting correctly from channeling bonus."
    })
table.insert(patch_fns, {
    key = "StagedOmegaFix",
    fn = function(plan)
        plan:set(WeaponData.WeaponDaggerThrow, "MinWeaponChargeTime", 0.05)
        plan:set(WeaponData.WeaponAxeSpin, "MinWeaponChargeTime", 0.05)
    end
})
