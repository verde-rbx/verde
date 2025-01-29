local story = require(script.Parent.Parent.util)

local icon = require(script.Parent.Parent.Parent.ui.components.icon)

return story(icon, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
})
