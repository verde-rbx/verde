--[[
    Fusion State Store

	Used as a global state management system in the plugin.
	It's essentially just a key value store of states.
--]]
local Config = require(script.Parent.config)
local Fusion = require(script.Parent.packages.fusion)
local Types = require(script.Parent.types)
local Value = Fusion.Value

local Store = {
	_store = {
		CurrentMenu = Value("home"),
	} :: Types.Store,
}

--[[
	Sets the specified value in the store
]]
function Store.set(_key: string, _value: unknown)
	local state: Fusion.Value<typeof(_value)?> = Store.get(_key, _value)
	state:set(_value)
end

--[[
	Gets the specified state in the store
	Will create an empty value if one is not found
]]
function Store.get<T>(_key: string, _defaultValue: unknown?): Fusion.Value<T?>
	local state = Store._store[_key]
	if not state then
		state = Value(_defaultValue or "")
		Store._store[_key] = state
	end
	return state
end

--[[
	Gets the specified value in the store
]]
function Store.getValue<T>(_key: string, _defaultValue: unknown?): T?
	return Store.get(_key, _defaultValue):get()
end

--[[
	Adds a value to a table state.
]]
function Store.add(_key: string, _value: unknown, _position: number?)
	local state = Store.get(_key, { _value }) :: Fusion.Value<{ typeof(_value)? }>
	local tbl = state:get()
	table.insert(tbl, _position or (#tbl + 1), _value)
	state:set(tbl)
end

--[[
	Removes a value from a table state.
]]
function Store.remove<T>(_key: string, _position: number?): Fusion.Value<T>
	local state = Store.get(_key, {}) :: Fusion.Value<T>
	local tbl = state:get()
	table.remove(tbl, _position)
	state:set(tbl)
	return state
end

-- Add config values to store
for k, v in Config.getConfig() do
	Store.set(k, v)
end

-- Add settings
for setting, value in Config.getSettings() do
	Store.set(setting, value.Default)
end

Config.settingUpdated(function(_key, _oldValue, _newValue)
	Store.set(_key, _newValue)
end)

return Store
