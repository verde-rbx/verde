local story = require(script.Parent.Parent.Parent.story)
local theme = require(script.Parent.Parent.Parent.Parent.theme)

local input_group = require(script.Parent.Parent.Parent.Parent.ui.components.input_group)

return story(input_group, {
    Inputs = {
        {
            Component = "Input",
            Width = "*",
        },
        {
            Component = "Button",
            Activated = function() end,
            BackgroundColor3 = theme.MainButton,
            Width = "*",
        },
    },
    Layout = {
        LayoutOrder = 1,
        Size = UDim2.fromScale(0.75, 0.25),
    },
    Overlay = {

        Enabled = false,
    },
})
