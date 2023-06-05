local HttpService = game:GetService("HttpService")
local DataLoop = 4

--server closing connections sends a final request to client(s) to shut down on their end

--possibly occasional checks during a set amount of time to ensure the server is still
--  active and receive data from the server's buffer of modified data

--code for determining if addresses are valid may need to be refactored to account for using both http protocols

return function(Frame:typeof(script.Parent.Parent.Frame))
	local Network = {
		Connecting = false;
		Connected = false;
		Address = nil;
	}

	Network.Connect = function(Address:string)
		if Network.Connecting or Network.Connected then return end
		for _,V in pairs(Frame.Status:GetChildren()) do V.Visible = false end
		
		Frame.Status.Connecting.Visible = true
		local Success,Response = pcall(HttpService.GetAsync,HttpService,"http://"..Address.."/requestconnection")
		Frame.Status.Connecting.Visible = false
		print(Success,Response)
		if Success and Response == "azulOK" then
			for _,V in pairs(Frame.Status:GetChildren()) do V.Visible = false end
			Frame.Status.Connected.Visible = true
			Frame.Status.Connected.Text = "Connected to "..Address
			
			Network.Address = "http://"..Address
			Network.Connected = true
			Frame.TextBox.Text = Address
			Frame.TextBox.TextEditable = false
			Frame.Connect.Text = "Disconnect"
			return true
		end
		
		for _,V in pairs(Frame.Status:GetChildren()) do V.Visible = false end
		Frame.Status.Error.Visible = true
		Frame.Status.Error.Text = Response or "Error"
		task.wait(2)
		Frame.Status.Error.Visible = false
		Frame.Status.Error.Text = "Error"
	end
	
	Network.Disconnect = function()
		if Network.Connected then
			for _,V in pairs(Frame.Status:GetChildren()) do V.Visible = false end
			Frame.Status.Disconnected.Visible = true
			Frame.Status.Disconnected.Text = "Disconnected from "..Network.Address

			local Success,Response = pcall(HttpService.PostAsync,HttpService,Network.Address.."/disconnect","some unique id?")
			
			Network.Connected = false
			Network.Address = nil
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
		end
	end)
	
	return Network
end