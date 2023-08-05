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
	local baseSize = Vector2.new(50, 25)
	local textSize = TextService:GetTextSize(_props.Data.Message, 14, Enum.Font.Gotham, baseSize)
	local toastSize = UDim2.fromOffset(textSize.X + baseSize.X, textSize.Y + baseSize.Y)

	local destroying = Value(false) :: Fusion.Value<boolean>
	local instance = Value() :: Fusion.Value<Frame?>
	local pos = Computed(function()
		if not instance:get() then
			return UDim2.new(1, toastSize.X.Offset, 1, 0)
		end

		local absoluteSize = instance:get().AbsoluteSize
		local index = _props.States.Index:get()
		local offset = (index - 1) * -(absoluteSize.Y + 15)
		if destroying:get() then
			return UDim2.new(1, absoluteSize.X, 1, offset)
		else
			return UDim2.new(1, 0, 1, offset)
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
	local lifetimeProgress = Value(UDim2.fromOffset(toastSize.X, 15))
	task.defer(lifetimeProgress.set, lifetimeProgress, UDim2.fromOffset(0, 15))

	return New("ImageButton") {
		AnchorPoint = Vector2.new(1, 1),
		ImageTransparency = 1,
		Name = "Toast",
		Parent = _props.Container,
		Position = Tween(pos, ToastTweenInfo),
		Size = toastSize,

		[Ref] = instance,

		[OnEvent("Activated")] = destroyToast,

		[Children] = {
			New("UICorner") {},

			New("TextLabel") {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0.05),
				Text = _props.Data.Message,
				Size = UDim2.fromScale(1, 0.95),
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
