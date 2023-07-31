local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Children = Fusion.Children

export type TabButtonProps = {
	Panel: {
		icon: string,
		panel: string,
	},
}

return function(_props)
	local showStroke = Computed(function()
		local activePanel = Store.getValue("CurrentMenu") :: Types.Menus
		return activePanel == _props.Panel.panel
	end)

	local backgroundColor = Computed(function()
		local activePanel = Store.getValue("CurrentMenu") :: Types.Menus
		return if activePanel == _props.Panel.panel then Theme.MainBackground:get() else Theme.Titlebar:get()
	end)

	return New("TextButton") {
		BackgroundColor3 = backgroundColor,
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
				Enabled = showStroke,
			},

			-- Icon
			New("ImageLabel") {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = _props.Panel.icon,
				ImageColor3 = Theme.MainText,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),

				[Children] = {
					New("Frame") {
						BackgroundTransparency = 1,

						[Children] = {
							New("UIStroke") {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Color = Theme.MainBackground,
								Enabled = showStroke,
							},
						},
					},
				},
			},
		},
	}
end :: Types.Component<TabButtonProps>
