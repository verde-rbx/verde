local store = require(script.Parent.Parent.Parent.Parent.store)
local story = require(script.Parent.Parent.Parent.story)
local types = require(script.Parent.Parent.Parent.Parent.types)

local toasts = require(script.Parent.Parent.Parent.Parent.ui.toasts)

-- Add toasts for example
task.defer(function()
    for i = 0, 5 do
        store.add("Toasts", {
            Message = `Toast example #{i}`,
            Lifetime = 5,
        } :: types.Toast, 1)
        task.wait(0.5)
    end
end)

return story(toasts, {})
