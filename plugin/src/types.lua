--[[
    UI Types
--]]

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

export type Store = { [string]: unknown } & {
	UIShown: boolean,
	CurrentMenu: Menus,
	Toasts: { Toast },
}

--[[
	Config Types
]]

export type SettingUpdateFn = (_key: string, _oldValue: unknown, _newValue: unknown) -> nil

export type DefaultSetting = {
	Name: string,
	Type: "Checkbox",
	Default: unknown,
}

export type Config = {
	_settingCache: {
		[string]: unknown,
	},
	_settingListeners: {
		[number]: SettingUpdateFn,
	},
	getSettings: () -> { [string]: DefaultSetting },
	getSetting: <T>(_key: string) -> T,
	settingUpdated: (_onUpdate: SettingUpdateFn) -> nil,
	getConfig: () -> { [string]: unknown },
}

return nil
