--[[
    Base for a story item
]]

local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)
vide.strict = true

local mount = vide.mount
local create = vide.create

return function<T>(_component: types.Component<T>, _properties: T)
    local createComponent = function()
        return create("Frame") {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.5, 0.5),

            _component(_properties or ({} :: any)),
        }
    end

    -- Create function
    return function(_target: Instance)
        return mount(createComponent, _target)
    end
end
