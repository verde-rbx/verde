local Fusion = require(script.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.store)

local New = Fusion.New
local Children = Fusion.Children

local Input = require(script.Parent.components.input)

return function(_widget: DockWidgetPluginGui)
	return New("Frame") {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = Store.get("UIShown"),
		Parent = _widget,

		[Children] = {
			Input {},
		},
	}
end
