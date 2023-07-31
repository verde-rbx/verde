local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

export type ButtonProps = {
	Icon: string,
	LayoutOrder: number,
}

return function(_props)
	local isPressed = Value(false)
	local buttonColor = Computed(function()
		if isPressed:get() then
			return Theme.ButtonPressed:get()
		end

		return Theme.Button:get()
	end)

	return New("TextButton") {
		BackgroundColor3 = buttonColor,
		LayoutOrder = _props.LayoutOrder,
		Text = "",
		TextTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,

		[OnEvent("MouseButton1Down")] = function()
			isPressed:set(true)
		end,

		[OnEvent("MouseButton1Up")] = function()
			isPressed:set(false)
		end,

		[Children] = {
			New("UICorner") {
				CornerRadius = UDim.new(0, 15),
			},

			New("UIStroke") {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.Border,
			},

			New("ImageLabel") {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = _props.Icon,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.6, 0.6),
			},
		},
	}
end :: Types.Component<ButtonProps>
