local optionapi = {
	Type = 'Dropdown',
	Value = optionsettings.List[1] or 'None',
	Index = 0
}

local dropdown = Instance.new('TextButton')
dropdown.Name = optionsettings.Name..'Dropdown'
dropdown.Size = UDim2.new(1, api.Category and -8 or 0, 0, 37)
dropdown.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
dropdown.BackgroundTransparency = api.Category and 0 or 1
dropdown.BorderSizePixel = 0
dropdown.AutoButtonColor = false
dropdown.Visible = optionsettings.Visible == nil or optionsettings.Visible
dropdown.Text = ''
dropdown.Parent = children
addTooltip(dropdown, optionsettings.Tooltip or optionsettings.Name)
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, 0, 0, 15)
title.Position = UDim2.fromOffset(0, 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.FontFace = uipallet.Font
title.Parent = dropdown
local bkg = Instance.new('Frame')
bkg.Name = 'BKG'
bkg.Size = UDim2.new(1, -12, 1, -17)
bkg.Position = UDim2.fromOffset(6, 16)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
bkg.BorderSizePixel = 0
bkg.Parent = dropdown
local button = Instance.new('TextButton')
button.Name = 'Dropdown'
button.Size = UDim2.new(1, -2, 1, -2)
button.Position = UDim2.fromOffset(1, 1)
button.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Text = ''
button.Parent = bkg
local valuelabel = Instance.new('TextLabel')
valuelabel.Name = 'Title'
valuelabel.Size = UDim2.new(1, 0, 0, 16)
valuelabel.BackgroundTransparency = 1
valuelabel.Text = optionapi.Value
valuelabel.TextColor3 = uipallet.Text
valuelabel.TextSize = 17
valuelabel.TextTruncate = Enum.TextTruncate.AtEnd
valuelabel.FontFace = uipallet.Font
valuelabel.Parent = button
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

function optionapi:Change(list)
	optionsettings.List = list or {}
	if not table.find(optionsettings.List, self.Value) then
		self:SetValue(self.Value)
	end
end

function optionapi:SetValue(val, mouse)
	self.Value = table.find(optionsettings.List, val) and val or optionsettings.List[1] or 'None'
	valuelabel.Text = self.Value
	if dropdownchildren then
		dropdownchildren:Destroy()
		dropdownchildren = nil
		dropdown.Size = UDim2.new(1, api.Category and -8 or 0, 0, 37)
	end
	optionsettings.Function(self.Value, mouse)
end

button.MouseEnter:Connect(function()
	button.BackgroundColor3 = uipallet.Main
end)
button.MouseLeave:Connect(function()
	button.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
end)
button.MouseButton1Click:Connect(function()
	if not dropdownchildren then
		dropdown.Size = UDim2.new(1, api.Category and -8 or 0, 0, 37 + (#optionsettings.List - 1) * 18)
		dropdownchildren = Instance.new('Frame')
		dropdownchildren.Name = 'Children'
		dropdownchildren.Size = UDim2.new(1, 0, 0, (#optionsettings.List - 1) * 18)
		dropdownchildren.Position = UDim2.fromOffset(0, 18)
		dropdownchildren.BackgroundTransparency = 1
		dropdownchildren.Parent = button
		local ind = 0
		for _, v in optionsettings.List do
			if v == optionapi.Value then continue end
			local dropdownoption = Instance.new('TextButton')
			dropdownoption.Name = v..'Option'
			dropdownoption.Size = UDim2.new(1, 0, 0, 18)
			dropdownoption.Position = UDim2.fromOffset(0, ind * 18)
			dropdownoption.BackgroundColor3 = dropdown.BackgroundColor3
			dropdownoption.BorderSizePixel = 0
			dropdownoption.AutoButtonColor = false
			dropdownoption.Text = v
			dropdownoption.TextColor3 = uipallet.Text
			dropdownoption.TextSize = 17
			dropdownoption.TextTruncate = Enum.TextTruncate.AtEnd
			dropdownoption.FontFace = uipallet.Font
			dropdownoption.Parent = dropdownchildren
			dropdownoption.MouseEnter:Connect(function()
				dropdownoption.BackgroundColor3 = color.Dark(dropdown.BackgroundColor3, 0.02)
			end)
			dropdownoption.MouseLeave:Connect(function()
				dropdownoption.BackgroundColor3 = dropdown.BackgroundColor3
			end)
			dropdownoption.MouseButton1Click:Connect(function()
				optionapi:SetValue(v, true)
			end)
			ind += 1
		end
	else
		optionapi:SetValue(optionapi.Value, true)
	end
end)

optionapi.Object = dropdown
api.Options[optionsettings.Name] = optionapi

return optionapi