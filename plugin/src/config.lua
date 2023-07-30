--[[
	Config

	These values are put into the state store when the plugin starts,
	This can be seen as a read-only version of the intiial plugin state.
]]

local DEFAULT_CONFIG = table.freeze {
	-- Plugin
	PLUGIN_NAME = "Verde",
	HOST = "localhost",
	PORT = 34872,
	VERSION = "0.1.0",
}

local DEFAULT_SETTINGS = table.freeze {}

local Config = {}

function Config.getSetting<T>(_key: string): T
	return DEFAULT_SETTINGS[_key]
end

-- Returns the config values
function Config.getConfig()
	return DEFAULT_CONFIG
end

return Config
