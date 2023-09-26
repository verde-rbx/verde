local story = require(script.Parent.Parent.Parent.story)
local theme = require(script.Parent.Parent.Parent.Parent.theme)

local button = require(script.Parent.Parent.Parent.Parent.ui.components.button)

return story(button, {
    Activated = function() end,
    BackgroundColor3 = theme.MainButton,
    Icon = {
        Image = "rbxassetid://10747384394",
        ImageColor3 = theme.Mid,
    },
    Layout = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
    },
})
