local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local button = require(script.Parent.button)
local input = require(script.Parent.input)

local changed = vide.changed
local create = vide.create
local show = vide.show
local source = vide.source
local spring = vide.spring
local untrack = vide.untrack

export type InputGroupProps = {
    Inputs: {
        { Width: "*" | number }
        & (({ Component: "Button" } & button.ButtonProps) | ({ Component: "Input" } & input.InputProps))
    },
    Layout: {
        LayoutOrder: number,
        Size: UDim2,
    },
    Overlay: {
        Text: string?,
        Enabled: types.CanBeSource<boolean>,
        Size: vide.Source<UDim2>?,
        Layout: {
            AnchorPoint: Vector2?,
        }?,
    },
}

return function(_props)
    local overlayEnabled = function()
        return vide.read(_props.Overlay and _props.Overlay.Enabled)
    end

    local overlayTextVisible = function()
        local text = vide.read(_props.Overlay.Text)
        return text ~= nil and text ~= ""
    end

    local overlaySize = function()
        return if _props.Overlay and _props.Overlay.Size then spring(_props.Overlay.Size) else UDim2.fromScale(1, 1)
    end

    -- Calculate the scaling ratio for a component
    -- TODO: Fix offset on size budget. the useRoundness composable applies an offset (5/10) to clip roundness which is causing issues with the below calculation
    local absoluteSize = source(Vector2.new(1, 1))
    local sizeBudget, inputCount = (1 - (#_props.Inputs * 0.025)), 0
    local function getScale(_component: "Button" | "Input")
        -- Calculate individual budget for inputs
        -- We can asume a relculation is necessary since absoluteSize() is tracked and may have changed
        sizeBudget, inputCount = (1 - (#_props.Inputs * 0.025)), 0
        for _, data in _props.Inputs do
            if data.Component == "Button" then
                -- Buttons will be square ratio, so same as input height
                sizeBudget -= (absoluteSize().Y / workspace.CurrentCamera.ViewportSize.Y)
            elseif data.Component == "Input" then
                if data.Width ~= "*" and data.Width then
                    sizeBudget -= data.Width
                else
                    inputCount += 1
                end
            end
        end

        -- Buttons should fully scale
        if _component == "Button" then
            return 1
        end

        -- Decrease auto inputs from budget
        return (sizeBudget / inputCount)
    end

    -- Generate input components from props
    local inputs = function()
        local children = {}
        for i, data in _props.Inputs do
            local component = if data.Component == "Button" then button else input
            local componentData = data :: any

            -- Calculate location (for roundness)
            local totalCount = #_props.Inputs
            componentData.Location = if totalCount == 1
                then "all"
                elseif i > 1 and i < totalCount then "middle"
                elseif i <= 1 then "left"
                else "right"

            -- Calculate scaling
            local xScale = if not componentData.Width or componentData.Width == "*"
                then getScale(data.Component)
                else componentData.Width
            componentData.Size = UDim2.fromScale(xScale :: number, 1)

            -- Create a component without tracking to avoid updates
            children[i] = untrack(function()
                return (component :: (button.ButtonProps | input.InputProps) -> Instance)(componentData)
            end)
        end
        return children
    end

    return create("Frame") {
        BackgroundTransparency = 1,
        ClipsDescendants = true,

        create("UIStroke") {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        },

        create("UICorner") {
            CornerRadius = UDim.new(0, 5),
        },

        changed("AbsoluteSize", function(_absoluteSize)
            absoluteSize(_absoluteSize)
        end),

        -- Contents
        create("Frame") {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),

            {
                create("UIListLayout") {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                },

                inputs,
            },
        },

        -- Overlay
        show(
            overlayEnabled,
            create("Frame") {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.fromScale(0, 0.5),
                Size = overlaySize,

                {
                    _props.Overlay.Layout,

                    -- Overlay text
                    show(
                        overlayTextVisible,
                        create("TextLabel") {
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = 1,
                            Font = Enum.Font.Gotham,
                            FontSize = 10,
                            Position = UDim2.fromScale(0, 0.5),
                            Size = UDim2.fromScale(1, 1),
                            Text = _props.Overlay.Text,
                            ZIndex = 3,
                        }
                    ),

                    -- Overlay fill
                    create("Frame") {
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundColor3 = theme.MainBackground,
                        Name = "Progress",
                        Position = UDim2.fromScale(0, 1),
                        Size = UDim2.new(1, 5, 1, 0),
                        ZIndex = 2,
                        {
                            create("UICorner") {
                                CornerRadius = UDim.new(0, 8),
                            },
                        },
                    },
                },
            }
        ),

        _props.Layout,
    }
end :: types.Component<InputGroupProps>
