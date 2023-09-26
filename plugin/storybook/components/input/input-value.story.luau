local story = require(script.Parent.Parent.Parent.story)
local vide = require(script.Parent.Parent.Parent.Parent.packages.vide)

local input = require(script.Parent.Parent.Parent.Parent.ui.components.input)

local create = vide.create
local source = vide.source

local function InputValue()
    local value = source("Reactive Value Demo")

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        input {
            Size = UDim2.fromScale(1, 0.25),
            Value = value,
        },

        create("TextLabel") {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 0.5),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 45,
            Text = value,
        },
    }
end

return story(InputValue)
