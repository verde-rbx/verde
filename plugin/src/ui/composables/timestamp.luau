--[[
    Generates a timestamp in the format hh:mm:ss
]]
return function(_time: number?)
    local utcTimestamp = os.date("!*t", _time)
    return string.format("%02d:%02d:%02d", utcTimestamp.hour, utcTimestamp.min, utcTimestamp.sec)
end
