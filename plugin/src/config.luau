--[[
	Config

	These values are put into the state store when the plugin starts,
	This can be seen as a read-only version of the intiial plugin state.
]]

local types = require(script.Parent.types)

local DEFAULT_CONFIG = table.freeze {
    -- Plugin
    PLUGIN_NAME = "Verde",
    HOST = "localhost",
    PORT = 34872,
    VERSION = "0.1.0",
    MENUS = {
        home = "rbxassetid://10734940825",
        settings = "rbxassetid://10734950309",
    },
}

local DEFAULT_SETTINGS = table.freeze {
    ShowToasts = {
        Name = "Show Toasts",
        Type = "Checkbox",
        Default = true,
    },
} :: { [string]: types.DefaultSetting }

local Config = {
    _settingCache = {},
    _settingListeners = {},
} :: types.Config

--[[
	Retrieves the setting from studio or creates a new setting
]]
function get<T>(_key: string): T
    local val = plugin:GetSetting(_key)
    if not val then
        local defaultValue = DEFAULT_SETTINGS[_key].Default
        set(_key, defaultValue)
        return defaultValue
    end

    return val
end

--[[
	Updates a setting value
]]
function set(_key: string, _value: unknown)
    local oldValue = Config._settingCache[_key]
    local doUpdate = oldValue ~= _value
    Config._settingCache[_key] = _value
    if doUpdate then
        task.spawn(plugin.SetSetting, plugin, `Verde{_key}`, _value)
    end

    for _, v in Config._settingListeners do
        v(_key, oldValue, _value)
    end
end

--[[
	Retrieves all the settings
]]
function Config.getSettings()
    return DEFAULT_SETTINGS
end

--[[
	Retrieves a setting value
]]
function Config.getSetting<T>(_key: string): T
    if Config._settingCache[_key] then
        return Config._settingCache[_key] :: T
    end

    return get(_key)
end

--[[
	Calls on update method when setting has changed
]]
function Config.settingUpdated(_onUpdate: types.SettingUpdateFn)
    return table.insert(Config._settingListeners, _onUpdate)
end

--[[
	Returns the config values
]]
function Config.getConfig()
    return DEFAULT_CONFIG
end

return Config
