local Fusion = require(script.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.store)
local Types = require(script.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local ForValues = Fusion.ForValues
local OnEvent = Fusion.OnEvent

local Panels = script.Parent.panels
local Logo = require(script.Parent.components.logo)

return function(_widget: DockWidgetPluginGui)
	local panelBtns = ForValues(Panels:GetChildren(), function(_moduleName: ModuleScript)
		return New("TextButton") {
			Name = _moduleName.Name,
			Size = UDim2.fromScale(0.15, 1),
			Text = _moduleName.Name,
			[OnEvent("Activated")] = function()
				Store.set("CurrentMenu", _moduleName.Name)
			end,
		}
	end, Fusion.cleanup)

	local chosenPanel = Computed(function()
		local activePanel = Store.getValue("CurrentMenu") :: Types.Menus
		if not activePanel then
			return
		end

		local chosenPanel = Panels:FindFirstChild(activePanel)
		if not chosenPanel then
			return
		end

		return require(chosenPanel)()
	end, Fusion.cleanup)

	return New("Frame") {
		BackgroundTransparency = 0,
		Parent = _widget,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			-- Topbar
			New("Frame") {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- DEBUG REMOVE
				Size = UDim2.new(1, 0, 0, 75),

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
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(0, 255, 0), -- DEBUG REMOVE
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 1, -75),

				[Children] = {
					chosenPanel,
				},
			},
		},
	}
end
