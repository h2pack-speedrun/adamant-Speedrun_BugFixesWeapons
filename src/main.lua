local mods = rom.mods
mods["SGG_Modding-ENVY"].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods["SGG_Modding-ModUtil"]
local chalk = mods["SGG_Modding-Chalk"]
local reload = mods["SGG_Modding-ReLoad"]
---@module "adamant-ModpackLib"
---@type AdamantModpackLib
lib = mods["adamant-ModpackLib"]

local config = chalk.auto("config.lua")

local PACK_ID = "speedrun"
local MODULE_ID = "BugFixesWeapons"
local PLUGIN_GUID = _PLUGIN.guid

---@class BugFixesWeaponsModuleAnchor
---@field standaloneUi StandaloneRuntime|nil
MODULE_ANCHOR = MODULE_ANCHOR or {}
---@type BugFixesWeaponsModuleAnchor
local moduleAnchor = MODULE_ANCHOR

moduleAnchor.standaloneUi = nil

local function registerGui()
    rom.gui.add_imgui(function()
        if moduleAnchor.standaloneUi and moduleAnchor.standaloneUi.renderWindow then
            moduleAnchor.standaloneUi.renderWindow()
        end
    end)

    rom.gui.add_to_menu_bar(function()
        if moduleAnchor.standaloneUi and moduleAnchor.standaloneUi.addMenuBar then
            moduleAnchor.standaloneUi.addMenuBar()
        end
    end)
end

local function init()
    import_as_fallback(rom.game)

    local data = import("data.lua")
    local logic = import("logic.lua").bind(data)
    local ui = import("ui.lua").bind(data)

    local host = lib.tryCreateModule({
        owner = moduleAnchor,
        pluginGuid = PLUGIN_GUID,
        config = config,
        definition = {
            modpack = PACK_ID,
            id = MODULE_ID,
            name = "Bug Fixes: Weapons",
            tooltip = "Weapon-related fixes for speedrun consistency.",
            storage = data.buildStorage(),
        },
        registerPatchMutation = logic.buildPatchPlan,
        registerHooks = logic.registerHooks,
        drawTab = ui.drawTab,
    })

    if not host then
        return
    end

    local ok = host.tryActivate()
    if not ok then
        return
    end

    moduleAnchor.standaloneUi = lib.standaloneHost(PLUGIN_GUID)
end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(registerGui, init)
end)
