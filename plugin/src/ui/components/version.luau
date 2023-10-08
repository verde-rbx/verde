local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

return function(_props)
    return create("TextLabel") {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Name = "VerdeVersion",
        Position = UDim2.new(0, 5, 1, -5),
        Size = UDim2.fromOffset(100, 45),
        Text = store.get("VERSION"),
        TextColor3 = theme.DimmedText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
    }
end :: types.Component<{}>
