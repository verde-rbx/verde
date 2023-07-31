local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children

local Button = require(script.Parent.Parent.components.button)
local InputGroup = require(script.Parent.Parent.components.input_group)

return function()
	return New("Frame") {
		BackgroundTransparency = 1,
		Name = "Home",
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			-- Main Sync Controls
			New("Frame") {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Name = "Controls",
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0.5, 0, 0, 45),

				[Children] = {
					New("UIListLayout") {
						Padding = UDim.new(0, 5),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					},

					InputGroup {
						Inputs = {
							-- Host
							{
								LayoutOrder = 1,
								Size = UDim2.fromScale(0.7, 1),
							},

							-- Separator
							{
								LayoutOrder = 2,
								Readonly = true,
								Size = UDim2.fromScale(0.05, 1),
								TextSize = 20,
								Value = ":",
							},

							-- Port
							{
								LayoutOrder = 3,
								Size = UDim2.fromScale(0.25, 1),
							},
						},
						LayoutOrder = 1,
						Size = UDim2.new(0, 200, 1, 0),
					},

					-- Action
					Button {
						Icon = "rbxassetid://10709768538",
						LayoutOrder = 2,
					},
				},
			},
		},
	}
end :: Types.Panel
