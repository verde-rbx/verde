local Fusion = require(script.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.store)
local Theme = require(script.Parent.Parent.theme)
local Types = require(script.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local ForValues = Fusion.ForValues

local Panels = script.Parent.panels
local Logo = require(script.Parent.components.logo)
local Tab = require(script.Parent.components.tab)
local Version = require(script.Parent.components.version)

local PanelMapping = {
	{
		icon = "rbxassetid://10734940825",
		panel = "home",
	},
	{
		icon = "rbxassetid://10734950309",
		panel = "settings",
	},
}

return function(_widget: DockWidgetPluginGui)
	-- Create panel tab buttons based on panel mappings
	local panelBtns = ForValues(PanelMapping, function(_panel)
		return Tab {
			Panel = _panel,
		}
	end, Fusion.cleanup)

	-- Select the chosen panel to display based on active tab
	local chosenPanel = Computed(function()
		local activePanel = Store.getValue("CurrentMenu") :: Types.Menus

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

					New("UIStroke") {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Theme.Separator,
					},

					-- Left: Tabs
					New("Frame") {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							New("UIListLayout") {
								FillDirection = Enum.FillDirection.Horizontal,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 2),
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
					New("UIPadding") {
						PaddingBottom = UDim.new(0, 25),
						PaddingLeft = UDim.new(0, 25),
						PaddingRight = UDim.new(0, 25),
						PaddingTop = UDim.new(0, 25),
					},

					chosenPanel,
				},
			},

			-- Version Text
			Version {},
		},
	}
end
