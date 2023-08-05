local CoreGui = game:GetService("CoreGui")

local Fusion = require(script.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.store)
local Types = require(script.Parent.Parent.types)

local New = Fusion.New
local Value = Fusion.Value
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs

local Toast = require(script.Parent.components.toast)

type ToastState = {
	Toast: Instance,
	Index: Fusion.Value<number>,
}

return function()
	local verdeToasts = CoreGui:FindFirstChild("VerdeToasts")
	if verdeToasts then
		verdeToasts:Destroy()
	end

	local toastQueue = Store.get("Toasts", {}) :: Fusion.Value<{ Types.Toast }>
	local toastStates = {} :: { ToastState }
	local toasts = ForPairs(toastQueue, function(_key, _value)
		-- Set defaults
		_value.Severity = _value.Severity or "Info"
		_value.Lifetime = _value.Lifetime or 4.5
		_value.Time = _value.Time or os.clock()

		-- Checking for existing toast (prevent duplication)
		local states: ToastState = toastStates[_value.Time] or {}
		if states.Toast then
			states.Index:set(_key)
			return _value.Time, states.Toast
		end

		-- Creating new state entry for new toast
		states.Index = Value(_key)
		states.Toast = Toast {
			Data = _value,
			States = states,
		}

		toastStates[_value.Time] = states
		return _value.Time, states.Toast
	end, function(_time, _instance)
		-- Destroy if states are gone (no longer reactive)
		local states: ToastState? = toastStates[_time]
		if not states then
			_instance:Destroy()
			return
		end

		-- Destroy if original queue entry no longer exists
		local index = states.Index:get()
		local toastQueue = toastQueue:get()[index]
		if not toastQueue or toastQueue.Time ~= _time then
			_instance:Destroy()
			toastStates[_time] = nil
			return
		end
	end)

	return New("ScreenGui") {
		DisplayOrder = 999,
		Name = "VerdeToasts",
		Parent = CoreGui,
		ResetOnSpawn = false,

		[Children] = {
			New("Frame") {
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -5, 1, -5),
				Size = UDim2.fromScale(0.25, 1),

				[Children] = toasts,
			},
		},
	}
end
