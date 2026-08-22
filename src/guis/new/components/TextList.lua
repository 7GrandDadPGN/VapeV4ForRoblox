local component = {
	Index = getTableSize(api.Options),
	List = props.Default and table.clone(props.Default) or {},
	ListEnabled = props.Default and table.clone(props.Default) or {},
	Objects = {},
	Type = 'TextList',
	Window = {Visible = false}
}

props.Color = props.Color or Color3.fromRGB(5, 134, 105)
local textlist = Instance.new('TextButton')
textlist.AutoButtonColor = false
textlist.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
textlist.BorderSizePixel = 0
textlist.Size = UDim2.new(1, 0, 0, 50)
textlist.Text = ''
textlist.Visible = props.Visible == nil or props.Visible
textlist.Parent = children
component.Object = textlist
addTooltip(textlist, props.Tooltip)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
holder.Position = UDim2.fromOffset(10, 4)
holder.Size = UDim2.new(1, -20, 1, -9)
holder.Parent = textlist
addCorner(holder, UDim.new(0, 4))
local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = uipallet.Main
button.Position = UDim2.fromOffset(1, 1)
button.Size = UDim2.new(1, -2, 1, -2)
button.Text = ''
button.Parent = holder
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/allowediconmini.png')
icon.Position = UDim2.fromOffset(10, 14)
icon.Size = UDim2.fromOffset(14, 12)
icon.Parent = button
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(35, 6)
title.Size = UDim2.new(1, -35, 0, 15)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 15
title.TextTruncate = Enum.TextTruncate.AtEnd
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = button
local amount = Instance.fromExisting(title)
amount.Position = UDim2.fromOffset(0, 6)
amount.Size = UDim2.new(1, -13, 0, 15)
amount.Text = '0'
amount.TextXAlignment = Enum.TextXAlignment.Right
amount.Parent = button
local items = Instance.fromExisting(title)
items.Position = UDim2.fromOffset(35, 21)
items.Text = 'None'
items.TextColor3 = color.Dark(uipallet.Text, 0.43)
items.TextSize = 11
items.Parent = button
addCorner(button, UDim.new(0, 4))
local textlistwindow = Instance.new('TextButton')
textlistwindow.AutoButtonColor = false
textlistwindow.BackgroundColor3 = uipallet.Main
textlistwindow.BorderSizePixel = 0
textlistwindow.Position = UDim2.fromOffset(456, 227)
textlistwindow.Size = UDim2.fromOffset(220, 85)
textlistwindow.Text = ''
textlistwindow.Visible = false
textlistwindow.Parent = api.Legit and vape.Legit.Window or clickgui
component.Window = textlistwindow
addBlur(textlistwindow)
addCorner(textlistwindow)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/allowedicon.png')
icon.Position = UDim2.fromOffset(10, 13)
icon.Size = UDim2.fromOffset(19, 16)
icon.Parent = textlistwindow
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(36, 11)
title.Size = UDim2.new(1, -36, 0, 20)
title.Text = props.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = textlistwindow
local close = addCloseButton(textlistwindow)
local boxholder = Instance.new('Frame')
boxholder.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
boxholder.Position = UDim2.fromOffset(10, 45)
boxholder.Size = UDim2.fromOffset(200, 31)
boxholder.Parent = textlistwindow
addCorner(boxholder)
local boxinner = Instance.new('Frame')
boxinner.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
boxinner.Position = UDim2.fromOffset(1, 1)
boxinner.Size = UDim2.new(1, -2, 1, -2)
boxinner.Parent = boxholder
addCorner(boxinner)
local textbox = Instance.new('TextBox')
textbox.BackgroundTransparency = 1
textbox.ClearTextOnFocus = false
textbox.FontFace = uipallet.Font
textbox.PlaceholderText = props.Placeholder or 'Add entry...'
textbox.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
textbox.Position = UDim2.fromOffset(10, 0)
textbox.Size = UDim2.new(1, -35, 1, 0)
textbox.Text = ''
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.TextSize = 13
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.Parent = boxholder
local add = Instance.new('ImageButton')
add.BackgroundTransparency = 1
add.Image = getvapeasset('newvape/assets/new/add.png')
add.ImageColor3 = props.Color
add.ImageTransparency = 0.3
add.Position = UDim2.new(1, -26, 0, 8)
add.Size = UDim2.fromOffset(16, 16)
add.Parent = boxholder
props.Function = props.Function or function() end

function component:Color(hue, sat, val, isRainbow)
	if textlistwindow.Visible then
		holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	end
end

function component:ChangeValue(value)
	if value then
		local index = table.find(self.List, value)
		if index then
			table.remove(self.List, index)

			index = table.find(self.ListEnabled, value)
			if index then
				table.remove(self.ListEnabled, index)
			end
		else
			table.insert(self.List, value)
			table.insert(self.ListEnabled, value)
		end
	end

	props.Function(self.List)
	for _, v in self.Objects do
		v:Destroy()
	end
	table.clear(self.Objects)
	textlistwindow.Size = UDim2.fromOffset(220, 85 + (#self.List * 35))
	amount.Text = #self.List
	items.Text = #self.ListEnabled > 0 and table.concat(self.ListEnabled, ', ') or 'None'

	for index, value in self.List do
		local isEnabled = table.find(self.ListEnabled, value)
		local obj = Instance.new('TextButton')
		obj.AutoButtonColor = false
		obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		obj.Position = UDim2.fromOffset(10, 47 + (index * 35))
		obj.Size = UDim2.fromOffset(200, 31)
		obj.Text = ''
		obj.Parent = textlistwindow
		addCorner(obj)
		local bkg = Instance.new('Frame')
		bkg.BackgroundColor3 = uipallet.Main
		bkg.Position = UDim2.fromOffset(1, 1)
		bkg.Size = UDim2.new(1, -2, 1, -2)
		bkg.Visible = false
		bkg.Parent = obj
		addCorner(bkg)
		local dot = Instance.new('Frame')
		dot.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.37)
		dot.Position = UDim2.fromOffset(10, 12)
		dot.Size = UDim2.fromOffset(10, 11)
		dot.Parent = obj
		addCorner(dot, UDim.new(1, 0))
		local dotin = dot:Clone()
		dotin.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.02)
		dotin.Position = UDim2.fromOffset(1, 1)
		dotin.Size = UDim2.fromOffset(8, 9)
		dotin.Parent = dot
		local label = Instance.new('TextLabel')
		label.BackgroundTransparency = 1
		label.FontFace = uipallet.Font
		label.Position = UDim2.fromOffset(30, 0)
		label.Size = UDim2.new(1, -30, 1, 0)
		label.Text = value
		label.TextColor3 = color.Dark(uipallet.Text, 0.16)
		label.TextSize = 15
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = obj
		local close = Instance.new('ImageButton')
		close.AutoButtonColor = false
		close.BackgroundColor3 = Color3.new(1, 1, 1)
		close.BackgroundTransparency = 1
		close.Image = getvapeasset('newvape/assets/new/closetiny.png')
		close.ImageColor3 = color.Light(uipallet.Text, 0.2)
		close.ImageTransparency = 0.5
		close.Position = UDim2.new(1, -27, 0, 8)
		close.Size = UDim2.fromOffset(18, 17)
		close.Parent = obj
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
			self:ChangeValue(value)
		end)

		obj.MouseEnter:Connect(function()
			bkg.Visible = true
		end)

		obj.MouseLeave:Connect(function()
			bkg.Visible = false
		end)

		obj.MouseButton1Click:Connect(function()
			local index = table.find(self.ListEnabled, value)
			if index then
				table.remove(self.ListEnabled, index)
				dot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
				dotin.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			else
				table.insert(self.ListEnabled, value)
				dot.BackgroundColor3 = props.Color
				dotin.BackgroundColor3 = props.Color
			end

			items.Text = #self.ListEnabled > 0 and table.concat(self.ListEnabled, ', ') or 'None'
			props.Function(self.List)
		end)

		table.insert(self.Objects, obj)
	end
end

function component:Load(data)
	self.List = data.List or {}
	self.ListEnabled = data.ListEnabled or {}
	self:ChangeValue()
end

function component:Save(data)
	data[props.Name] = {
		List = self.List,
		ListEnabled = self.ListEnabled
	}
end

add.MouseEnter:Connect(function()
	add.ImageTransparency = 0
end)

add.MouseLeave:Connect(function()
	add.ImageTransparency = 0.3
end)

add.MouseButton1Click:Connect(function()
	if not table.find(component.List, textbox.Text) then
		component:ChangeValue(textbox.Text)
		textbox.Text = ''
	end
end)

textbox.FocusLost:Connect(function(enter)
	if enter and not table.find(component.List, textbox.Text) then
		component:ChangeValue(textbox.Text)
		textbox.Text = ''
	end
end)

textbox.MouseEnter:Connect(function()
	tween:Tween(boxholder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.14)
	})
end)

textbox.MouseLeave:Connect(function()
	tween:Tween(boxholder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	})
end)

close.MouseButton1Click:Connect(function()
	textlistwindow.Visible = false
end)

button.MouseButton1Click:Connect(function()
	textlistwindow.Visible = not textlistwindow.Visible

	tween:Cancel(holder)
	holder.BackgroundColor3 = textlistwindow.Visible and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
end)

textlist.MouseEnter:Connect(function()
	if not textlistwindow.Visible then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)

textlist.MouseLeave:Connect(function()
	if not textlistwindow.Visible then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		})
	end
end)

textlist:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local actualPosition = (textlist.AbsolutePosition - (api.Legit and vape.Legit.Window.AbsolutePosition or -guiService:GetGuiInset())) / scale.Scale
	textlistwindow.Position = UDim2.fromOffset(actualPosition.X + 223, actualPosition.Y)
end)

if props.Default then
	component:ChangeValue()
end

api.Options[props.Name] = component

return component