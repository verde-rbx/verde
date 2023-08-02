local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New

return function(_props)
	return New("ImageLabel") {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://14245986258",
		Name = "VerdeIcon",
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
	}
end :: Types.Component<{}>
