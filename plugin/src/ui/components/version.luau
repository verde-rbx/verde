local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

return function(_props)
    return create("TextLabel") {
        BackgroundTransparency = 1,
        Name = "VerdeVersion",
        Text = store.get("VERSION"),
        TextColor3 = theme.DimmedText,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Top,
        _props,
    }
end :: types.Component<{}>
