local optionapi = {
	Type = 'TextBox',
	Value = optionsettings.Default or '',
	Index = 0
}

local textbox = Instance.new('TextButton')
textbox.Name = optionsettings.Name..'TextBox'
textbox.Size = UDim2.new(1, 0, 0, 60)
textbox.BackgroundTransparency = 1
textbox.Visible = optionsettings.Visible == nil or optionsettings.Visible
textbox.Text = ''
textbox.Parent = children
--addTooltip(textbox, optionsettings.Tooltip)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = textbox
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.fromOffset(60, 15)
title.Position = UDim2.fromOffset(10, 7)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 14
title.FontFace = uipallet.FontSemiBold
title.Parent = textbox
local bkg = Instance.new('Frame')
bkg.Name = 'BKG'
bkg.Size = UDim2.new(1, -22, 0, 26)
bkg.Position = UDim2.fromOffset(11, 28)
bkg.BackgroundColor3 = uipallet.Main
bkg.Parent = textbox
addCorner(bkg, UDim.new(0, 4))
local bkg2 = bkg:Clone()
bkg2.Size = UDim2.new(1, 0, 1, -1)
bkg2.Position = UDim2.fromOffset(0, -1)
bkg2.BackgroundColor3 = Color3.new()
bkg2.Parent = bkg
local box = Instance.new('TextBox')
box.Size = UDim2.new(1, -16, 1, -2)
box.Position = UDim2.fromOffset(8, 0)
box.BackgroundTransparency = 1
box.Text = optionsettings.Default or ''
box.PlaceholderText = optionsettings.Placeholder or 'Click to set'
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextColor3 = uipallet.Text
box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
box.TextSize = 14
box.FontFace = uipallet.FontSemiBold
box.ClearTextOnFocus = false
box.ClipsDescendants = true
box.Parent = bkg
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab[optionsettings.Name] = {Value = self.Value}
end

function optionapi:Load(tab)
	if self.Value ~= tab.Value then
		self:SetValue(tab.Value)
	end
end

function optionapi:SetValue(val, enter)
	self.Value = val
	box.Text = val
	optionsettings.Function(enter)
end

textbox.MouseButton1Click:Connect(function()
	box:CaptureFocus()
end)
box.FocusLost:Connect(function(enter)
	optionapi:SetValue(box.Text, enter)
end)
box:GetPropertyChangedSignal('Text'):Connect(function()
	optionapi:SetValue(box.Text)
end)

optionapi.Object = textbox
api.Options[optionsettings.Name] = optionapi

return optionapi