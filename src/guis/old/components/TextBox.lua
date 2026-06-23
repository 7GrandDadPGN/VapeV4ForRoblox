local optionapi = {
	Type = 'TextBox',
	Value = optionsettings.Default or '',
	Index = 0
}

local textbox = Instance.new('TextButton')
textbox.Name = optionsettings.Name..'TextBox'
textbox.Size = UDim2.new(1, api.Category and -8 or 0, 0, 37)
textbox.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
textbox.BackgroundTransparency = api.Category and 0 or 1
textbox.BorderSizePixel = 0
textbox.AutoButtonColor = false
textbox.Visible = optionsettings.Visible == nil or optionsettings.Visible
textbox.Text = ''
textbox.Parent = children
addTooltip(textbox, optionsettings.Tooltip)
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, 0, 0, 15)
title.Position = UDim2.fromOffset(0, 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.FontFace = uipallet.Font
title.Parent = textbox
local bkg = Instance.new('Frame')
bkg.Name = 'BKG'
bkg.Size = UDim2.new(1, -12, 1, -17)
bkg.Position = UDim2.fromOffset(6, 16)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
bkg.BorderSizePixel = 0
bkg.Parent = textbox
local box = Instance.new('TextBox')
box.Size = UDim2.new(1, -2, 1, -2)
box.Position = UDim2.fromOffset(1, 1)
box.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
box.BorderSizePixel = 0
box.Text = optionapi.Value
box.PlaceholderText = optionsettings.Placeholder or 'Click to set'
box.TextColor3 = uipallet.Text
box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
box.TextSize = 17
box.FontFace = uipallet.Font
box.ClearTextOnFocus = false
box.Parent = bkg
optionsettings.Function = optionsettings.Function or function() end
local dropdownchildren

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