local input = require(script.Parent.Parent.Parent.Parent.ui.components.input)
local story = require(script.Parent.Parent.Parent.story)

return story(input, {
    Size = UDim2.fromScale(1, 0.5),
})
