--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.
--]]

if not plugin then
	return error("Please run Verde in a plugin context")
end

local Store = require(script.Parent.store)

-- Setup Plugin Widget
local widgetSettings = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, true, false, 320, 210, 300, 210)
local verdeWidget = plugin:CreateDockWidgetPluginGui("VerdeWidget", widgetSettings)
verdeWidget.Title = "Verde"

-- Setup plugin toolbar
local verdeToolbar = plugin:CreateToolbar("Verde")
local uiToggleBtn = verdeToolbar:CreateButton("Verde", "Toggle Verde UI", "rbxassetid://14205439269")
uiToggleBtn:SetActive(false)

uiToggleBtn.Click:Connect(function()
	local isShown = not (Store.getValue("UIShown") :: boolean)
	Store.set("UIShown", isShown)
	verdeWidget.Enabled = isShown
end)

-- Set initial states
Store.set("UIShown", false)

-- Initialise UI
require(script.Parent.ui.menu)(verdeWidget)
