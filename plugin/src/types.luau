local vide = require(script.Parent.packages.vide)

-- vide CanBeSource
export type CanBeSource<T> = T | vide.Source<T>

-- Component builder method
export type Component<T> = (_props: T) -> Instance

-- Toast
export type Toast = {
    Message: string,
    Severity: ("Error" | "Warn" | "Info" | string)?,
    Time: number?,
    Lifetime: number?,
}

return nil
