local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

export type IconProps = {
    AnchorPoint: Vector2?,
    Image: string?,
    Position: UDim2?,
}

return function(_props)
    return create("ImageLabel") {
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://14245986258",
        Name = "VerdeIcon",
        Position = UDim2.fromScale(1, 0.5),
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        _props,
    }
end :: types.Component<IconProps>
