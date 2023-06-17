local HttpService = game:GetService("HttpService")
local DataLoop = 4

--server closing connections sends a final request to client(s) to shut down on their end

--possibly occasional checks during a set amount of time to ensure the server is still
--  active and receive data from the server's buffer of modified data

--UUID can be removed if unneccesary

return function(Frame:typeof(script.Parent.Parent.Frame))
	local Network = {
		Connecting = false;
		Connected = false;
		URL = nil;
		UUID = HttpService:GenerateGUID(false)
	}
	
	local function HideFrames()
		for _,V in Frame.Status:GetChildren() do V.Visible = false end
	end

	Network.Connect = function(Protocol: "https" | "http", Domain: string, Port: number)
		if Network.Connecting or Network.Connected then return end
		HideFrames()
		
		if not Protocol or not Domain or not Port or Port > 65_535 or Port <= 0 then
			Frame.TextBox.Text = ""
			Frame.Status.InvalidURL.Visible = true
			task.wait(2)
			Frame.Status.InvalidURL.Visible = false
			return
		end
		
		local URL = Protocol.."://"..Domain..":"..Port
		
		Network.Connecting = true
		Frame.Status.Connecting.Visible = true
		local Success,Response = pcall(HttpService.GetAsync,HttpService,URL.."/requestconnection?id="..Network.UUID)
		Frame.Status.Connecting.Visible = false
		Network.Connecting = false
		
		if Success and Response == "VerdeOK" then
			Network.URL = URL
			Network.Connected = true
			
			HideFrames()
			Frame.Status.Connected.Visible = true
			Frame.Status.Connected.Text = "Connected to "..URL
			Frame.TextBox.Text = URL
			Frame.TextBox.TextEditable = false
			Frame.Connect.Text = "Disconnect"
			return true
		end
		
		HideFrames()
		Frame.Status.Error.Visible = true
		Frame.Status.Error.Text = Response or "Error"
		task.wait(2)
		Frame.Status.Error.Visible = false
		Frame.Status.Error.Text = "Error"
	end
	
	Network.Disconnect = function()
		if Network.Connected then
			Network.Connecting = true --disable connecting
			HideFrames()
			
			local Success,Response = pcall(HttpService.PostAsync,HttpService,Network.URL.."/disconnect",Network.UUID)	
			Network.Connecting = false
			
			Frame.Status.Disconnected.Visible = true
			Frame.Status.Disconnected.Text = "Disconnected"

			
			Network.Connected = false
			Network.URL = nil
			Frame.TextBox.Text = ""
			Frame.TextBox.TextEditable = true
			Frame.Connect.Text = "Connect"
			
			task.wait(2)
			Frame.Status.Disconnected.Visible = false
		end
	end
	
	task.spawn(function()
		while task.wait(DataLoop) do
			--get data from server's buffer
			--here it can receive signals to disconnect, modify, create, or remove objects (?)
			--this loop can also be used by the server to detect if connected user(s) disconnect forcefully
		end
	end)
	
	return Network
end