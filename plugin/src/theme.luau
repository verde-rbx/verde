--[[
	Theme

    Manages the theming for UI elements.
	Refer to https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideColor for a list of Colours
	and https://create.roblox.com/docs/reference/engine/enums/StudioStyleGuideModifier for their variants
--]]

local vide = require(script.Parent.packages.vide)

local source = vide.source

local StudioSettings = settings().Studio
local Theme = {
	BrandColor = source(Color3.fromRGB(150, 210, 137)),
	BrandColorPressed = source(Color3.fromRGB(116, 186, 100)),
} :: { [string]: vide.Source<Color3> }

--[[
    Sets a theme value or creates a new one if it doesn't exist.
]]
local function setThemeValue(_key: string, _value: Color3)
	local object = Theme[_key]
	if not object then
		object = source(_value)
	else
		object(_value)
	end
	Theme[_key] = object
end

--[[
    Gets the current studio theme and populates the theme object
    with the correct colour values for all combinations.
]]
local function populateTheme()
	for _, base in (Enum.StudioStyleGuideColor:GetEnumItems() :: { Enum.StudioStyleGuideColor }) do
		setThemeValue(base.Name, StudioSettings.Theme:GetColor(base))

		for _, modifier in (Enum.StudioStyleGuideModifier:GetEnumItems() :: { Enum.StudioStyleGuideModifier }) do
			if modifier == Enum.StudioStyleGuideModifier.Default then
				continue
			end

			setThemeValue(`{base.Name}{modifier.Name}`, StudioSettings.Theme:GetColor(base, modifier))
		end
	end
end

-- Detect and populate themes
populateTheme()
StudioSettings.ThemeChanged:Connect(populateTheme)

return Theme
