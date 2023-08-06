local TextService = game:GetService("TextService")

local Fusion = require(script.Parent.Parent.Parent.packages.fusion)
local Store = require(script.Parent.Parent.Parent.store)
local Theme = require(script.Parent.Parent.Parent.theme)
local Types = require(script.Parent.Parent.Parent.types)

local New = Fusion.New
local Ref = Fusion.Ref
local Value = Fusion.Value
local Tween = Fusion.Tween
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent

local Icon = require(script.Parent.icon)

local ToastTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Cubic)

export type ToastProps = {
	Data: Types.Toast,
	States: {
		Index: Fusion.Value<number>,
	},
}

return function(_props)
	local textSize = TextService:GetTextSize(_props.Data.Message, 14, Enum.Font.Gotham, Vector2.zero)
	local toastSize = UDim2.fromOffset((textSize.X - (textSize.X / 5)) + 25, textSize.Y + 35)

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
	local cornerRadius = 4
	local lifetimeInfo = TweenInfo.new(_props.Data.Lifetime, Enum.EasingStyle.Linear)
	local lifetimeProgress = Value(UDim2.new(0, toastSize.X.Offset, 0, cornerRadius))
	task.defer(lifetimeProgress.set, lifetimeProgress, UDim2.new(0, 0, 0, cornerRadius))

	-- Timestamp
	local utcTimestamp = os.date("!*t", _props.Data.Time)
	local timestamp = string.format("%02d:%02d:%02d", utcTimestamp.hour, utcTimestamp.min, utcTimestamp.sec)

	return New("ImageButton") {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Theme.MainBackground,
		ImageTransparency = 1,
		Name = "Toast",
		Parent = _props.Container,
		Position = Tween(pos, ToastTweenInfo),
		Size = toastSize,

		[Ref] = instance,

		[OnEvent("Activated")] = destroyToast,

		[Children] = {
			New("UICorner") {
				CornerRadius = UDim.new(0, cornerRadius),
			},

			-- Top Bar
			New("Frame") {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(0.95, 0.3),

				[Children] = {
					-- TopRight Icon (watermark?)
					Icon {},

					-- Timestamp
					New("TextLabel") {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 0.52),
						Text = timestamp,
						TextColor3 = Theme.DimmedText,
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						Size = UDim2.fromScale(0.85, 1),

						[Children] = {
							New("UITextSizeConstraint") {
								MaxTextSize = 14,
							},
						},
					},
				},
			},

			-- Message
			New("TextLabel") {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.95),
				Text = _props.Data.Message,
				TextColor3 = Theme.MainText,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Size = UDim2.fromScale(0.95, 0.6),
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
						BackgroundColor3 = Theme.BrandColor,
						Name = "Progress",
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 5, 1, 5),

						[Children] = {
							New("UICorner") {
								CornerRadius = UDim.new(0, cornerRadius),
							},
						},
					},
				},
			},
		},
	}
end :: Types.Component<ToastProps>
