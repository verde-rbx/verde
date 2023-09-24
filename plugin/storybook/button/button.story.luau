local button = require(script.Parent.Parent.Parent.ui.components.button)
local story = require(script.Parent.Parent.story)
local theme = require(script.Parent.Parent.Parent.theme)

return story(button, {
    Activated = function() end,
    BackgroundColor3 = theme.MainButton,
    Icon = {
        Image = "rbxassetid://10747384394",
        ImageColor3 = theme.Mid,
    },
})
