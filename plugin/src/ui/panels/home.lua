local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children

local InputGroup = require(script.Parent.Parent.components.input_group)

return function()
	local isConnected = Store.get("Connected", false)
	local connectIcon = Computed(function()
		return if isConnected:get() then "rbxassetid://10709768538" else "rbxassetid://10747384394"
	end)
	local connectColor = Computed(function()
		return if isConnected:get() then "MainButton" else "ErrorText"
	end)
	local connectTextColor = Computed(function()
		return if isConnected:get() then "MainText" else "Dark"
	end)

	local connectRotation = Value(0)

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
								Size = UDim2.fromScale(0.55, 1),
								TextSize = 20,
								Value = Store.get("HOST"),
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
								Size = UDim2.fromScale(0.22, 1),
								TextSize = 20,
								Value = Store.get("PORT"),
							},

							-- Connect Button
							{
								Component = "Button",
								Color = connectColor,
								Icon = connectIcon,
								LayoutOrder = 4,
								Rotation = connectRotation,
								TextColor = connectTextColor,

								Activated = function()
									local isConnected = not Store.getValue("Connected")
									Store.set("Connected", isConnected)
								end,
							},
						},
						LayoutOrder = 1,
						Size = UDim2.new(0, 250, 1, 0),
					},
				},
			},
		},
	}
end :: Types.Panel
