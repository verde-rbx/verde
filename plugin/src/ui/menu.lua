local Fusion = require(script.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.store)
local Theme = require(script.Parent.Parent.theme)
local Types = require(script.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent

local Panels = script.Parent.panels
local Logo = require(script.Parent.components.logo)
local Version = require(script.Parent.components.version)

local PanelMapping = {
	{
		icon = "rbxassetid://",
		panel = "home",
	},
	{
		icon = "rbxassetid://",
		panel = "settings",
	},
}

return function(_widget: DockWidgetPluginGui)
	local panelBtns = ForValues(PanelMapping, function(_panel)
		return New("TextButton") {
			Name = _panel.panel,
			Size = UDim2.fromScale(0.15, 1),
			Text = _panel.panel,
			TextColor3 = Theme.MainText,

			[OnEvent("Activated")] = function()
				Store.set("CurrentMenu", _panel.panel)
			end,
		}
	end, Fusion.cleanup)

	local chosenPanel = Computed(function()
		local activePanel = Store.getValue("CurrentMenu") :: Types.Menus

		-- Update tab button colours
		for _, btn in panelBtns:get() do
			btn.BackgroundColor3 = if btn.Name == activePanel then Theme.MainBackground:get() else Theme.Tab:get()
		end

		-- Check if active panel is set
		if not activePanel then
			return
		end

		-- Check if panel exists
		local chosenPanel = Panels:FindFirstChild(activePanel)
		if not chosenPanel then
			return
		end

		return require(chosenPanel)()
	end, Fusion.cleanup)

	return New("Frame") {
		BackgroundTransparency = 1,
		Parent = _widget,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			-- Topbar
			New("Frame") {
				BackgroundColor3 = Theme.Titlebar,
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 0, 40),

				[Children] = {
					New("UIPadding") {
						PaddingLeft = UDim.new(0, 5),
						PaddingRight = UDim.new(0, 5),
					},

					-- Left: Tabs
					New("Frame") {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							New("UIListLayout") {
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 15),
							},

							-- Buttons
							panelBtns,
						},
					},

					-- Right: Logo
					Logo {},
				},
			},

			-- Layout
			New("Frame") {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 1, -40),

				[Children] = {
					chosenPanel,
				},
			},

			-- Version Text
			Version {},
		},
	}
end
