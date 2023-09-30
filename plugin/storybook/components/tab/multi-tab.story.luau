local story = require(script.Parent.Parent.Parent.story)
local vide = require(script.Parent.Parent.Parent.Parent.packages.vide)

local tab = require(script.Parent.Parent.Parent.Parent.ui.components.tab)

local create = vide.create

local function TabGroup()
    return create("Frame") {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        {
            tab {
                Icon = "rbxassetid://10734940825",
                Panel = "home",
            },
            tab {
                Icon = "rbxassetid://10734950309",
                Panel = "settings",
            },
            create("UIListLayout") {
                FillDirection = Enum.FillDirection.Horizontal,
            },
        },
    }
end

return story(TabGroup, {})
