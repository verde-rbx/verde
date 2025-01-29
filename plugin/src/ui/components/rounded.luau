local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

return function()
    return {
        create("UICorner") {
            CornerRadius = UDim.new(0, 10),
        }
    }
end
