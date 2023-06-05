local Toolbar : PluginToolbar = plugin:CreateToolbar("azul")
local Button : PluginToolbarButton = Toolbar:CreateButton("azul","","rbxassetid://11425300828")
local Widget = plugin:CreateDockWidgetPluginGui("AddressWidget",DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	false,
	false,
	200,
	100,
	200,
	100
	))

local Frame = require(script.UI)(Toolbar,Button,Widget)
local Network = require(script.Network)(Frame)

Frame.Connect.Activated:Connect(function(Input)
	if Network.Connected then
		Network.Disconnect()
		return
	end
	
	local Text = Frame.TextBox.Text
	local Address = tostring(Text:split(":")[1])
	local Port = tonumber(Text:split(":")[2])
	
	if not Address or not Port or Port > 65_535 or Port == 0 then
		Frame.TextBox.Text = ""
		
		for _,V in Frame.Status:GetChildren() do V.Visible = false end
		Frame.Status.InvalidAddress.Visible = true
		task.wait(2)
		Frame.Status.InvalidAddress.Visible = false
		return
	end
	
	Network.Connect(Text)
end)