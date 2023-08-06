--[[
	Session

	Manages the communuication between the Verde plugin and Verde cli.
]]
local HttpService = game:GetService("HttpService")

export type SessionData = {}

local Session = {} :: { _session: SessionData? }

--[[
    Connects to a session.
]]
function Session.connect(_host: string?, _port: number?) end

--[[
    Disconnects from the current session.
]]
function Session.disconnect(_force: boolean?) end

--[[
    Returns the currently active session.
]]
function Session.getSession(): SessionData?
	return Session._session
end

return Session
