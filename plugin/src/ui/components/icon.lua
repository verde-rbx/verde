local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New

return function(_props)
	return New("ImageLabel") {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://14245986258",
		Name = "VerdeIcon",
		Position = UDim2.fromScale(0.98, 0),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromScale(0.3, 0.3),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
	}
end :: Types.Component<{}>
