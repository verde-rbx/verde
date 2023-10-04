local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local icon = require(script.Parent.icon)

local useLerp = require(script.Parent.Parent.composables.useLerp)
local useTextSize = require(script.Parent.Parent.composables.useTextSize)
local useTimestamp = require(script.Parent.Parent.composables.useTimestamp)

local action = vide.action
local create = vide.create
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
        local size = useTextSize(_props.Message)
        local position = source(UDim2.new(1, size.X.Offset, 1, 0))

        return create("ImageButton") {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = theme.MainBackground,
            ImageTransparency = 1,
            Name = "Toast",
            Position = spring(position, 0.5),
            Size = size,

            Activated = function()
                position(UDim2.new(1, size.X.Offset, 1, 0))
                task.delay(0.5, function()
                    if instance() then
                        instance():Destroy()
                    end

                    _destroy()
                end)
            end,

            action(function(_instance: ImageButton)
                local offset = (_props.Index() - 1) * -(_instance.AbsoluteSize.Y + 15)
                position(UDim2.new(1, 0, 1, offset))
                task.delay(_props.Lifetime, position, UDim2.new(1, size.X.Offset, 1, 0))
                instance(_instance)
            end),

            -- Top bar
            create("Frame") {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.fromScale(0.95, 0.3),

                icon {},

                create("TextLabel") {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0, 0.52),
                    Text = useTimestamp(_props.Time),
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
                Size = useLerp(
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
