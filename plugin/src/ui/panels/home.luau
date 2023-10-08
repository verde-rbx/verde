local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local input_group = require(script.Parent.Parent.components.input_group)

local create = vide.create

return function()
    return create("Frame") {
        BackgroundTransparency = 1,
        Name = "Home",
        Size = UDim2.fromScale(1, 1),

        create("Frame") {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Name = "Controls",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0.5, 0, 0, 45),

            input_group {
                Overlay = {
                    Enabled = false,
                },
                Layout = {
                    LayoutOrder = 1,
                    Size = UDim2.new(0, 250, 1, 0),
                },
                Inputs = {
                    {
                        Component = "Input" :: "Input",
                        Width = "*" :: "*",
                        Value = store.get("HOST") :: () -> string,
                        Layout = {
                            TextSize = 20,
                        },
                    },

                    {
                        Component = "Input" :: "Input",
                        Width = "*" :: "*",
                        Value = store.get("PORT") :: () -> string,
                        Layout = {
                            TextSize = 20,
                        },
                    },

                    {
                        Component = "Button" :: "Button",
                        BackgroundColor3 = theme.MainButton,
                        Activated = function()
                            print("attempt connect")
                        end,
                    },
                },
            },

            create("UIListLayout") {
                Padding = UDim.new(0, 5),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            },
        },
    }
end
