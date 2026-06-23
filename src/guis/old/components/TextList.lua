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
textlist.Size = UDim2.new(1, api.Category and -8 or 0, 0, 24)
textlist.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
textlist.BackgroundTransparency = api.Category and 0 or 1
textlist.BorderSizePixel = 0
textlist.AutoButtonColor = false
textlist.Visible = optionsettings.Visible == nil or optionsettings.Visible
textlist.Text = ''
textlist.Parent = children
local label = Instance.new('TextLabel')
label.Size = UDim2.new(1, -12, 1, -4)
label.Position = UDim2.fromOffset(6, 0)
label.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.1)
label.BorderSizePixel = 0
label.Text = " "..optionsettings.Name
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextColor3 = uipallet.Text
label.TextSize = 14
label.FontFace = uipallet.Font
label.Parent = textlist
local listchildren = Instance.new('Frame')
listchildren.Size = UDim2.fromOffset(240, 24)
listchildren.Position = UDim2.fromScale(1, 0)
listchildren.BackgroundColor3 = uipallet.Main
listchildren.BackgroundTransparency = 0.06
listchildren.BorderSizePixel = 0
listchildren.Visible = false
listchildren.Parent = clickgui
optionapi.Window = listchildren
local windowlist = Instance.new('UIListLayout')
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Left
windowlist.Padding = UDim.new(0, 3)
windowlist.Parent = listchildren
local addbkg = Instance.new('Frame')
addbkg.Name = 'Add'
addbkg.Size = UDim2.new(1, 0, 0, 24)
addbkg.BackgroundTransparency = 1
addbkg.BorderSizePixel = 0
addbkg.Parent = listchildren
local addbox = addbkg:Clone()
addbox.Size = UDim2.fromScale(1, 1)
addbox.BackgroundColor3 = uipallet.Main
addbox.BackgroundTransparency = 0.06
addbox.Parent = addbkg
local addvalue = Instance.new('TextBox')
addvalue.Size = UDim2.new(1, -10, 1, 0)
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
	for _, obj in self.Objects do
		obj.Dot.ImageLabel.ImageColor3 = Color3.fromHSV(mainapi:Color(hue))
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
	self.Selected = nil

	for i, v in self.List do
		local enabled = table.find(self.ListEnabled, v)
		local object = Instance.new('TextButton')
		object.Name = v
		object.Size = UDim2.new(1, -14, 0, 24)
		object.BackgroundTransparency = 1
		object.Text = ''
		object.Parent = listchildren
		local objectbkg = Instance.new('Frame')
		objectbkg.Name = 'BKG'
		objectbkg.Size = UDim2.new(1, -30, 1, 0)
		objectbkg.Position = UDim2.fromOffset(4, 0)
		objectbkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.05)
		objectbkg.BorderSizePixel = 0
		objectbkg.Visible = true
		objectbkg.Parent = object
		local objectdot = Instance.new('Frame')
		objectdot.Name = 'Dot'
		objectdot.Size = UDim2.fromOffset(16, 16)
		objectdot.Position = UDim2.fromOffset(8, 4)
		objectdot.BackgroundColor3 = color.Dark(uipallet.Main, 0.1)
		objectdot.BorderSizePixel = 0
		objectdot.Parent = object
		local objectdotin = Instance.new('ImageLabel')
		objectdotin.Size = UDim2.fromScale(1, 1)
		objectdotin.BackgroundTransparency = 1
		objectdotin.Image = getcustomasset('newvape/assets/old/checkbox.png')
		objectdotin.ImageColor3 = uipallet.Text
		objectdotin.Parent = objectdot
		local objecttitle = Instance.new('TextLabel')
		objecttitle.Name = 'Title'
		objecttitle.Size = UDim2.new(1, -28, 1, 0)
		objecttitle.Position = UDim2.fromOffset(28, 0)
		objecttitle.BackgroundTransparency = 1
		objecttitle.Text = v
		objecttitle.TextXAlignment = Enum.TextXAlignment.Left
		objecttitle.TextColor3 = uipallet.Text
		objecttitle.TextSize = 18
		objecttitle.FontFace = uipallet.Font
		objecttitle.Parent = object
		if mainapi.ThreadFix then
			setthreadidentity(8)
		end
		local close = Instance.new('TextButton')
		close.Name = 'Close'
		close.Size = UDim2.fromOffset(24, 24)
		close.Position = UDim2.new(1, -24, 0, 0)
		close.BackgroundColor3 = objectbkg.BackgroundColor3
		close.BorderSizePixel = 0
		close.AutoButtonColor = false
		close.Text = 'x'
		close.TextColor3 = uipallet.Text
		close.TextSize = 14
		close.FontFace = uipallet.Font
		close.Parent = object
		close.MouseButton1Click:Connect(function()
			self:ChangeValue(v)
		end)
		object.MouseButton1Click:Connect(function()
			local ind = table.find(self.ListEnabled, v)
			if ind then
				table.remove(self.ListEnabled, ind)
				objectdotin.Visible = false
			else
				table.insert(self.ListEnabled, v)
				objectdotin.Visible = true
			end
			optionsettings.Function()
		end)
		table.insert(self.Objects, object)
	end
	mainapi:UpdateGUI(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
end

addvalue.FocusLost:Connect(function(enter)
	if enter and not table.find(optionapi.List, addvalue.Text) then
		optionapi:ChangeValue(addvalue.Text)
		addvalue.Text = ''
	end
end)
textlist.MouseButton1Click:Connect(function()
	listchildren.Visible = not listchildren.Visible
end)
textlist:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if mainapi.ThreadFix then
		setthreadidentity(8)
	end
	local actualPosition = (textlist.AbsolutePosition + guiService:GetGuiInset()) / scale.Scale
	listchildren.Position = UDim2.fromOffset(actualPosition.X + textlist.AbsoluteSize.X, actualPosition.Y)
end)
windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if mainapi.ThreadFix then
		setthreadidentity(8)
	end
	listchildren.Size = UDim2.fromOffset(240, math.min((windowlist.AbsoluteContentSize.Y + 6) / scale.Scale, 606))
end)

if optionsettings.Default then
	optionapi:ChangeValue()
end
optionapi.Object = textlist
api.Options[optionsettings.Name] = optionapi

return optionapi