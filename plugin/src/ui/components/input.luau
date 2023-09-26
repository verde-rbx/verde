local theme = require(script.Parent.Parent.Parent.theme)
local types = require(script.Parent.Parent.Parent.types)
local vide = require(script.Parent.Parent.Parent.packages.vide)

local useChanged = require(script.Parent.Parent.composables.useChanged)
local useRoundness = require(script.Parent.Parent.composables.useRoundness)

local create = vide.create
local read = vide.read
local source = vide.source
local spring = vide.spring
local show = vide.show

export type InputProps = {
    Location: useRoundness.Location?,
    Value: vide.Source<string>?,
    Readonly: types.CanBeSource<string>?,
    Size: UDim2,
    Layout: {
        Font: Font?,
        TextSize: number?,
        TextXAlignment: Enum.TextXAlignment?,
        TextYAlignment: Enum.TextYAlignment?,
    }?,
}

return function(_props)
    local btnState = source("Disabled")
    local backgroundColor = theme.Button(btnState)
    local xOffset, xAnchor = useRoundness(_props.Location or "all")

    local readonly = function()
        return read(_props.Readonly or false)
    end

    local inputProps = {
        AnchorPoint = Vector2.new(xAnchor, 0.5),
        BackgroundTransparency = 0,
        BackgroundColor3 = spring(backgroundColor, 0.25),
        FontFace = Font.fromEnum(Enum.Font.Gotham),
        Position = UDim2.fromScale(xAnchor, 0.5),
        Text = _props.Value,
        TextScaled = not _props.Layout or not _props.Layout.TextSize,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, xOffset, 1, 0),
        {
            _props.Layout,
            create("UICorner") {},
        },
    }

    local function ReadonlyInput()
        return create("TextLabel") {
            inputProps,
            TextColor3 = theme.SubText,
        }
    end

    local function Input()
        return create("TextBox") {
            inputProps,
            TextColor3 = theme.MainText,

            useChanged("Text", function(new: string)
                if type(_props.Value) == "function" then
                    _props.Value(new)
                end
            end),

            Focused = function()
                btnState("Hover")
            end,

            FocusLost = function()
                btnState("Disabled")
            end,
        }
    end

    return create("Frame") {
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        Size = _props.Size,
        show(readonly, ReadonlyInput, Input),
    }
end :: types.Component<InputProps>
