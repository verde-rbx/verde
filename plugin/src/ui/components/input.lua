local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Tween = Fusion.Tween
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

export type InputProps = {
	IsSelected: Fusion.Value<boolean>?,
	LayoutOrder: number,
	Location: ("left" | "middle" | "right" | "all")?,
	Readonly: boolean?,
	Size: UDim2,
	TextSize: number?,
	Value: string?,
}

local ColorTween = TweenInfo.new(0.25)

return function(_props)
	local isOutlined = Value(false)
	local backgroundColor = Computed(function()
		if isOutlined:get() then
			return Theme.ButtonHover:get()
		else
			return Theme.ButtonDisabled:get()
		end
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

	-- Handling value
	local text = Value(_props.Value or "")

	return New("Frame") {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = _props.Size,

		[Children] = {
			if _props.Readonly
				then New("TextLabel") {
					AnchorPoint = Vector2.new(xAnchor, 0.5),
					BackgroundTransparency = 0,
					BackgroundColor3 = Tween(backgroundColor, ColorTween),
					Position = UDim2.fromScale(xAnchor, 0.5),
					Text = text,
					TextColor3 = Theme.SubText,
					TextScaled = not _props.TextSize,
					TextSize = _props.TextSize or 14,
					Size = UDim2.new(1, xOffset, 1, 0),

					[Children] = {
						New("UICorner") {},
					},
				}
				else New("TextBox") {
					AnchorPoint = Vector2.new(xAnchor, 0.5),
					BackgroundTransparency = 0,
					BackgroundColor3 = Tween(backgroundColor, ColorTween),
					Position = UDim2.fromScale(xAnchor, 0.5),
					Text = text,
					TextColor3 = Theme.MainText,
					Size = UDim2.new(1, xOffset, 1, 0),

					[OnEvent("Focused")] = function()
						if _props.Readonly then
							return
						end

						_props.IsSelected:set(true)
						isOutlined:set(true)
					end,

					[OnEvent("FocusLost")] = function()
						if _props.Readonly then
							return
						end

						_props.IsSelected:set(false)
						isOutlined:set(false)
					end,

					[Children] = {
						New("UICorner") {},
					},
				},
		},
	}
end :: Types.Component<InputProps>
