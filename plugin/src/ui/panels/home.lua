local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Children = Fusion.Children

return function()
	return New("Frame") {
		Name = "Home",
		Size = UDim2.fromScale(1, 1),

		[Children] = {},
	}
end :: Types.Panel
