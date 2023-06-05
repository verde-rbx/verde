return function(Toolbar:PluginToolbar,Button:PluginToolbarButton,Widget)
	local Ui = script.Parent.Parent.Frame

	local TextElements : {TextLabel} = {
		Ui.Status.Connecting;
		Ui.Connect;
		Ui.TextBox;
		Ui.Version;
	}
	local ButtonElements : {GuiButton} = {
		Ui.TextBox;
	}

	Widget.Title = "Connect to azul"
	Ui.Parent = Widget
	Button.ClickableWhenViewportHidden = true
	Ui.Size = UDim2.fromScale(1,1)
	Ui.Position = UDim2.fromScale(.5,.5)

	Button.Click:Connect(function()
		Widget.Enabled = not Widget.Enabled
	end)

	local function UpdateColors()
		local TextColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		local ButtonColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
		for _,TextElement in TextElements do 
			TextElement.TextColor3 = TextColor
		end
		for _,ButtonElement in ButtonElements do 
			ButtonElement.BackgroundColor3 = ButtonColor
		end
	end

	UpdateColors()
	
	return Ui
end