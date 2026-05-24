local module = {}
local data = nil
local checkboxOptsByAlias = {}

local function drawOptions(draw, state)
    for _, option in ipairs(data.options) do
        if option.type == "checkbox" then
            draw.widgets.checkbox(state.get(option.alias), checkboxOptsByAlias[option.alias])
        end
    end
end

function module.drawTab(draw, state)
    drawOptions(draw, state)
end

function module.bind(moduleData)
    data = moduleData
    checkboxOptsByAlias = {}
    for _, option in ipairs(data.options) do
        if option.type == "checkbox" then
            checkboxOptsByAlias[option.alias] = {
                label = option.label,
                tooltip = option.tooltip,
            }
        end
    end
    return module
end

return module
