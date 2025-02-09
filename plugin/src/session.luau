--[[
	Session
	Manages the communuication between the Verde plugin and Verde cli.
]]
local HttpService = game:GetService("HttpService")

local types = require(script.Parent.types)

local sync_server = {
    lastSync = -1,
    isSyncing = false,
}

local session = {}

--[[
    Starts a new sync session
]]
function session.start(connectionString: string): types.Result
    if sync_server.isSyncing then
        return {
            success = false,
            message = "The sync server is already running.",
        }
    end

    local host, port = table.unpack(string.split(connectionString, ":"))
    print("Host:", host)
    print("Port:", port)

    return {
        success = true,
        message = `Successfully connected to {connectionString}.`,
    }
end

-- TODO: Grim, I know but we need to see if it works first.
return session
