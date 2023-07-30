local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New

return function(_props)
	return New("TextLabel") {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Name = "VerdeVersion",
		Position = UDim2.new(0, 5, 1, -5),
		Size = UDim2.fromOffset(100, 45),
		Text = Store.get("VERSION"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
	}
end :: Types.Component<{}>
