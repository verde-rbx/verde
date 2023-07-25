local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New

return function(_props)
	return New("TextBox") {}
end :: Types.Component<{}>
