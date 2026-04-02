table.insert(option_fns,
    {
        type = "checkbox",
        configKey = "ExtraDoseFix",
        label = "Extra Dose Fix",
        default = true,
        tooltip =
        "Fixes Extra Dose interaction with Coat 2nd punch and Dash strike."
    })
table.insert(patch_fns, {
    key = "ExtraDoseFix",
    fn = function(plan)
        if not TraitData.DoubleStrikeChanceBoon then return end
        local propertyChanges = TraitData.DoubleStrikeChanceBoon.PropertyChanges
        plan:appendUnique(propertyChanges[1], "WeaponNames", "WeaponSuit2")
        plan:appendUnique(propertyChanges[1], "WeaponNames", "WeaponSuitDash")
        plan:appendUnique(propertyChanges[4], "WeaponNames", "WeaponSuit2")
        plan:appendUnique(propertyChanges[4], "WeaponNames", "WeaponSuitDash")
    end
})
