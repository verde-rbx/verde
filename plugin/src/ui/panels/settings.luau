local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

return function()
    return create("Frame") {
        BackgroundTransparency = 1,
        Name = "Settings",
        Size = UDim2.fromScale(1, 1),
    }
end
