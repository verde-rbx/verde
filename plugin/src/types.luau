local vide = require(script.Parent.packages.vide)

--[[
	Helper Types
]]

export type ThemeSource = (() -> Color3) & ((_state: string) -> () -> Color3)

-- vide CanBeSource
export type CanBeSource<T> = T | vide.Source<T>

-- Component builder method
export type Component<T> = (_props: T) -> Instance

--[[
    UI Types
--]]

-- Panel builder method
export type Panel = () -> Frame

-- A new toast to display
export type Toast = {
    Message: string,
    Severity: ("Error" | "Warn" | "Info" | string)?,
    Time: number?,
    Lifetime: number?,
}

--[[ 
    Store Types
]]

-- Store Menus
export type Menus = "home" | "settings"

export type Store = {
    [string]: any,
    UIShown: boolean,
    CurrentMenu: Menus,
    Toasts: { Toast },
}

--[[
	Config Types
]]

export type SettingUpdateFn = (_key: string, _oldValue: unknown, _newValue: unknown) -> nil

export type DefaultSetting = {
    [string]: any,
    ShowToasts: {
        Name: string,
        Type: "Checkbox",
        Default: unknown,
    },
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
    getConfig: () -> { [string]: any },
}

return nil
