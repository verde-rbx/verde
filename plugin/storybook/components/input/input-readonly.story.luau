local story = require(script.Parent.Parent.Parent.story)
local theme = require(script.Parent.Parent.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.Parent.packages.vide)

local button = require(script.Parent.Parent.Parent.Parent.ui.components.button)
local input = require(script.Parent.Parent.Parent.Parent.ui.components.input)

local create = vide.create
local source = vide.source

local function InputReadonly()
    local readonly = source(true)

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        input {
            Size = UDim2.fromScale(1, 0.25),
            Value = "Readonly input demo",
            Readonly = readonly,
        },

        button {
            Activated = function()
                readonly(not readonly())
            end,
            BackgroundColor3 = theme.Button,
            Layout = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 0.15),
            },
        },
    }
end

return story(InputReadonly, {})
