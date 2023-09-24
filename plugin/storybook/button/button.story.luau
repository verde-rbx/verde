local button = require(script.Parent.Parent.Parent.ui.components.button)
local story = require(script.Parent.Parent.story)
local theme = require(script.Parent.Parent.Parent.theme)

return story(button, {
	Button = {
		Activated = function()
			print("Button pressed")
		end,
	},
	Icon = {
		Image = "rbxassetid://10747384394",
		ImageColor3 = theme.Mid,
	},
})
