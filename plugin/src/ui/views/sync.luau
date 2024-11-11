local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

local button = require(script.Parent.Parent.components.button)
local input = require(script.Parent.Parent.components.input)

return function()
    local activeView: vide.Source<string?> = store.get("ActiveView")
    local title: vide.Source<string?> = store.get("Title")
    title("Verde")

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        create("UIListLayout") {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        },

        input {},

        -- Connect button
        button {
            Text = "Connect",
        },

        -- Settings view
        button {
            Text = "Settings",
            Activated = function()
                activeView("settings")
            end,
        },
    }
end
