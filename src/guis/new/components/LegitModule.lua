vape:Remove(props.Name)
local component = {
	Enabled = false,
	Legit = true,
	Name = props.Name,
	Options = {},
	Type = 'LegitModule'
}

local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
button.Name = props.Name
button.Text = ''
button.Parent = children
component.Object = button
addTooltip(button, props.Tooltip, nil, function()
	return vape.LegitVisible
end)
addCorner(button)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(16, 81)
title.Size = UDim2.new(1, -16, 0, 20)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.31)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = button
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
holder.Position = UDim2.new(1, -57, 0, 15)
holder.Size = UDim2.fromOffset(22, 12)
holder.Parent = button
addCorner(holder, UDim.new(1, 0))
local knob = Instance.new('Frame')
knob.BackgroundColor3 = uipallet.Main
knob.Position = UDim2.fromOffset(2, 2)
knob.Size = UDim2.fromOffset(8, 8)
knob.Parent = holder
addCorner(knob, UDim.new(1, 0))
local dotsbutton = Instance.new('TextButton')
dotsbutton.BackgroundTransparency = 1
dotsbutton.Name = 'Dots'
dotsbutton.Position = UDim2.new(1, -27, 0, 9)
dotsbutton.Size = UDim2.fromOffset(14, 24)
dotsbutton.Text = ''
dotsbutton.Parent = button
local dots = Instance.new('ImageLabel')
dots.BackgroundTransparency = 1
dots.Image = getvapeasset('newvape/assets/new/overlaydots.png')
dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
dots.Name = 'Dots'
dots.Position = UDim2.fromOffset(6, 6)
dots.Size = UDim2.fromOffset(2, 12)
dots.Parent = dotsbutton
local shadow = Instance.new('TextButton')
shadow.Name = 'Shadow'
shadow.Size = UDim2.new(1, 0, 1, -5)
shadow.BackgroundColor3 = Color3.new()
shadow.BackgroundTransparency = 1
shadow.AutoButtonColor = false
shadow.ClipsDescendants = true
shadow.Visible = false
shadow.Text = ''
shadow.Parent = api.Window
addCorner(shadow)
local settingspane = Instance.new('TextButton')
settingspane.Size = UDim2.new(0, 220, 1, 0)
settingspane.Position = UDim2.fromScale(1, 0)
settingspane.BackgroundColor3 = uipallet.Main
settingspane.AutoButtonColor = false
settingspane.Text = ''
settingspane.Parent = shadow
local settingstitle = Instance.new('TextLabel')
settingstitle.Name = 'Title'
settingstitle.Size = UDim2.new(1, -36, 0, 20)
settingstitle.Position = UDim2.fromOffset(36, 12)
settingstitle.BackgroundTransparency = 1
settingstitle.Text = props.Name
settingstitle.TextXAlignment = Enum.TextXAlignment.Left
settingstitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
settingstitle.TextSize = 13
settingstitle.FontFace = uipallet.Font
settingstitle.Parent = settingspane
local back = Instance.new('ImageButton')
back.Name = 'Back'
back.Size = UDim2.fromOffset(16, 16)
back.Position = UDim2.fromOffset(11, 13)
back.BackgroundTransparency = 1
back.Image = getvapeasset('newvape/assets/new/back.png')
back.ImageColor3 = color.Light(uipallet.Main, 0.37)
back.Parent = settingspane
addCorner(settingspane)
local settingschildren = Instance.new('ScrollingFrame')
settingschildren.BackgroundColor3 = uipallet.Main
settingschildren.BorderSizePixel = 0
settingschildren.CanvasSize = UDim2.new()
settingschildren.Name = 'Children'
settingschildren.Position = UDim2.fromOffset(0, 41)
settingschildren.ScrollBarThickness = 2
settingschildren.ScrollBarImageTransparency = 0.75
settingschildren.Size = UDim2.new(1, 0, 1, -45)
settingschildren.Parent = settingspane
local windowlist = Instance.new('UIListLayout')
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.Parent = settingschildren
if props.Size then
	local modulechildren = Instance.new('Frame')
	modulechildren.Size = props.Size
	modulechildren.BackgroundTransparency = 1
	modulechildren.Visible = false
	modulechildren.Parent = scaledgui
	addDragHandler(modulechildren, api.Window)
	local objectstroke = Instance.new('UIStroke')
	objectstroke.Color = Color3.fromRGB(5, 134, 105)
	objectstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	objectstroke.Thickness = 0
	objectstroke.Parent = modulechildren
	component.Children = modulechildren
end
props.Function = props.Function or function() end
addMaid(component)

function component:Color(hue, sat, val, isRainbow)
	if self.Enabled then
		tween:Cancel(holder)
		holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end

	for _, component in self.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

function component:Load(data)
	vape:LoadOptions(self, data.Options)

	if self.Enabled ~= data.Enabled then
		self:Toggle()
	end

	if data.Position and self.Children then
		self.Children.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
	end
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Enabled,
		Options = vape:SaveOptions(self),
		Position = self.Children and {
			X = self.Children.Position.X.Offset,
			Y = self.Children.Position.Y.Offset
		} or nil
	}
end

function component:Toggle()
	self.Enabled = not self.Enabled
	if self.Children then
		self.Children.Visible = self.Enabled
	end

	title.TextColor3 = self.Enabled and color.Light(uipallet.Text, 0.2) or color.Dark(uipallet.Text, 0.31)
	button.BackgroundColor3 = self.Enabled and color.Light(uipallet.Main, 0.05) or button.BackgroundColor3

	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.14)
	})

	tween:Tween(knob, uipallet.Tween, {
		Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
	})

	if not self.Enabled then
		for _, v in self.Connections do
			v:Disconnect()
		end
		table.clear(self.Connections)
	end

	task.spawn(props.Function, self.Enabled)
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, settingschildren, component)
	end
end

back.MouseEnter:Connect(function()
	back.ImageColor3 = uipallet.Text
end)

back.MouseLeave:Connect(function()
	back.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

back.MouseButton1Click:Connect(function()
	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 1
	})

	tween:Tween(settingspane, uipallet.Tween, {
		Position = UDim2.fromScale(1, 0)
	})

	task.delay(0.2, function()
		shadow.Visible = false
	end)
end)

button.MouseEnter:Connect(function()
	if not component.Enabled then
		button.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
	end
end)

button.MouseLeave:Connect(function()
	if not component.Enabled then
		button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	end
end)

button.MouseButton1Click:Connect(function()
	component:Toggle()
end)

button.MouseButton2Click:Connect(function()
	shadow.Visible = true

	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 0.5
	})

	tween:Tween(settingspane, uipallet.Tween, {
		Position = UDim2.new(1, -220, 0, 0)
	})
end)

dotsbutton.MouseButton1Click:Connect(function()
	shadow.Visible = true

	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 0.5
	})

	tween:Tween(settingspane, uipallet.Tween, {
		Position = UDim2.new(1, -220, 0, 0)
	})
end)

dotsbutton.MouseEnter:Connect(function()
	dots.ImageColor3 = uipallet.Text
end)

dotsbutton.MouseLeave:Connect(function()
	dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

shadow.MouseButton1Click:Connect(function()
	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 1
	})

	tween:Tween(settingspane, uipallet.Tween, {
		Position = UDim2.fromScale(1, 0)
	})

	task.delay(0.2, function()
		shadow.Visible = false
	end)
end)

shadow:GetPropertyChangedSignal('Visible'):Connect(function()
	tooltip.Visible = false
	vape.LegitVisible = shadow.Visible
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	settingschildren.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
end)

api.Modules[props.Name] = component

local sorting = {}
for _, mod in api.Modules do
	table.insert(sorting, mod.Name)
end
table.sort(sorting)

for index, name in sorting do
	api.Modules[name].Object.LayoutOrder = index
end

return component