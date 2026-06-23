local optionapi = {
	Type = 'Dropdown',
	Value = optionsettings.List[1] or 'None',
	Index = 0
}

local dropdown = Instance.new('TextButton')
dropdown.Name = optionsettings.Name..'Dropdown'
dropdown.Size = UDim2.new(1, 0, 0, 41)
dropdown.BackgroundTransparency = 1
dropdown.Visible = optionsettings.Visible == nil or optionsettings.Visible
dropdown.Text = ''
dropdown.Parent = children
--addTooltip(dropdown, optionsettings.Tooltip or optionsettings.Name)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = dropdown
local button = Instance.new('TextButton')
button.Name = 'Dropdown'
button.Size = UDim2.new(1, -22, 1, -14)
button.Position = UDim2.fromOffset(11, 7)
button.BackgroundColor3 = uipallet.Main
button.AutoButtonColor = false
button.Text = ''
button.Parent = dropdown
addCorner(button, UDim.new(0, 4))
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, -10, 0, 27)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name..' · '..optionapi.Value
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 14
title.TextTruncate = Enum.TextTruncate.AtEnd
title.FontFace = uipallet.FontSemiBold
title.Parent = button
local dropdownexpand = Instance.new('ImageButton')
dropdownexpand.Size = UDim2.fromOffset(6, 10)
dropdownexpand.Position = UDim2.new(1, -15, 0, 14)
dropdownexpand.AnchorPoint = Vector2.new(0.5, 0.5)
dropdownexpand.BackgroundTransparency = 1
dropdownexpand.Image = getcustomasset('newvape/assets/liquidbounce/expand.png')
dropdownexpand.Parent = button
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
	title.Text = optionsettings.Name..' · '..self.Value
	if dropdownchildren then
		dropdownchildren:Destroy()
		dropdownchildren = nil
		dropdown.Size = UDim2.new(1, 0, 0, 41)
	end
	optionsettings.Function(self.Value, mouse)
end

button.MouseButton1Click:Connect(function()
	if not dropdownchildren then
		dropdown.Size = UDim2.new(1, 0, 0, 45 + #optionsettings.List * 30)
		dropdownchildren = Instance.new('Frame')
		dropdownchildren.Name = 'Children'
		dropdownchildren.Size = UDim2.new(1, -2, 0, 3 + #optionsettings.List * 30)
		dropdownchildren.Position = UDim2.fromOffset(1, 27)
		dropdownchildren.BackgroundColor3 = Color3.new()
		dropdownchildren.BorderSizePixel = 0
		dropdownchildren.Parent = button
		addCorner(dropdownchildren, UDim.new(0, 5))
		local ind = 0
		for _, v in optionsettings.List do
			local dropdownoption = Instance.new('TextButton')
			dropdownoption.Name = v..'Option'
			dropdownoption.Size = UDim2.new(1, 0, 0, 30)
			dropdownoption.Position = UDim2.fromOffset(0, ind * 30)
			dropdownoption.BackgroundColor3 = Color3.new()
			dropdownoption.BorderSizePixel = 0
			dropdownoption.AutoButtonColor = false
			dropdownoption.Text = v
			dropdownoption.TextColor3 = v == optionapi.Value and uipallet.Main or color.Dark(uipallet.Text, 0.2)
			dropdownoption.TextSize = 14
			dropdownoption.TextTruncate = Enum.TextTruncate.AtEnd
			dropdownoption.FontFace = uipallet.FontSemiBold
			dropdownoption.Parent = dropdownchildren
			dropdownoption.MouseButton1Click:Connect(function()
				optionapi:SetValue(v, true)
				tween:Tween(dropdownexpand, createTween(0.4), {
					Rotation = 0
				}, tween.tweenstwo)
			end)
			ind += 1
		end
	else
		optionapi:SetValue(optionapi.Value, true)
	end

	tween:Tween(dropdownexpand, createTween(0.4), {
		Rotation = dropdownchildren and 90 or 0
	}, tween.tweenstwo)
end)

optionapi.Object = dropdown
api.Options[optionsettings.Name] = optionapi

return optionapi