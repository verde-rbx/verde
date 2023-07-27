--[[
    UI Types
--]]

local Config = require(script.Parent.config)

-- Component builder method
export type Component<T> = (_props: T) -> Instance

-- Panel builder method
export type Panel = () -> Frame

--[[ 
    Store Types
]]

-- Store Menus
export type Menus = "home" | "settings"

export type Store = typeof(Config.getConfig()) & {
	UIShown: boolean,
	CurrentMenu: Menus,
}

return nil
