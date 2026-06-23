local optionapi = {
	Type = 'Dropdown',
	Value = optionsettings.List[1] or 'None',
	Index = 0
}

local dropdown = Instance.new('TextButton')
dropdown.Name = optionsettings.Name..'Dropdown'
dropdown.Size = UDim2.new(1, 0, 0, 28)
dropdown.BackgroundTransparency = 1
dropdown.Text = ''
dropdown.Visible = optionsettings.Visible == nil or optionsettings.Visible
dropdown.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 1, 0)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name..': '..optionapi.Value
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = dropdown
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab[optionsettings.Name] = {Value = self.Value}
end

function optionapi:Load(tab)
	if self.Value ~= tab.Value then
		self:SetValue(tab.Value)
	end
end

function optionapi:Change(list)
	optionsettings.List = list or {}
	if not table.find(optionsettings.List, self.Value) then
		self:SetValue(self.Value)
	end
end

function optionapi:SetValue(val, mouse)
	self.Value = table.find(optionsettings.List, val) and val or optionsettings.List[1] or 'None'
	title.Text = optionsettings.Name..': '..self.Value
	optionsettings.Function(self.Value, mouse)
end

dropdown.MouseButton1Click:Connect(function()
	optionapi:SetValue(optionsettings.List[(table.find(optionsettings.List, optionapi.Value) % #optionsettings.List) + 1], true)
end)
dropdown.MouseButton2Click:Connect(function()
	local num = table.find(optionsettings.List, optionapi.Value) - 1
	optionapi:SetValue(optionsettings.List[num < 1 and #optionsettings.List or num], true)
end)

optionapi.Object = dropdown
api.Options[optionsettings.Name] = optionapi

return optionapi