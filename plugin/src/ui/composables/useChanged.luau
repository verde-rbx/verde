local vide = require(script.Parent.Parent.Parent.packages.vide)

local action = vide.action
local cleanup = vide.cleanup

--[[
    Use Changed
]]
return function<T>(_property: string, _callback: (new: T) -> ())
    return action(function(_instance)
        local con = _instance:GetPropertyChangedSignal(_property):Connect(function()
            _callback(_instance[_property])
        end)

        cleanup(function()
            con:Disconnect()
        end)
    end)
end
