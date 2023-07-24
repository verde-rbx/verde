local Fusion = require(script.Parent.Parent.packages.fusion)

local New = Fusion.New

return function()
	return New("ScreenGui") {
		Name = "Plugin",
	}
end
