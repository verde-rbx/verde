local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children

return function()
	local isVisible = Computed(function()
		return Store.getValue("CurrentMenu") == "home"
	end)

	return New("Frame") {
		Visible = isVisible,

		[Children] = {},
	}
end :: Types.Panel
