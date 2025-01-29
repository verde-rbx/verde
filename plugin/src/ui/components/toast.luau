local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local icon = require(script.Parent.icon)

local lerp = require(script.Parent.Parent.composables.lerp)
local text = require(script.Parent.Parent.composables.text_size)
local timestamp = require(script.Parent.Parent.composables.timestamp)

local action = vide.action
local create = vide.create
local effect = vide.effect
local root = vide.root
local source = vide.source
local spring = vide.spring

local CORNER_RADIUS = 4

export type ToastProps = types.Toast & {
    Index: () -> number,
}

return function(_props)
    return root(function(_destroy)
        local instance = source()
        local size: UDim2 = text(_props.Message)
        local yOffset = 0
        local position = source(UDim2.new(1, size.X.Offset, 1, 0))

        -- Kill and cleanup toast
        local killing = false
        local timeoutThread: thread
        local function kill()
            if killing then
                return
            end

            killing = true
            position(UDim2.new(1, size.X.Offset, 1, yOffset))
            task.delay(0.5, function()
                if instance() then
                    instance():Destroy()
                end

                store.remove("Toasts", _props.Index())
                _destroy()
            end)
        end

        -- Watch for position changes
        effect(function()
            if instance() ~= nil and not killing then
                yOffset = (_props.Index() - 1) * -(instance().AbsoluteSize.Y + 15)
                position(UDim2.new(1, 0, 1, yOffset))
            end
        end)

        return create("ImageButton") {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = theme.MainBackground,
            ImageTransparency = 1,
            Name = "Toast",
            Position = spring(position, 0.5),
            Size = size,

            Activated = function()
                if timeoutThread then
                    task.cancel(timeoutThread)
                end
                kill()
            end,

            action(function(_instance: ImageButton)
                if _props.Lifetime > 0 then
                    timeoutThread = task.delay(_props.Lifetime, kill)
                end
                instance(_instance)
            end),

            -- Top bar
            create("Frame") {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.new(1, -10, 0.3, 0),

                icon {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                },

                create("TextLabel") {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0, 0.52),
                    Text = timestamp(_props.Time),
                    TextColor3 = theme.DimmedText,
                    TextScaled = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Size = UDim2.fromScale(0.85, 1),

                    create("UITextSizeConstraint") {
                        MaxTextSize = 14,
                    },
                },
            },

            -- Message
            create("TextLabel") {
                AnchorPoint = Vector2.new(0.5, 1),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.95),
                Text = _props.Message,
                TextColor3 = theme.MainText,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Size = UDim2.fromScale(0.95, 0.6),
            },

            -- Progress
            create("Frame") {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Name = "Lifetime",
                Position = UDim2.fromScale(0, 1),
                Size = lerp(
                    UDim2.fromOffset(size.X.Offset, CORNER_RADIUS),
                    UDim2.fromOffset(0, CORNER_RADIUS),
                    _props.Lifetime or 1
                ),

                create("Frame") {
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = theme.BrandColor,
                    Name = "Progress",
                    Position = UDim2.fromScale(0, 1),
                    Size = UDim2.new(1, 5, 1, 5),

                    create("UICorner") {
                        CornerRadius = UDim.new(0, CORNER_RADIUS),
                    },
                },
            },

            create("UICorner") {
                CornerRadius = UDim.new(0, CORNER_RADIUS),
            },
        }
    end)
end :: types.Component<ToastProps>
