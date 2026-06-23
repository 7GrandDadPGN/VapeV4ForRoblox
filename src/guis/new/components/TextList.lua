local optionapi = {
	Type = 'TextList',
	List = optionsettings.Default or {},
	ListEnabled = optionsettings.Default or {},
	Objects = {},
	Window = {Visible = false},
	Index = getTableSize(api.Options)
}
optionsettings.Color = optionsettings.Color or Color3.fromRGB(5, 134, 105)

local textlist = Instance.new('TextButton')
textlist.Name = optionsettings.Name..'TextList'
textlist.Size = UDim2.new(1, 0, 0, 50)
textlist.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
textlist.BorderSizePixel = 0
textlist.AutoButtonColor = false
textlist.Visible = optionsettings.Visible == nil or optionsettings.Visible
textlist.Text = ''
textlist.Parent = children
addTooltip(textlist, optionsettings.Tooltip)
local bkg = Instance.new('Frame')
bkg.Name = 'BKG'
bkg.Size = UDim2.new(1, -20, 1, -9)
bkg.Position = UDim2.fromOffset(10, 4)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
bkg.Parent = textlist
addCorner(bkg, UDim.new(0, 4))
local button = Instance.new('TextButton')
button.Name = 'TextList'
button.Size = UDim2.new(1, -2, 1, -2)
button.Position = UDim2.fromOffset(1, 1)
button.BackgroundColor3 = uipallet.Main
button.AutoButtonColor = false
button.Text = ''
button.Parent = bkg
local buttonicon = Instance.new('ImageLabel')
buttonicon.Name = 'Icon'
buttonicon.Size = UDim2.fromOffset(14, 12)
buttonicon.Position = UDim2.fromOffset(10, 14)
buttonicon.BackgroundTransparency = 1
buttonicon.Image = optionsettings.Icon or getcustomasset('newvape/assets/new/allowedicon.png')
buttonicon.Parent = button
local buttontitle = Instance.new('TextLabel')
buttontitle.Name = 'Title'
buttontitle.Size = UDim2.new(1, -35, 0, 15)
buttontitle.Position = UDim2.fromOffset(35, 6)
buttontitle.BackgroundTransparency = 1
buttontitle.Text = optionsettings.Name
buttontitle.TextXAlignment = Enum.TextXAlignment.Left
buttontitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
buttontitle.TextSize = 15
buttontitle.TextTruncate = Enum.TextTruncate.AtEnd
buttontitle.FontFace = uipallet.Font
buttontitle.Parent = button
local amount = buttontitle:Clone()
amount.Name = 'Amount'
amount.Size = UDim2.new(1, -13, 0, 15)
amount.Position = UDim2.fromOffset(0, 6)
amount.Text = '0'
amount.TextXAlignment = Enum.TextXAlignment.Right
amount.Parent = button
local items = buttontitle:Clone()
items.Name = 'Items'
items.Position = UDim2.fromOffset(35, 21)
items.Text = 'None'
items.TextColor3 = color.Dark(uipallet.Text, 0.43)
items.TextSize = 11
items.Parent = button
addCorner(button, UDim.new(0, 4))
local window = Instance.new('TextButton')
window.Name = optionsettings.Name..'TextWindow'
window.Size = UDim2.fromOffset(220, 85)
window.BackgroundColor3 = uipallet.Main
window.BorderSizePixel = 0
window.AutoButtonColor = false
window.Visible = false
window.Text = ''
window.Parent = api.Legit and mainapi.Legit.Window or clickgui
optionapi.Window = window
addBlur(window)
addCorner(window)
local icon = Instance.new('ImageLabel')
icon.Name = 'Icon'
icon.Size = optionsettings.TabSize or UDim2.fromOffset(19, 16)
icon.Position = UDim2.fromOffset(10, 13)
icon.BackgroundTransparency = 1
icon.Image = optionsettings.Tab or getcustomasset('newvape/assets/new/allowedtab.png')
icon.Parent = window
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, -36, 0, 20)
title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 11)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.FontFace = uipallet.Font
title.Parent = window
local close = addCloseButton(window)
local addbkg = Instance.new('Frame')
addbkg.Name = 'Add'
addbkg.Size = UDim2.fromOffset(200, 31)
addbkg.Position = UDim2.fromOffset(10, 45)
addbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
addbkg.Parent = window
addCorner(addbkg)
local addbox = addbkg:Clone()
addbox.Size = UDim2.new(1, -2, 1, -2)
addbox.Position = UDim2.fromOffset(1, 1)
addbox.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
addbox.Parent = addbkg
local addvalue = Instance.new('TextBox')
addvalue.Size = UDim2.new(1, -35, 1, 0)
addvalue.Position = UDim2.fromOffset(10, 0)
addvalue.BackgroundTransparency = 1
addvalue.Text = ''
addvalue.PlaceholderText = optionsettings.Placeholder or 'Add entry...'
addvalue.TextXAlignment = Enum.TextXAlignment.Left
addvalue.TextColor3 = Color3.new(1, 1, 1)
addvalue.TextSize = 15
addvalue.FontFace = uipallet.Font
addvalue.ClearTextOnFocus = false
addvalue.Parent = addbkg
local addbutton = Instance.new('ImageButton')
addbutton.Name = 'AddButton'
addbutton.Size = UDim2.fromOffset(16, 16)
addbutton.Position = UDim2.new(1, -26, 0, 8)
addbutton.BackgroundTransparency = 1
addbutton.Image = getcustomasset('newvape/assets/new/add.png')
addbutton.ImageColor3 = optionsettings.Color
addbutton.ImageTransparency = 0.3
addbutton.Parent = addbkg
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab[optionsettings.Name] = {
		List = self.List,
		ListEnabled = self.ListEnabled
	}
end

function optionapi:Load(tab)
	self.List = tab.List or {}
	self.ListEnabled = tab.ListEnabled or {}
	self:ChangeValue()
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	if window.Visible then
		bkg.BackgroundColor3 = rainbowcheck and Color3.fromHSV(mainapi:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	end
end

function optionapi:ChangeValue(val)
	if val then
		local ind = table.find(self.List, val)
		if ind then
			table.remove(self.List, ind)
			ind = table.find(self.ListEnabled, val)
			if ind then
				table.remove(self.ListEnabled, ind)
			end
		else
			table.insert(self.List, val)
			table.insert(self.ListEnabled, val)
		end
	end

	optionsettings.Function(self.List)
	for _, v in self.Objects do
		v:Destroy()
	end
	table.clear(self.Objects)
	window.Size = UDim2.fromOffset(220, 85 + (#self.List * 35))
	amount.Text = #self.List

	local enabledtext = 'None'
	for i, v in self.ListEnabled do
		if i == 1 then enabledtext = '' end
		enabledtext = enabledtext..(i == 1 and v or ', '..v)
	end
	items.Text = enabledtext

	for i, v in self.List do
		local enabled = table.find(self.ListEnabled, v)
		local object = Instance.new('TextButton')
		object.Name = v
		object.Size = UDim2.fromOffset(200, 32)
		object.Position = UDim2.fromOffset(10, 47 + (i * 35))
		object.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		object.AutoButtonColor = false
		object.Text = ''
		object.Parent = window
		addCorner(object)
		local objectbkg = Instance.new('Frame')
		objectbkg.Name = 'BKG'
		objectbkg.Size = UDim2.new(1, -2, 1, -2)
		objectbkg.Position = UDim2.fromOffset(1, 1)
		objectbkg.BackgroundColor3 = uipallet.Main
		objectbkg.Visible = false
		objectbkg.Parent = object
		addCorner(objectbkg)
		local objectdot = Instance.new('Frame')
		objectdot.Name = 'Dot'
		objectdot.Size = UDim2.fromOffset(10, 11)
		objectdot.Position = UDim2.fromOffset(10, 12)
		objectdot.BackgroundColor3 = enabled and optionsettings.Color or color.Light(uipallet.Main, 0.37)
		objectdot.Parent = object
		addCorner(objectdot, UDim.new(1, 0))
		local objectdotin = objectdot:Clone()
		objectdotin.Size = UDim2.fromOffset(8, 9)
		objectdotin.Position = UDim2.fromOffset(1, 1)
		objectdotin.BackgroundColor3 = enabled and optionsettings.Color or color.Light(uipallet.Main, 0.02)
		objectdotin.Parent = objectdot
		local objecttitle = Instance.new('TextLabel')
		objecttitle.Name = 'Title'
		objecttitle.Size = UDim2.new(1, -30, 1, 0)
		objecttitle.Position = UDim2.fromOffset(30, 0)
		objecttitle.BackgroundTransparency = 1
		objecttitle.Text = v
		objecttitle.TextXAlignment = Enum.TextXAlignment.Left
		objecttitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
		objecttitle.TextSize = 15
		objecttitle.FontFace = uipallet.Font
		objecttitle.Parent = object
		local close = Instance.new('ImageButton')
		close.Name = 'Close'
		close.Size = UDim2.fromOffset(16, 16)
		close.Position = UDim2.new(1, -26, 0, 8)
		close.BackgroundColor3 = Color3.new(1, 1, 1)
		close.BackgroundTransparency = 1
		close.AutoButtonColor = false
		close.Image = getcustomasset('newvape/assets/new/closemini.png')
		close.ImageColor3 = color.Light(uipallet.Text, 0.2)
		close.ImageTransparency = 0.5
		close.Parent = object
		addCorner(close, UDim.new(1, 0))

		close.MouseEnter:Connect(function()
			close.ImageTransparency = 0.3
			tween:Tween(close, uipallet.Tween, {
				BackgroundTransparency = 0.6
			})
		end)
		close.MouseLeave:Connect(function()
			close.ImageTransparency = 0.5
			tween:Tween(close, uipallet.Tween, {
				BackgroundTransparency = 1
			})
		end)
		close.MouseButton1Click:Connect(function()
			self:ChangeValue(v)
		end)
		object.MouseEnter:Connect(function()
			objectbkg.Visible = true
		end)
		object.MouseLeave:Connect(function()
			objectbkg.Visible = false
		end)
		object.MouseButton1Click:Connect(function()
			local ind = table.find(self.ListEnabled, v)
			if ind then
				table.remove(self.ListEnabled, ind)
				objectdot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				objectdotin.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			else
				table.insert(self.ListEnabled, v)
				objectdot.BackgroundColor3 = optionsettings.Color
				objectdotin.BackgroundColor3 = optionsettings.Color
			end

			local enabledtext = 'None'
			for i, v in self.ListEnabled do
				if i == 1 then enabledtext = '' end
				enabledtext = enabledtext..(i == 1 and v or ', '..v)
			end

			items.Text = enabledtext
			optionsettings.Function()
		end)

		table.insert(self.Objects, object)
	end
end

addbutton.MouseEnter:Connect(function()
	addbutton.ImageTransparency = 0
end)
addbutton.MouseLeave:Connect(function()
	addbutton.ImageTransparency = 0.3
end)
addbutton.MouseButton1Click:Connect(function()
	if not table.find(optionapi.List, addvalue.Text) then
		optionapi:ChangeValue(addvalue.Text)
		addvalue.Text = ''
	end
end)
addvalue.FocusLost:Connect(function(enter)
	if enter and not table.find(optionapi.List, addvalue.Text) then
		optionapi:ChangeValue(addvalue.Text)
		addvalue.Text = ''
	end
end)
addvalue.MouseEnter:Connect(function()
	tween:Tween(addbkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.14)
	})
end)
addvalue.MouseLeave:Connect(function()
	tween:Tween(addbkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	})
end)
close.MouseButton1Click:Connect(function()
	window.Visible = false
end)
button.MouseButton1Click:Connect(function()
	window.Visible = not window.Visible
	tween:Cancel(bkg)
	bkg.BackgroundColor3 = window.Visible and Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
end)
textlist.MouseEnter:Connect(function()
	if not optionapi.Window.Visible then
		tween:Tween(bkg, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)
textlist.MouseLeave:Connect(function()
	if not optionapi.Window.Visible then
		tween:Tween(bkg, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		})
	end
end)
textlist:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if mainapi.ThreadFix then
		setthreadidentity(8)
	end
	local actualPosition = (textlist.AbsolutePosition - (api.Legit and mainapi.Legit.Window.AbsolutePosition or -guiService:GetGuiInset())) / scale.Scale
	window.Position = UDim2.fromOffset(actualPosition.X + 220, actualPosition.Y)
end)

if optionsettings.Default then
	optionapi:ChangeValue()
end
optionapi.Object = textlist
api.Options[optionsettings.Name] = optionapi

return optionapi