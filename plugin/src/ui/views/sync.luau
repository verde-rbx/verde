local session = require(script.Parent.Parent.Parent.session)
local store = require(script.Parent.Parent.Parent.store)
--local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local button = require(script.Parent.Parent.components.button)
local input = require(script.Parent.Parent.components.input)

local changed = vide.changed
local create = vide.create
local source = vide.source

return function()
    local activeView: vide.Source<string?> = store.get("ActiveView")
    local title: vide.Source<string?> = store.get("Title")
    title("Verde")

    local connectString = source("localhost:3000")
    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        create("UIListLayout") {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
        },

        input {
            Text = connectString,
            changed("Text", function(a0: string)
                connectString(a0)
            end),
        },

        -- Connect button
        button {
            Text = "Connect",
            Activated = function()
                local result = session.start(connectString())
                if result.message then
                    store.shift(
                        "Toasts",
                        {
                            Message = result.message,
                            Severity = if result.success then "Info" else "Error",
                        } :: types.Toast
                    )
                end
            end,
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
