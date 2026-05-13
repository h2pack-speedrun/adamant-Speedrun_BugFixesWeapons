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

---@class BugFixesWeaponsInternal
---@field store ManagedStore|nil
---@field standaloneUi StandaloneRuntime|nil
---@field PACK_ID string|nil
---@field MODULE_ID string|nil
---@field BuildStorage fun(): StorageSchema|nil
---@field BuildPatchPlan fun(plan: MutationPlan, host: AuthorHost, store: ManagedStore)|nil
---@field RegisterHooks fun(host: AuthorHost, store: ManagedStore)|nil
---@field DrawTab fun(imgui: table, session: AuthorSession, host: AuthorHost)|nil
BugFixesWeaponsInternal = BugFixesWeaponsInternal or {}
---@type BugFixesWeaponsInternal
local internal = BugFixesWeaponsInternal

internal.PACK_ID = PACK_ID
internal.MODULE_ID = MODULE_ID

internal.standaloneUi = nil

local function registerGui()
    rom.gui.add_imgui(function()
        if internal.standaloneUi and internal.standaloneUi.renderWindow then
            internal.standaloneUi.renderWindow()
        end
    end)

    rom.gui.add_to_menu_bar(function()
        if internal.standaloneUi and internal.standaloneUi.addMenuBar then
            internal.standaloneUi.addMenuBar()
        end
    end)
end

local function init()
    import_as_fallback(rom.game)

    import("data.lua")
    import("logic.lua")
    import("ui.lua")

    local host, store = lib.createModule({
        owner = internal,
        pluginGuid = PLUGIN_GUID,
        config = config,
        definition = {
            modpack = PACK_ID,
            id = MODULE_ID,
            name = "Bug Fixes: Weapons",
            tooltip = "Weapon-related fixes for speedrun consistency.",
            storage = internal.BuildStorage(),
        },
        registerPatchMutation = internal.BuildPatchPlan,
        registerHooks = internal.RegisterHooks,
        drawTab = internal.DrawTab,
    })
    internal.store = store

    host.activate()
    internal.standaloneUi = lib.standaloneHost(PLUGIN_GUID)
end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(registerGui, init)
end)
