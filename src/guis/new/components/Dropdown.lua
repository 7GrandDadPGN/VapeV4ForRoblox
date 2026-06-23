local optionapi = {
	Type = 'Dropdown',
	Value = optionsettings.List[1] or 'None',
	Index = 0
}

local dropdown = Instance.new('TextButton')
dropdown.Name = optionsettings.Name..'Dropdown'
dropdown.Size = UDim2.new(1, 0, 0, 40)
dropdown.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
dropdown.BorderSizePixel = 0
dropdown.AutoButtonColor = false
dropdown.Visible = optionsettings.Visible == nil or optionsettings.Visible
dropdown.Text = ''
dropdown.Parent = children
addTooltip(dropdown, optionsettings.Tooltip or optionsettings.Name)
local bkg = Instance.new('Frame')
bkg.Name = 'BKG'
bkg.Size = UDim2.new(1, -20, 1, -9)
bkg.Position = UDim2.fromOffset(10, 4)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
bkg.Parent = dropdown
addCorner(bkg, UDim.new(0, 6))
local button = Instance.new('TextButton')
button.Name = 'Dropdown'
button.Size = UDim2.new(1, -2, 1, -2)
button.Position = UDim2.fromOffset(1, 1)
button.BackgroundColor3 = uipallet.Main
button.AutoButtonColor = false
button.Text = ''
button.Parent = bkg
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, 0, 0, 29)
title.BackgroundTransparency = 1
title.Text = '         '..optionsettings.Name..' - '..optionapi.Value
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 13
title.TextTruncate = Enum.TextTruncate.AtEnd
title.FontFace = uipallet.Font
title.Parent = button
addCorner(button, UDim.new(0, 6))
local arrow = Instance.new('ImageLabel')
arrow.Name = 'Arrow'
arrow.Size = UDim2.fromOffset(4, 8)
arrow.Position = UDim2.new(1, -17, 0, 11)
arrow.BackgroundTransparency = 1
arrow.Image = getcustomasset('newvape/assets/new/expandright.png')
arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
arrow.Rotation = 90
arrow.Parent = button
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
	title.Text = '         '..optionsettings.Name..' - '..self.Value
	if dropdownchildren then
		arrow.Rotation = 90
		dropdownchildren:Destroy()
		dropdownchildren = nil
		dropdown.Size = UDim2.new(1, 0, 0, 40)
	end
	optionsettings.Function(self.Value, mouse)
end

button.MouseButton1Click:Connect(function()
	if not dropdownchildren then
		arrow.Rotation = 270
		dropdown.Size = UDim2.new(1, 0, 0, 40 + (#optionsettings.List - 1) * 26)
		dropdownchildren = Instance.new('Frame')
		dropdownchildren.Name = 'Children'
		dropdownchildren.Size = UDim2.new(1, 0, 0, (#optionsettings.List - 1) * 26)
		dropdownchildren.Position = UDim2.fromOffset(0, 27)
		dropdownchildren.BackgroundTransparency = 1
		dropdownchildren.Parent = button
		local ind = 0
		for _, v in optionsettings.List do
			if v == optionapi.Value then continue end
			local dropdownoption = Instance.new('TextButton')
			dropdownoption.Name = v..'Option'
			dropdownoption.Size = UDim2.new(1, 0, 0, 26)
			dropdownoption.Position = UDim2.fromOffset(0, ind * 26)
			dropdownoption.BackgroundColor3 = uipallet.Main
			dropdownoption.BorderSizePixel = 0
			dropdownoption.AutoButtonColor = false
			dropdownoption.Text = '         '..v
			dropdownoption.TextXAlignment = Enum.TextXAlignment.Left
			dropdownoption.TextColor3 = color.Dark(uipallet.Text, 0.16)
			dropdownoption.TextSize = 13
			dropdownoption.TextTruncate = Enum.TextTruncate.AtEnd
			dropdownoption.FontFace = uipallet.Font
			dropdownoption.Parent = dropdownchildren
			dropdownoption.MouseEnter:Connect(function()
				tween:Tween(dropdownoption, uipallet.Tween, {
					BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				})
			end)
			dropdownoption.MouseLeave:Connect(function()
				tween:Tween(dropdownoption, uipallet.Tween, {
					BackgroundColor3 = uipallet.Main
				})
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
dropdown.MouseEnter:Connect(function()
	tween:Tween(bkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
	})
end)
dropdown.MouseLeave:Connect(function()
	tween:Tween(bkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.034)
	})
end)

optionapi.Object = dropdown
api.Options[optionsettings.Name] = optionapi

return optionapi