local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New

return function(_props)
	return New("ImageLabel") {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://14245984416",
		Name = "VerdeLogo",
		Position = UDim2.fromScale(1, 0),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.new(1, 15, 1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
	}
end :: Types.Component<{}>
