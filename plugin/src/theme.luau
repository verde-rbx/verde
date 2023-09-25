--[[
	Theme

    Manages the theming for UI elements.
	Refer to https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideColor for a list of Colours
	and https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideModifier for their variants
--]]

local types = require(script.Parent.types)
local vide = require(script.Parent.packages.vide)

local source = vide.source

local StudioSettings = settings().Studio

local Theme = {} :: { [string]: types.ThemeSource }
local Colors = {
    BrandColor = source(Color3.fromRGB(150, 210, 137)),
    BrandColorPressed = source(Color3.fromRGB(116, 186, 100)),
} :: { [string]: vide.Source<Color3> }

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
    -- Generating colours
    for _, base in (Enum.StudioStyleGuideColor:GetEnumItems() :: { Enum.StudioStyleGuideColor }) do
        setThemeValue(base.Name, StudioSettings.Theme:GetColor(base))

        -- Set modifiers
        for _, modifier in (Enum.StudioStyleGuideModifier:GetEnumItems() :: { Enum.StudioStyleGuideModifier }) do
            if modifier == Enum.StudioStyleGuideModifier.Default then
                continue
            end

            setThemeValue(`{base.Name}{modifier.Name}`, StudioSettings.Theme:GetColor(base, modifier))
        end

        -- Create theme source
        if not Theme[base.Name] then
            local function getTheme(_state: string?): Color3 | () -> Color3
                if _state then
                    return function()
                        local color = Colors[`{base.Name}{vide.read(_state) or ""}`]
                        return if color then color() else Colors[base.Name]()
                    end
                else
                    return Colors[base.Name]()
                end
            end
            Theme[base.Name] = getTheme :: types.ThemeSource
        end
    end
end

-- Detect and populate themes
populateTheme()
StudioSettings.ThemeChanged:Connect(populateTheme)

return Theme
