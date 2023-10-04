local TextService = game:GetService("TextService")

--[[
    Calculates frame size from text
]]
return function(_text: string): UDim2
    local textSize = TextService:GetTextSize(_text, 14, Enum.Font.Gotham, Vector2.zero)
    return UDim2.fromOffset((textSize.X - (textSize.X / 5)) + 25, textSize.Y + 35)
end
