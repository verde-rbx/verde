local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Tween = Fusion.Tween
local Computed = Fusion.Computed
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local Button = require(script.Parent.button)
local Input = require(script.Parent.input)

export type InputGroupProps = {
	Inputs: { (Input.InputProps | Button.ButtonProps) & { Component: ("Input" | "Button")? } },
	LayoutOrder: number,
	Size: UDim2,
}

local ColorTween = TweenInfo.new(0.25)

return function(_props)
	local isOutlined = Value(false)
	local outlineColor = Computed(function()
		if isOutlined:get() then
			return Theme.BorderSelected:get()
		else
			return Theme.Border:get()
		end
	end)

	local currentInput = 1
	local inputs = ForValues(_props.Inputs, function(_inputProps)
		local inputProps = _inputProps
		inputProps.IsSelected = isOutlined
		inputProps.Location = if currentInput <= 1
			then "left"
			elseif currentInput >= #_props.Inputs then "right"
			elseif currentInput > 1 and currentInput < #_props.Inputs then "middle"
			else "all"

		currentInput += 1
		return if inputProps.Component == "Button" then Button(inputProps) else Input(inputProps)
	end, Fusion.cleanup)

	return New("Frame") {
		BackgroundTransparency = 1,
		LayoutOrder = _props.LayoutOrder,
		Size = _props.Size,

		[Children] = {
			New("UIStroke") {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Tween(outlineColor, ColorTween),
			},

			New("UICorner") {
				CornerRadius = UDim.new(0, 6),
			},

			New("Frame") {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					New("UIListLayout") {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					},

					inputs,
				},
			},
		},
	}
end :: Types.Component<InputGroupProps>
