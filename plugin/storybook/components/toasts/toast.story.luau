local story = require(script.Parent.Parent.Parent.story)

local toast = require(script.Parent.Parent.Parent.Parent.ui.components.toast)

return story(toast, {
    Message = "Hello world, this is an example toast.",
    Lifetime = 5,
    Index = function()
        return 1
    end,
})
