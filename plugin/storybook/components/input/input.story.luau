local story = require(script.Parent.Parent.Parent.story)

local input = require(script.Parent.Parent.Parent.Parent.ui.components.input)

return story(input, {
    Size = UDim2.fromScale(1, 0.25),
})
