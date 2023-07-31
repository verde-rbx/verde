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
	Location: ("left" | "middle" | "right" | "all")?,
	Size: UDim2?,
}

return function(_props)
	local isPressed = Value(false)
	local buttonColor = Computed(function()
		if isPressed:get() then
			return Theme.ButtonPressed:get()
		end

		return Theme.Button:get()
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
				BackgroundColor3 = buttonColor,
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

				[Children] = {
					New("UICorner") {
						CornerRadius = UDim.new(0, 10),
					},

					New("ImageLabel") {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = _props.Icon,
						ImageColor3 = Theme.MainText,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.6, 0.6),
					},
				},
			},
		},
	}
end :: Types.Component<ButtonProps>
