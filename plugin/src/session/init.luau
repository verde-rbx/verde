--[[
	Session

	Manages the communuication between the Verde plugin and Verde cli.
]]
local HttpService = game:GetService("HttpService")

export type SessionData = {}

local Session = {}
Session.__index = Session

--[[
    Creates a new session.
]]
function Session.new(_host: string?, _port: number?, _secure: boolean?)
    local sessionData = {
        BaseUrl = `{if _secure then "https" else "http"}://{_host}:{_port}`,
    }

    return setmetatable(sessionData, Session)
end

--[[
    Makes a HTTP request to the session
]]
function Session:makeRequest(_path: string, _method: "GET" | "POST"?)
    return HttpService:RequestAsync {
        Url = `{self.BaseUrl}/{_path}`,
        Method = _method or "GET",
    }
end

--[[
    Connects to a session.
]]
function Session:connect()
    local _connectionData = self:makeRequest("connect")
    -- TODO: Process connection data (first request should include project setup)
end

--[[
    Disconnects from the current session.
]]
function Session:disconnect(_force: boolean?) end

return Session
