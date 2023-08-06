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
	Overlay: {
		Anchor: "left" | "right"?,
		Color: Fusion.CanBeState<Color3>?,
		Offset: number,
		Text: Fusion.CanBeState<string>?,
		TextColor: Fusion.CanBeState<string>?,
		Width: Fusion.CanBeState<number>?,
		UseOverlay: boolean,
	}?,
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

	-- Creating Inputs
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

	-- Handling Overlay
	_props.Overlay = _props.Overlay or { UseOverlay = false }
	local overlayAnchor = Computed(function()
		local anchorX = if _props.Overlay.Anchor then if _props.Overlay.Anchor == "left" then 0 else 1 else 0
		return Vector2.new(anchorX, 0.5)
	end)

	local overlaySize = Computed(function()
		local width = if _props.Overlay.Width then _props.Overlay.Width else 0
		width = if typeof(width) == "table" then width:get() else width
		return UDim2.fromScale(width, 1)
	end)

	local overlayBackground = Computed(function()
		if _props.Overlay.Color then
			if typeof(_props.Overlay.Color) == "table" then
				local theme = Theme[_props.Overlay.Color:get()]
				return if theme then theme:get() else Theme.MainBackground:get()
			else
				return _props.Overlay.Color
			end
		else
			return Color3.fromRGB(150, 210, 137)
		end
	end)

	local overlayTextColor = Computed(function()
		if _props.Overlay.Color then
			if typeof(_props.Overlay.TextColor) == "table" then
				return Theme[_props.Overlay.TextColor:get()]:get()
			else
				return _props.Overlay.TextColor
			end
		else
			return Theme.Light:get()
		end
	end)

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

			-- Overlay Swipe
			New("Frame") {
				AnchorPoint = overlayAnchor,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Position = UDim2.fromScale(overlayAnchor:get().X - (_props.Overlay.Offset or 0), 0.5),
				Size = Tween(overlaySize, TweenInfo.new(0.25)),
				Visible = _props.Overlay.UseOverlay,

				[Children] = {
					New("TextLabel") {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						FontSize = 10,
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = _props.Overlay.Text,
						TextColor3 = overlayTextColor,
						Visible = _props.Overlay.Text ~= nil,
						ZIndex = 3,
					},

					New("Frame") {
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = overlayBackground,
						Name = "Progress",
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 5, 1, 0),
						ZIndex = 2,

						[Children] = {
							New("UICorner") {
								CornerRadius = UDim.new(0, 8),
							},
						},
					},
				},
			},

			-- Contents
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

					-- Input Elements
					inputs,
				},
			},
		},
	}
end :: Types.Component<InputGroupProps>
