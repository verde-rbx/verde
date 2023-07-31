local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Tween = Fusion.Tween
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

export type ButtonProps = {
	Activated: () -> ()?,
	Color: Fusion.CanBeState<string>?,
	Icon: Fusion.CanBeState<string>,
	LayoutOrder: number,
	Location: ("left" | "middle" | "right" | "all")?,
	Rotation: Fusion.CanBeState<number>?,
	Size: UDim2?,
	TextColor: Fusion.CanBeState<string>?,
}

local ColorTween = TweenInfo.new(0.25)

return function(_props)
	local baseColor = if not _props.Color or typeof(_props.Color) == "string"
		then Value(_props.Color or "MainButton")
		else _props.Color

	local baseTextColor = if not _props.TextColor or typeof(_props.TextColor) == "string"
		then Value(_props.TextColor or "MainText")
		else _props.TextColor

	local textColor = Computed(function()
		return Theme[baseTextColor:get()]:get()
	end)

	local isPressed = Value(false)
	local buttonColor = Computed(function()
		if isPressed:get() then
			return Theme[`{baseColor:get()}Pressed`]:get()
		end

		return Theme[baseColor:get()]:get()
	end)

	-- Calculate roundness from position
	local xOffset = 0
	if _props.Location == "left" or _props.Location == "right" then
		xOffset = 5
	elseif _props.Location == "middle" then
		xOffset = 10
	end

	local xAnchor = 0.5
	if _props.Location == "left" then
		xAnchor = 0
	elseif _props.Location == "right" then
		xAnchor = 1
	end

	return New("Frame") {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = _props.LayoutOrder,
		Size = _props.Size or UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,

		[Children] = {
			New("TextButton") {
				AnchorPoint = Vector2.new(xAnchor, 0.5),
				BackgroundColor3 = Tween(buttonColor, ColorTween),
				Position = UDim2.fromScale(xAnchor, 0.5),
				Text = "",
				TextTransparency = 1,
				Size = UDim2.new(1, xOffset, 1, 0),

				[OnEvent("MouseButton1Down")] = function()
					isPressed:set(true)
				end,

				[OnEvent("MouseButton1Up")] = function()
					isPressed:set(false)
				end,

				[OnEvent("Activated")] = function()
					if _props.Activated then
						_props.Activated()
					end
				end,

				[Children] = {
					New("UICorner") {},

					New("ImageLabel") {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = _props.Icon,
						ImageColor3 = Tween(textColor, ColorTween),
						Position = UDim2.fromScale(0.5, 0.5),
						Rotation = _props.Rotation,
						Size = UDim2.fromScale(0.6, 0.6),
					},
				},
			},
		},
	}
end :: Types.Component<ButtonProps>
