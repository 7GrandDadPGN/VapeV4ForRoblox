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
textlist.Size = UDim2.new(1, 0, 0, 55)
textlist.BackgroundTransparency = 1
textlist.Text = ''
textlist.Visible = optionsettings.Visible == nil or optionsettings.Visible
textlist.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 0, 28)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = textlist
local box = Instance.new('TextBox')
box.Size = UDim2.new(1, -13, 0, 28)
box.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 28)
box.BackgroundTransparency = 1
box.Text = ''
box.PlaceholderText = optionsettings.Placeholder or 'Add entry...'
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextColor3 = color.Dark(uipallet.Text, 0.21)
box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
box.TextSize = 18
box.TextXAlignment = Enum.TextXAlignment.Left
box.FontFace = uipallet.Font
box.ClearTextOnFocus = false
box.Parent = textlist
local children = Instance.new('Frame')
children.Size = UDim2.new()
children.Position = UDim2.fromOffset(0, 55)
children.BackgroundTransparency = 1
children.Parent = textlist
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
	if children.Visible then
		if optionsettings.Profiles then
			if self.Selected then
				self.Selected.TextLabel.TextColor3 = uipallet.MainColor
			end
		else
			for _, object in self.Objects do
				object.Dot.Dot.BackgroundColor3 = uipallet.MainColor
			end
		end
	end
end

function optionapi:ChangeValue(val)
	if val then
		if optionsettings.Profiles then
			local ind = self:GetValue(val)
			if ind then
				if val ~= 'default' then
					table.remove(mainapi.Profiles, ind)
					if isfile('newvape/profiles/'..val..mainapi.Place..'.txt') and delfile then
						delfile('newvape/profiles/'..val..mainapi.Place..'.txt')
					end
				end
			else
				table.insert(mainapi.Profiles, {Name = val, Bind = ''})
			end
		else
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
	end

	optionsettings.Function(self.List)
	for _, v in self.Objects do
		v:Destroy()
	end
	table.clear(self.Objects)
	self.Selected = nil

	local list = (optionsettings.Profiles and mainapi.Profiles or self.List)
	for i, v in list do
		local enabled = table.find(self.ListEnabled, v)
		local object = Instance.new('TextButton')
		object.Size = UDim2.new(1, 0, 0, 28)
		object.Position = UDim2.fromOffset(title.Position.X.Offset + 7, -28 + (i * 28))
		object.BackgroundTransparency = 1
		object.Text = ''
		object.Parent = children
		local objecttitle = Instance.new('TextLabel')
		objecttitle.Size = UDim2.new(1, -13, 1, 0)
		objecttitle.Position = UDim2.fromOffset(13, 0)
		objecttitle.BackgroundTransparency = 1
		objecttitle.Text = optionsettings.Profiles and v.Name or v
		objecttitle.TextColor3 = color.Dark(uipallet.Text, 0.21)
		objecttitle.TextSize = 18
		objecttitle.TextXAlignment = Enum.TextXAlignment.Left
		objecttitle.FontFace = uipallet.Font
		objecttitle.Parent = object
		if optionsettings.Profiles then
			object.MouseButton1Click:Connect(function()
				mainapi:Save(v.Name)
				mainapi:Load(true)
			end)
			object.MouseButton2Click:Connect(function()
				if v.Name ~= mainapi.Profile then
					categoryapi:ChangeValue(v.Name)
				end
			end)
			if v.Name == mainapi.Profile then
				objecttitle.TextColor3 = uipallet.MainColor
				objecttitle.TextStrokeTransparency = 0.5
				self.Selected = object
			end
		else
			local objectdot = Instance.new('Frame')
			objectdot.Name = 'Dot'
			objectdot.Size = UDim2.fromOffset(10, 10)
			objectdot.Position = UDim2.fromOffset(getfontsize(v, 18, uipallet.Font).X + 22, 10)
			objectdot.BackgroundColor3 = uipallet.Main
			objectdot.Parent = object
			addCorner(objectdot, UDim.new(1, 0))
			local objectdotin = objectdot:Clone()
			objectdotin.Size = UDim2.fromOffset(enabled and 10 or 0, enabled and 10 or 0)
			objectdotin.Position = UDim2.fromScale(0.5, 0.5)
			objectdotin.AnchorPoint = Vector2.new(0.5, 0.5)
			objectdotin.BackgroundColor3 = uipallet.MainColor
			objectdotin.Parent = objectdot
			object.MouseButton1Click:Connect(function()
				local ind = table.find(self.ListEnabled, v)
				if ind then
					table.remove(self.ListEnabled, ind)
				else
					table.insert(self.ListEnabled, v)
				end
				objectdotin.Visible = true
				tween:Tween(objectdotin, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
					Size = UDim2.fromOffset((not ind) and 10 or 0, (not ind) and 10 or 0)
				})
				task.delay(0.1, function()
					objectdotin.Visible = objectdotin.Size ~= UDim2.new()
				end)
				optionsettings.Function()
			end)
			object.MouseButton2Click:Connect(function()
				self:ChangeValue(v)
			end)
		end
		table.insert(self.Objects, object)
	end
	children.Size = UDim2.new(1, 0, 0, (#list * 28))
	if children.Visible then
		textlist.Size = UDim2.new(1, 0, 0, 55 + children.Size.Y.Offset)
	end
end

if optionsettings.Profiles then
	function optionapi:GetValue(name)
		for i, v in mainapi.Profiles do
			if v.Name == name then
				return i
			end
		end
	end
end

box.FocusLost:Connect(function(enter)
	if enter and not table.find(optionapi.List, box.Text) then
		optionapi:ChangeValue(box.Text)
		box.Text = ''
	end
end)
textlist.MouseButton1Click:Connect(function()
	children.Visible = not children.Visible
	textlist.Size = UDim2.new(1, 0, 0, 55 + children.Size.Y.Offset)
end)

if optionsettings.Default then
	optionapi:ChangeValue()
end
optionapi.Object = textlist
api.Options[optionsettings.Name] = optionapi

return optionapi