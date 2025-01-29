local store = require(script.Parent.Parent.Parent.store)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

return function()
    local title: vide.Source<string?> = store.get("Title")
    title("Settings")

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        create("UIListLayout") {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        },
    }
end
