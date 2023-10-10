local vide = require(script.Parent.packages.vide)

--[[
	Helper Types
]]

-- vide CanBeSource
export type CanBeSource<T> = T | vide.Source<T>

-- Component builder method
export type Component<T> = (_props: T) -> Instance

--[[
    Theme Types
]]

export type ThemeState = "Default" | "Selected" | "Pressed" | "Disabled" | "Hover" | string

export type ThemeSource = (() -> Color3) & ((_state: ThemeState) -> Color3) & ((_state: () -> ThemeState) -> () -> Color3)

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

export type DefaultSettings = {
    [string]: {
        Name: string,
        Type: string,
        Default: any,
    },
}

export type Config = {
    getSettings: () -> DefaultSettings,
    getSetting: <T>(_key: string) -> T,
    updateSetting: (_key: string, _value: unknown) -> (),
    settingUpdated: (_onUpdate: (_key: string, _oldValue: unknown, _newValue: unknown) -> nil) -> nil,
    getConfig: () -> { [string]: any },
}

return nil
