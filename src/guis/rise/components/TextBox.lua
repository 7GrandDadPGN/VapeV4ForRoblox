local optionapi = {
	Type = 'TextBox',
	Value = optionsettings.Default or '',
	Index = 0
}

local textbox = Instance.new('TextButton')
textbox.Name = optionsettings.Name..'TextBox'
textbox.Size = UDim2.new(1, 0, 0, 55)
textbox.BackgroundTransparency = 1
textbox.Text = ''
textbox.Visible = optionsettings.Visible == nil or optionsettings.Visible
textbox.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 1, -27)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = textbox
local box = Instance.new('TextBox')
box.Size = UDim2.new(1, -13, 1, -28)
box.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 28)
box.BackgroundTransparency = 1
box.Text = optionsettings.Default or ''
box.PlaceholderText = optionsettings.Placeholder or 'Click to set'
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextColor3 = color.Dark(uipallet.Text, 0.21)
box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
box.TextSize = 18
box.TextXAlignment = Enum.TextXAlignment.Left
box.FontFace = uipallet.Font
box.ClearTextOnFocus = false
box.Parent = textbox
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