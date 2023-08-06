local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children

local InputGroup = require(script.Parent.Parent.components.input_group)

local function addNotification(_message: string)
	Store.add("Toasts", {
		Message = _message,
	} :: Types.Toast, 1)
end

return function()
	local isConnected = Store.get("Connected", false)
	local connectIcon = Computed(function()
		return if isConnected:get() then "rbxassetid://10709768538" else "rbxassetid://10747384394"
	end)
	local connectColor = Computed(function()
		return if isConnected:get() then "MainButton" else "ErrorText"
	end)
	local connectTextColor = Computed(function()
		return if isConnected:get() then "MainText" else "Mid"
	end)

	local connectRotation = Value(0)
	local overlayPercentage = Value(0)
	local overlayText = Value("Connecting...")

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
								Placeholder = "Host",
								Size = UDim2.fromScale(0.46, 1),
								TextSize = 20,
								Value = Store.get("HOST"),
							},

							-- Separator
							{
								LayoutOrder = 2,
								Readonly = true,
								Size = UDim2.fromScale(0.03, 1),
								TextSize = 20,
								Value = ":",
							},

							-- Port
							{
								LayoutOrder = 3,
								Placeholder = "Port",
								Size = UDim2.fromScale(0.33, 1),
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

									if not isConnected then
										overlayPercentage:set(0.82)
										overlayText:set("Connecting...")
										addNotification(
											`Connecting to {Store.getValue("HOST")}:{Store.getValue("PORT")}...`
										)

										-- TODO: Create session here

										overlayText:set("Connected")
										addNotification(`Connected to session {"session.name"}`)
									else
										overlayPercentage:set(0)
										addNotification(`Disconnecting from session {"session.name"}...`)
									end
								end,
							},
						},
						Overlay = {
							Anchor = "right",
							Color = connectColor,
							Offset = 0.18,
							Text = overlayText,
							TextColor = connectTextColor,
							Width = overlayPercentage,
							UseOverlay = true,
						},
						LayoutOrder = 1,
						Size = UDim2.new(0, 250, 1, 0),
					},
				},
			},
		},
	}
end :: Types.Panel
