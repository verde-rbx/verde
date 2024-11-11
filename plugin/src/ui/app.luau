local store = require(script.Parent.Parent.store)
local theme = require(script.Parent.Parent.theme)
local vide = require(script.Parent.Parent.packages.vide)

local settingsView = require(script.Parent.views.settings)
local syncView = require(script.Parent.views.sync)

local icon = require(script.Parent.components.icon)
local version = require(script.Parent.components.version)

local create = vide.create
local switch = vide.switch

--[[
    The verde widget.
]]
return function()
    local activeView: vide.Source<string?> = store.get("ActiveView")
    local title: vide.Source<string?> = store.get("Title")

    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),

        create("UIListLayout") {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        },

        create("UIPadding") {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
        },

        -- Header
        create("Frame") {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0.25),

            create("UIListLayout") {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalFlex = Enum.UIFlexAlignment.SpaceBetween,
            },

            icon {
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.1),
                Size = UDim2.fromScale(0.6, 0.55),
            },

            create("Frame") {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(99, 99, 99),
                Position = UDim2.fromScale(0.5, 0.75),
                Size = UDim2.new(0.3, 0, 0, 1),
            },

            -- Title
            create("TextLabel") {
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                FontFace = Font.new("Source Sans Pro", Enum.FontWeight.SemiBold),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.new(1, 150, 0, 25),
                Text = title,
                TextColor3 = theme.DimmedText,
                TextSize = 30,
            },
        },

        -- Content
        create("Frame") {
            BackgroundTransparency = 1,
            Size = UDim2.new(0.75, 0, 0.75, -14),

            create("UIPadding") {
                PaddingBottom = UDim.new(0, 15),
                PaddingTop = UDim.new(0, 30),
            },

            -- Display active view
            switch(activeView) {
                sync = syncView,
                settings = settingsView,
            },
        },

        -- Footer
        version {
            Size = UDim2.new(1, 0, 0, 14),
        },
    }
end
