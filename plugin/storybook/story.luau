--[[
    Base for a story item
]]

local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)
vide.strict = true

local mount = vide.mount

return function<T>(_component: types.Component<T>, _properties: T?)
	-- Create function
	return function(_target: Instance)
		return mount(function()
			return _component(_properties or ({} :: any))
		end, _target)
	end
end
