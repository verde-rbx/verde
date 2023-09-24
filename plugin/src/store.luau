--[[
    Verde State Store

	Used as a global state management system in the plugin.
	It's essentially just a key value store of states.
--]]
local config = require(script.Parent.config)
local types = require(script.Parent.types)
local vide = require(script.Parent.packages.vide)

local source = vide.source

local Store = {
    _store = {
        CurrentMenu = source("home"),
    } :: types.Store,
}

--[[
	Sets the specified value in the store
]]
function Store.set(_key: string, _value: unknown)
    local state: vide.Source<typeof(_value)?> = Store.get(_key, _value)
    state(_value)
end

--[[
	Gets the specified state in the store
	Will create an empty value if one is not found
]]
function Store.get<T>(_key: string, _defaultValue: unknown?): vide.Source<T?>
    local state = Store._store[_key]
    if not state then
        state = source(_defaultValue or "")
        Store._store[_key] = state
    end
    return state
end

--[[
	Gets the specified value in the store
]]
function Store.getValue<T>(_key: string, _defaultValue: unknown?): T?
    return Store.get(_key, _defaultValue)()
end

--[[
	Adds a value to a table state.
]]
function Store.add(_key: string, _value: unknown, _position: number?)
    local state = Store.get(_key, { _value }) :: vide.Source<{ typeof(_value)? }>
    local tbl = state()
    table.insert(tbl, _position or (#tbl + 1), _value)
    state(tbl)
end

--[[
	Removes a value from a table state.
]]
function Store.remove<T>(_key: string, _position: number?): vide.Source<{ T }>
    local state = Store.get(_key, {}) :: vide.Source<{ T }>
    local tbl = state()
    table.remove(tbl, _position)
    state(tbl)
    return state
end

-- Add config values to store
for k, v in config.getConfig() do
    Store.set(k, v)
end

-- Add settings
for setting, value in config.getSettings() do
    Store.set(setting, value.Default)
end

config.settingUpdated(function(_key, _oldValue, _newValue)
    Store.set(_key, _newValue)
end)

return Store
