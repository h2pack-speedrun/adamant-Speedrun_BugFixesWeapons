-- luacheck: globals lib
local module = {}
local data = nil

local function DrawOptions(ui, uiState)
    for _, option in ipairs(data.options) do
        if option.type == "checkbox" then
            lib.widgets.checkbox(ui, uiState, option.alias, {
                label = option.label,
                tooltip = option.tooltip,
            })
        end
    end
end

function module.drawTab(ui, uiState)
    DrawOptions(ui, uiState)
end

function module.bind(moduleData)
    data = moduleData
    return module
end

return module
