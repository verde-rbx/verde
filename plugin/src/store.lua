--[[
    Fusion State Store

	Used as a global state management system in the plugin.
	Is essentially just a key value store of fusion states to be editing by any script
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

-- Add config values to store
for k, v in Config.getConfig() do
	Store.set(k, v)
end

return Store
