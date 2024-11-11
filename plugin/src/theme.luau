--[[
    Theme

    Manages the theming for UI elements.
    Refer to https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideColor for a list of Colours
    and https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideModifier for their variants
]]
local vide = require(script.Parent.packages.vide)

local studio = settings().Studio
local source = vide.source

type ThemeState = "Default" | "Selected" | "Pressed" | "Disabled" | "Hover" | string
local CUSTOM_COLORS = {
    BrandColor = {
        Default = source(Color3.fromRGB(150, 210, 137)),
        Pressed = source(Color3.fromRGB(116, 186, 100)),
    },
} :: { [string]: { [ThemeState]: vide.Source<Color3> } }

-- Flat mapping of all colour sources
local Colors = {} :: { [string]: vide.Source<Color3> }

-- Reactive theme mapping with state getter
type ThemeSource = (() -> Color3) & ((_state: ThemeState) -> Color3) & ((_state: () -> ThemeState) -> () -> Color3)
local Theme = {} :: { [string]: ThemeSource }

--[[
    Sets a theme value or creates a new one if it doesn't exist.
]]
local function setThemeValue(_key: string, _value: Color3)
    -- Add colour instance
    local object = Colors[_key]
    if not object then
        Colors[_key] = source(_value)
    else
        object(_value)
    end
end

--[[
    Gets the current studio theme and populates the theme object
    with the correct colour values for all combinations.
]]
local function populateTheme()
    -- Generate builtin colours
    for name, customTheme in CUSTOM_COLORS do
        setThemeValue(name, customTheme.Default())

        -- Set modifiers
        for modifier, color in customTheme do
            if modifier == "Default" then
                continue
            end

            setThemeValue(`{name}{modifier}`, customTheme.Default())
        end

        -- Create theme source
        if not Theme[name] then
            local function getTheme(_state): Color3 | () -> Color3
                if _state and type(_state) == "function" then
                    return function()
                        local color = Colors[`{name}{_state() or ""}`]
                        return (color or Colors[name])()
                    end
                else
                    local key = `{name}{_state or ""}`
                    local color = Colors[key]
                    return (color or Colors[name])()
                end
            end
            Theme[name] = getTheme :: ThemeSource
        end
    end

    -- Generating colours from studio enum
    for _, base in Enum.StudioStyleGuideColor:GetEnumItems() :: { Enum.StudioStyleGuideColor } do
        setThemeValue(base.Name, studio.Theme:GetColor(base))

        -- Set modifiers
        for _, modifier in Enum.StudioStyleGuideModifier:GetEnumItems() :: { Enum.StudioStyleGuideModifier } do
            if modifier == Enum.StudioStyleGuideModifier.Default then
                continue
            end

            setThemeValue(`{base.Name}{modifier.Name}`, studio.Theme:GetColor(base, modifier))
        end

        -- Create theme source
        if not Theme[base.Name] then
            local function getTheme(_state): Color3 | () -> Color3
                if _state and type(_state) == "function" then
                    return function()
                        local color = Colors[`{base.Name}{_state() or ""}`]
                        return (color or Colors[base.Name])()
                    end
                else
                    local key = `{base.Name}{_state or ""}`
                    local color = Colors[key]
                    return (color or Colors[base.Name])()
                end
            end
            Theme[base.Name] = getTheme :: ThemeSource
        end
    end
end

-- Detect and populate themes
studio.ThemeChanged:Connect(populateTheme)
populateTheme()

return Theme
