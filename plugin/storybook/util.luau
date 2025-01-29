--[[
Base for a story item
]]

local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)
vide.strict = true

local create = vide.create
local mount = vide.mount

return function<T>(_component: types.Component<T>, _properties: T)
    local createComponent = function()
        local component = _component(_properties or ({} :: any))
        if component.ClassName == "ScreenGui" then
            component = component:GetChildren()[1]
        end

        return create("Frame") {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.5, 0.5),

            component,
        }
    end

    -- Create function
    return function(_target: Instance)
        return mount(createComponent, _target)
    end
end
