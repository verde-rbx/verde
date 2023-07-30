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
		Size = UDim2.fromScale(0.25, 1),
		Text = _props.Panel.panel,
		TextColor3 = Theme.MainText,

		[OnEvent("Activated")] = function()
			Store.set("CurrentMenu", _props.Panel.panel)
		end,

		[Children] = {
			New("UIStroke") {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.MainBackground,
				Name = "AppliedStroke",
			},
		},
	}
end :: Types.Component<TabButtonProps>
