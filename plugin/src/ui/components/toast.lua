local TextService = game:GetService("TextService")

local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Ref = Fusion.Ref
local Value = Fusion.Value
local Tween = Fusion.Tween
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent

export type ToastProps = {
	Data: Types.Toast,
	States: {
		Index: Fusion.Value<number>,
	},
}

local ToastTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic)

return function(_props)
	local textSize = TextService:GetTextSize(_props.Data.Message, 14, Enum.Font.Gotham, frameSize)

	local destroying = Value(false) :: Fusion.Value<boolean>
	local instance = Value() :: Fusion.Value<Frame?>
	local pos = Computed(function()
		if not instance:get() then
			return UDim2.fromScale(1, 1)
		end

		local instanceY = instance:get().AbsoluteSize.Y
		local index = _props.States.Index:get()
		local offset = (index - 1) * -(instanceY + 15)
		if destroying:get() then
			return UDim2.new(1, 0, 1, offset)
		else
			return UDim2.new(0, 0, 1, offset)
		end
	end)

	-- Destroys this component
	local function destroyToast()
		destroying:set(true)
		task.wait(ToastTweenInfo.Time)
		local index = _props.States.Index:get()
		local indexToast: { Types.Toast }? = Store.getValue("Toasts")
		if indexToast and indexToast[index] and indexToast[index].Time == _props.Data.Time then
			Store.remove("Toasts", index)
		end
	end

	-- Remove toast after lifetime
	task.delay(_props.Data.Lifetime, destroyToast)

	-- Handling lifetime progress
	local lifetimeInfo = TweenInfo.new(_props.Data.Lifetime + ToastTweenInfo.Time, Enum.EasingStyle.Linear)
	local lifetimeProgress = Value(UDim2.fromScale(1, 0.05))
	task.defer(lifetimeProgress.set, lifetimeProgress, UDim2.fromScale(0, 0.05))

	return New("ImageButton") {
		AnchorPoint = Vector2.new(0, 1),
		ImageTransparency = 1,
		Name = "Toast",
		Parent = _props.Container,
		Position = Tween(pos, ToastTweenInfo),
		Size = UDim2.fromScale(1, 0.15),

		[Ref] = instance,

		[OnEvent("Activated")] = destroyToast,

		[Children] = {
			New("UICorner") {},

			New("TextLabel") {
				Text = _props.Data.Message,
			},

			-- Progress for lifetime
			New("Frame") {
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Name = "Lifetime",
				Position = UDim2.fromScale(0, 1),
				Size = Tween(lifetimeProgress, lifetimeInfo),

				[Children] = {
					New("Frame") {
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = Color3.fromRGB(255, 0, 0),
						Name = "Progress",
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 5, 1, 5),

						[Children] = {
							New("UICorner") {},
						},
					},
				},
			},
		},
	}
end :: Types.Component<ToastProps>
