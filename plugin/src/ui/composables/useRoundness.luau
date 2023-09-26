export type Location = "left" | "middle" | "right" | "all"

local ROUNDNESS_OFFSETS = {
    offset = {
        ["left"] = 5,
        ["right"] = 5,
        ["middle"] = 10,
        ["all"] = 0,
    },
    anchor = {
        ["left"] = 0,
        ["right"] = 1,
        ["middle"] = 1,
        ["all"] = 1,
    },
}

--[[
    Use Roundness composable
]]
return function(_location: Location): (number, number)
    return ROUNDNESS_OFFSETS.offset[_location] or 0, ROUNDNESS_OFFSETS.anchor[_location] or 1
end
