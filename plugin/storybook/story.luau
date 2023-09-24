--[[
    Base for a story item
]]

local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)
vide.strict = true

local mount = vide.mount

return function<T>(_component: types.Component<T>, _properties: T?)
	local createComponent = function()
		return _component(_properties or ({} :: any))
	end

	-- Create function
	return function(_target: Instance)
		return mount(createComponent, _target)
	end
end
