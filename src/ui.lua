local module = {}
local data = nil

local function DrawOptions(draw, state)
    for _, option in ipairs(data.options) do
        if option.type == "checkbox" then
            draw.widgets.checkbox(state.get(option.alias), {
                label = option.label,
                tooltip = option.tooltip,
            })
        end
    end
end

function module.drawTab(draw, state)
    DrawOptions(draw, state)
end

function module.bind(moduleData)
    data = moduleData
    return module
end

return module
