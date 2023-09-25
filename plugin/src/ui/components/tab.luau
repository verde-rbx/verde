local store = require(script.Parent.Parent.Parent.store)
local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local create = vide.create

export type TabProps = {
    Icon: string,
    Panel: types.Menus | string,
}

return function(_props)
    local function isActivePanel(): boolean
        return store.getValue("CurrentMenu") :: types.Menus == _props.Panel
    end

    local function backgroundColor(): Color3
        return if isActivePanel() then theme.MainBackground() else theme.Titlebar()
    end

    return create("TextButton") {
        BackgroundColor3 = backgroundColor,
        Name = _props.Panel,
        Size = UDim2.fromScale(1, 1),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        TextTransparency = 1,
        ZIndex = 2,

        Activated = function()
            store.set("CurrentMenu", _props.Panel)
        end,

        {
            -- Hide topbar stroke
            create("UIStroke") {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = theme.MainBackground,
                Enabled = isActivePanel,
            },

            -- Selection Stroke
            create("Frame") {
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.new(1, 2, 1, 0),
                ZIndex = 1,

                {
                    create("UIStroke") {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = theme.Separator,
                        Enabled = isActivePanel,
                    },
                },
            },

            -- Icon
            create("ImageLabel") {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = _props.Icon,
                ImageColor3 = theme.MainText,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.5, 0.5),
                ZIndex = 2,
            },
        },
    }
end :: types.Component<TabProps>
