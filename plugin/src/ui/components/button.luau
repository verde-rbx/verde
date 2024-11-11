local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

export type ButtonProps = {
    Text: string,
}

return function(_props)
    return create("TextButton") {
        Size = UDim2.fromScale(1, 0.25),
        _props,
    }
end :: types.Component<ButtonProps>
