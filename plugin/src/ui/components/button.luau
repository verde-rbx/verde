local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create
local source = vide.source

local ROUNDNESS_OFFSETS = {
    offset = {
        ["left"] = 5,
        ["right"] = 5,
        ["middle"] = 10,
        ["all"] = 0,
    },
    anchor = {
        ["left"] = 0,
        ["right"] = 1,
        ["middle"] = 1,
        ["all"] = 1,
    },
}

export type ButtonProps = {
    Activated: () -> (),
    BackgroundColor3: types.ThemeSource,
    Location: ("left" | "middle" | "right" | "all")?,
    Layout: {
        LayoutOrder: number,
        Size: UDim2?,
    }?,
    Icon: {
        Image: types.CanBeSource<string>,
        ImageColor3: types.CanBeSource<Color3>?,
        Rotation: types.CanBeSource<number>?,
    }?,
}

return function(_props)
    local xOffset = ROUNDNESS_OFFSETS.offset[_props.Location] or 0
    local xAnchor = ROUNDNESS_OFFSETS.anchor[_props.Location] or 1

    local isPressed = source("")
    return create("Frame") {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        {
            _props.Layout,
            create("TextButton") {
                AnchorPoint = Vector2.new(xAnchor, 0.5),
                BackgroundColor3 = _props.BackgroundColor3(isPressed),
                Position = UDim2.fromScale(xAnchor, 0.5),
                Text = "",
                TextTransparency = 1,
                Size = UDim2.new(1, xOffset, 1, 0),

                Activated = _props.Activated,

                MouseButton1Down = function()
                    isPressed("Pressed")
                end,

                MouseButton1Up = function()
                    isPressed("")
                end,

                {
                    create("UICorner") {},
                    create("ImageLabel") {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        ImageColor3 = theme.MainText,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromScale(0.6, 0.6),
                        _props.Icon,
                    },
                },
            },
        },
    }
end :: types.Component<ButtonProps>
