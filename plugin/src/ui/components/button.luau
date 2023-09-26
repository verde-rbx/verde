local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local useRoundness = require(script.Parent.Parent.composables.useRoundness)

local create = vide.create
local source = vide.source

export type ButtonProps = {
    Activated: () -> (),
    BackgroundColor3: types.ThemeSource,
    Location: useRoundness.Location?,
    Layout: {
        LayoutOrder: number,
        Size: UDim2?,
    }?,
    Icon: {
        Image: types.CanBeSource<string>,
        ImageColor3: types.ThemeSource?,
        Rotation: types.CanBeSource<number>?,
    }?,
}

return function(_props)
    local btnState = source("")
    local xOffset, xAnchor = useRoundness(_props.Location or "all")

    return create("Frame") {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        {
            _props.Layout,
            create("TextButton") {
                AnchorPoint = Vector2.new(xAnchor, 0.5),
                BackgroundColor3 = _props.BackgroundColor3(btnState),
                Position = UDim2.fromScale(xAnchor, 0.5),
                Text = "",
                TextTransparency = 1,
                Size = UDim2.new(1, xOffset, 1, 0),

                Activated = _props.Activated,

                MouseButton1Down = function()
                    btnState("Pressed")
                end,

                MouseButton1Up = function()
                    btnState("")
                end,

                {
                    create("UICorner") {},
                    create("ImageLabel") {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        ImageColor3 = theme.MainText(),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(0.6, 0.6),
                        _props.Icon,
                    },
                },
            },
        },
    }
end :: types.Component<ButtonProps>
