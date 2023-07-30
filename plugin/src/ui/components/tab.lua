local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

export type TabButtonProps = {
	Panel: {
		icon: string,
		panel: string,
	},
}

return function(_props)
	return New("TextButton") {
		Name = _props.Panel.panel,
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		TextTransparency = 1,

		[OnEvent("Activated")] = function()
			Store.set("CurrentMenu", _props.Panel.panel)
		end,

		[Children] = {
			New("UIStroke") {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.MainBackground,
				Name = "AppliedStroke",
			},

			-- Icon
			New("ImageLabel") {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = _props.Panel.icon,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),
			},
		},
	}
end :: Types.Component<TabButtonProps>
