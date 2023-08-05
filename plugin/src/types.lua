--[[
    UI Types
--]]

local Config = require(script.Parent.config)

-- Component builder method
export type Component<T> = (_props: T) -> Instance

-- Panel builder method
export type Panel = () -> Frame

-- A new toast to display
export type Toast = {
	Message: string,
	Severity: ("Error" | "Warn" | "Info")?,
	Time: number?,
	Lifetime: number?,
}

--[[ 
    Store Types
]]

-- Store Menus
export type Menus = "home" | "settings"

export type Store = typeof(Config.getConfig()) & {
	UIShown: boolean,
	CurrentMenu: Menus,
	Toasts: { Toast },
}

return nil
