local CoreGui = game:GetService("CoreGui")

local Fusion = require(script.Parent.Parent.packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

return function()
	local verdeToasts = CoreGui:FindFirstChild("VerdeToasts")
	if verdeToasts then
		verdeToasts:Destroy()
	end

	return New("ScreenGui") {
		DisplayOrder = 999,
		Name = "VerdeToasts",
		Parent = CoreGui,
		ResetOnSpawn = false,

		[Children] = {
			New("Frame") {
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 1),
				Size = UDim2.fromScale(0.25, 1),

				[Children] = {
					
				}
			},
		},
	}
end
