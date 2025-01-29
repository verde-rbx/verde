local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local rounded = require(script.Parent.rounded)

local create = vide.create

export type ButtonProps = {
    Text: string,
}

return function(_props)
    return create("TextButton") {
        rounded(),
        Size = UDim2.fromScale(1, 0.25),
        _props,
    }
end :: types.Component<ButtonProps>
