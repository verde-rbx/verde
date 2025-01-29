local store = require(script.Parent.Parent.Parent.Parent.store)
local story = require(script.Parent.Parent.Parent.story)
local types = require(script.Parent.Parent.Parent.Parent.types)

local toasts = require(script.Parent.Parent.Parent.Parent.ui.toasts)

local PHRASES = {
    "This is an example of a really, really, really, really, *really* long toast. As you can see it scales appropriately!!",
    "This is a toast example.",
    "Hello world! 👋 I am a toast.",
}

-- Add toasts for example
task.defer(function()
    for i = 0, 5 do
        store.add(
            "Toasts",
            {
                Message = `{PHRASES[Random.new():NextInteger(1, #PHRASES)]} #{i}`,
                Lifetime = Random.new():NextInteger(5, 10),
            } :: types.Toast,
            1
        )
        task.wait(0.5)
    end

    -- Add long toast
    store.add(
        "Toasts",
        {
            Message = "I last a loooooooooong time.",
            Lifetime = 60,
        } :: types.Toast,
        1
    )

    -- Add permanent toast
    store.add(
        "Toasts",
        {
            Message = "Just like microplastics, I last forever.",
            Lifetime = 0,
        } :: types.Toast,
        1
    )
end)

return story(toasts, {})
