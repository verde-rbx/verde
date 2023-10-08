local RunService = game:GetService("RunService")

local vide = require(script.Parent.Parent.Parent.packages.vide)

local source = vide.source
local cleanup = vide.cleanup

-- taken from spring.luau from vide
type TypeToVec6<T> = (T) -> (Vector3, Vector3)
type Vec6ToType<T> = (Vector3, Vector3) -> T

local typeConverters = {
    number = function(v)
        return Vector3.new(v, 0, 0), Vector3.zero
    end :: TypeToVec6<number>,

    CFrame = function(v)
        return v.Position, Vector3.new(v:ToEulerAnglesXYZ())
    end :: TypeToVec6<CFrame>,

    Color3 = function(v)
        -- todo: hsv, oklab?
        return Vector3.new(v.R, v.G, v.B), Vector3.zero
    end :: TypeToVec6<Color3>,

    UDim = function(v)
        return Vector3.new(v.Scale, v.Offset, 0), Vector3.zero
    end :: TypeToVec6<UDim>,

    UDim2 = function(v)
        return Vector3.new(v.X.Scale, v.X.Offset, v.Y.Scale), Vector3.new(v.Y.Offset, 0, 0)
    end :: TypeToVec6<UDim2>,

    Vector2 = function(v)
        return Vector3.new(v.X, v.Y, 0), Vector3.zero
    end :: TypeToVec6<Vector2>,

    Vector3 = function(v)
        return v, Vector3.zero
    end :: TypeToVec6<Vector3>,

    Rect = function(v)
        return Vector3.new(v.Min.X, v.Min.Y, v.Max.X), Vector3.new(v.Max.Y, 0, 0)
    end :: TypeToVec6<Rect>,
}

local vec6Converters = {
    number = function(a, b)
        return a.X
    end :: Vec6ToType<number>,

    CFrame = function(a, b)
        return CFrame.new(a) * CFrame.fromEulerAnglesXYZ(b.X, b.Y, b.Z)
    end :: Vec6ToType<CFrame>,

    Color3 = function(v)
        return Color3.new(v.X, v.Y, v.Z)
    end :: Vec6ToType<Color3>,

    UDim = function(v)
        return UDim.new(v.X, v.Y)
    end :: Vec6ToType<UDim>,

    UDim2 = function(a, b)
        return UDim2.new(a.X, a.Y, a.Z, b.X)
    end :: Vec6ToType<UDim2>,

    Vector2 = function(v)
        return Vector2.new(v.X, v.Y)
    end :: Vec6ToType<Vector2>,

    Vector3 = function(v)
        return v
    end :: Vec6ToType<Vector3>,

    Rect = function(a, b)
        return Rect.new(a.X, a.Y, a.Z, b.X)
    end :: Vec6ToType<Rect>,
}

type LerpSource = {
    step: number,
    duration: number,
    source: vide.Source<{ Vector3 }>,

    c1: Vector3,
    c2: Vector3,
    g1: Vector3,
    g2: Vector3,
}

local targets: { [number]: LerpSource } = {}

-- Updates all lerp sources
function step(_step: number)
    for i, target in next, targets do
        target.step = math.clamp(target.step + (_step / target.duration), 0, 1)

        local n1, n2 = target.c1:Lerp(target.g1, target.step), target.c2:Lerp(target.g2, target.step)
        target.source { n1, n2 }

        if target.step >= 1 then
            targets[i] = nil
            continue
        end
    end
end

-- Connects event
RunService.Heartbeat:Connect(function(_step)
    step(_step)
end)

--[[
    Linear interpolation of a value.
]]
return function<T>(_initial: T, _goal: T, _duration: number): () -> T
    local typeConverter: TypeToVec6<T> = typeConverters[typeof(_initial)]
    local currentVec6_0, currentVec6_1 = typeConverter(_initial)
    local goalVec6_0, goalVec6_1 = typeConverter(_goal)

    local value = source { currentVec6_0, currentVec6_1 }

    local i = #targets + 1
    table.insert(targets, {
        step = 0,
        duration = _duration or 1,
        source = value,

        c1 = currentVec6_0,
        c2 = currentVec6_1,

        g1 = goalVec6_0,
        g2 = goalVec6_1,
    })

    cleanup(function()
        targets[i] = nil
    end)

    local vec6Converter: Vec6ToType<T> = vec6Converters[typeof(_goal)]
    return function()
        local value = value()
        return vec6Converter(value[1], value[2])
    end
end
