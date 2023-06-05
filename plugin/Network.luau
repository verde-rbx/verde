local HttpService = game:GetService("HttpService")

return function(Frame:typeof(script.Parent.Parent.Frame))
	local Network = {}

	Network.Connect = function(Address:string)
		Frame.Status.Connecting.Visible = true
		local Success,Response = pcall(HttpService.GetAsync,HttpService,"https://"..Address.."/requestconnection")
		Frame.Status.Connecting.Visible = false
		if Success then
			Frame.Status.Connected.Visible = true
			plugin:SetSetting("LastAddress",Address)
			Frame.TextBox.Text = Address
			return true
		end

		Frame.Status.Error.Visible = true
		task.wait(2)
		Frame.Status.Error.Visible = false
	end
	

	return Network
end