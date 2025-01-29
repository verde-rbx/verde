local store = require(script.Parent.Parent.store)
local types = require(script.Parent.Parent.types)
local vide = require(script.Parent.Parent.packages.vide)

local toast = require(script.Parent.components.toast)

local create = vide.create
local values = vide.values

--[[
    Container for the toast notifications.
    Separate from the widget so as to be persistent.
]]
return function()
    local toastQueue = store.get("Toasts", {}) :: vide.Source<{ types.Toast }>
    local toasts = values(toastQueue, function(_value: types.Toast, _index: () -> number)
        local toastProps = _value :: toast.ToastProps
        toastProps.Index = _index
        return toast(toastProps)
    end)

    return create("ScreenGui") {
        DisplayOrder = 999,
        Name = "VerdeToasts",
        ResetOnSpawn = false,

        create("Frame") {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -5, 1, -5),
            Size = UDim2.fromScale(0.25, 1),

            toasts,
        },
    }
end
