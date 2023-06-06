local Toolbar : PluginToolbar = plugin:CreateToolbar("azul")
local Button : PluginToolbarButton = Toolbar:CreateButton("azul","","rbxassetid://13657629843")
local Widget = plugin:CreateDockWidgetPluginGui("azulWidget",DockWidgetPluginGuiInfo.new(
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

Frame.Connect.Activated:Connect(function()
	if Network.Connected then
		Network.Disconnect()
		return
	end
	
	local Success,Protocol,Domain,Port = pcall(function()
		local Text = Frame.TextBox.Text
		local ProtSplit = Text:split("://")
		local PortSplit = ProtSplit[2]:split(":")
		
		local Protocol = ProtSplit[1]
		local Domain = PortSplit[1]
		local Port = tonumber(PortSplit[2])
		return Protocol,Domain,Port
	end)
	Network.Connect(Protocol,Domain,Port)
end)