local store = require(script.Parent.Parent.store)
local theme = require(script.Parent.Parent.theme)
local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)

local icon = require(script.Parent.components.icon)
local tab = require(script.Parent.components.tab)
local version = require(script.Parent.components.version)

local create = vide.create
local switch = vide.switch
local indexes = vide.indexes

local PANELS = script.Parent.panels

return function()
    local currentMenu = store.get("CurrentMenu") :: () -> types.Menus

    -- Create buttons
    local buttons = indexes(store.get("MENUS") :: () -> { [string]: string }, function(item, i)
        return tab {
            Panel = i,
            Icon = item(),
        }
    end)

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        -- Topbar
        create("Frame") {
            BackgroundColor3 = theme.Titlebar,
            Size = UDim2.new(1, 0, 0, 40),

            create("Frame") {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),

                buttons,

                create("UIListLayout") {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 2),
                },
            },

            icon {},

            create("UIStroke") {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = theme.Separator,
            },

            create("UIPadding") {
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
            },
        },

        -- Content
        create("Frame") {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 1, -40),

            switch(currentMenu) {
                ["home"] = require(PANELS.home),
                ["settings"] = require(PANELS.settings),
            },

            create("UIPadding") {
                PaddingBottom = UDim.new(0, 25),
                PaddingLeft = UDim.new(0, 25),
                PaddingRight = UDim.new(0, 25),
                PaddingTop = UDim.new(0, 25),
            },
        },

        version {},
    }
end
