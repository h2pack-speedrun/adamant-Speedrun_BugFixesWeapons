local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
chalk = mods['SGG_Modding-Chalk']
reload = mods['SGG_Modding-ReLoad']
lib = rom.mods['adamant-ModpackLib']
local config = chalk.auto('config.lua')

BugFixesWeaponsInternal = BugFixesWeaponsInternal or {}
local internal = BugFixesWeaponsInternal

-- Behavior registration tables — populated by each behaviors/*.lua file via import().
-- Each behavior file may append to any of these independently:
--   patch_fns : sequence of { key=string, fn=function(plan) } — called on patchPlan, gated on store values
--   hook_fns  : sequence of functions                    — called once on load to register hooks
--   option_fns: sequence of option descriptors           — drives the Framework UI options list
internal.patch_fns = internal.patch_fns or {}
internal.hook_fns = internal.hook_fns or {}
internal.option_fns = internal.option_fns or {}

local PACK_ID = "speedrun"

import 'behaviors/ExtraDoseFix.lua'
import 'behaviors/SeleneFix.lua'
import 'behaviors/StagedOmegaFix.lua'
import 'behaviors/TidalRingFix.lua'

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    modpack      = PACK_ID,
    id           = "BugFixesWeapons",
    name         = "Bug Fixes: Weapons & Attacks",
    category     = "Bug Fixes",
    group        = "Weapons & Attacks",
    tooltip      = "Collection of bug fixes for weapons and attacks.",
    default      = true,
    affectsRunData = true,
    options      = internal.option_fns,
}

public.store = lib.createStore(config, public.definition)
store = public.store

-- =============================================================================
-- MODULE LOGIC
-- =============================================================================

local function buildPatchPlan(plan)
    for _, b in ipairs(internal.patch_fns) do
        if store.read(b.key) and b.fn then b.fn(plan) end
    end
end

local function registerHooks()
    for _, fn in ipairs(internal.hook_fns) do fn() end
end

-- =============================================================================
-- Wiring
-- =============================================================================

public.definition.patchPlan = buildPatchPlan

local loader = reload.auto_single()

local function init()
    import_as_fallback(rom.game)
    registerHooks()
    if lib.isEnabled(store, public.definition.modpack) then
        lib.applyDefinition(public.definition, store)
    end
    if public.definition.affectsRunData and not lib.isCoordinated(public.definition.modpack) then
        SetupRunData()
    end
end

modutil.once_loaded.game(function()
    loader.load(init, init)
end)

local uiCallback = lib.standaloneUI(public.definition, store)
---@diagnostic disable-next-line: redundant-parameter
rom.gui.add_to_menu_bar(uiCallback)

