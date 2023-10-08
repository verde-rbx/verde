local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local useRoundness = require(script.Parent.Parent.composables.useRoundness)

local create = vide.create
local changed = vide.changed
local derive = vide.derive
local read = vide.read
local source = vide.source
local spring = vide.spring

export type InputProps = {
    Location: useRoundness.Location?,
    Value: vide.Source<string>?,
    Readonly: vide.Source<string>?,
    Size: UDim2?,
    Layout: {
        Font: Font?,
        TextSize: number?,
        TextXAlignment: Enum.TextXAlignment?,
        TextYAlignment: Enum.TextYAlignment?,
    }?,
}

return function(_props)
    local btnState: vide.Source<types.ThemeState> = source("")
    local backgroundColor = theme.Button(btnState)
    local xOffset, xAnchor = useRoundness(_props.Location or "all")

    local readonlyFalsy = derive(function()
        return not read(_props.Readonly or false)
    end)

    local textColor = function()
        return if readonlyFalsy() then theme.MainText(btnState()) else theme.DimmedText()
    end

    return create("Frame") {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = _props.Size or UDim2.fromScale(0.5, 1),

        create("TextBox") {
            AnchorPoint = Vector2.new(xAnchor, 0.5),
            BackgroundTransparency = 0,
            BackgroundColor3 = spring(backgroundColor, 0.5),
            FontFace = Font.fromEnum(Enum.Font.Gotham),
            Position = UDim2.fromScale(xAnchor, 0.5),
            Text = _props.Value,
            TextColor3 = spring(textColor, 0.5),
            TextScaled = not _props.Layout or not _props.Layout.TextSize,
            TextEditable = readonlyFalsy,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            Size = UDim2.new(1, xOffset, 1, 0),

            changed("Text", function(new: string)
                if type(_props.Value) == "function" then
                    _props.Value(new)
                end
            end),

            Focused = function()
                btnState("Hover")
            end,

            FocusLost = function()
                btnState("")
            end,

            {
                _props.Layout,
                create("UICorner") {
                    CornerRadius = UDim.new(0, 5),
                },
            },
        },
    }
end :: types.Component<InputProps>
