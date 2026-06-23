local optionapi = {
	Type = 'Targets',
	Index = getTableSize(api.Options)
}

local textlist = Instance.new('TextButton')
textlist.Name = 'Targets'
textlist.Size = UDim2.new(1, 0, 0, 50)
textlist.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
textlist.BorderSizePixel = 0
textlist.AutoButtonColor = false
textlist.Visible = optionsettings.Visible == nil or optionsettings.Visible
textlist.Text = ''
textlist.Parent = children
--addTooltip(textlist, optionsettings.Tooltip)
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
local buttontitle = Instance.new('TextLabel')
buttontitle.Name = 'Title'
buttontitle.Size = UDim2.new(1, -5, 0, 15)
buttontitle.Position = UDim2.fromOffset(5, 6)
buttontitle.BackgroundTransparency = 1
buttontitle.Text = 'Target:'
buttontitle.TextXAlignment = Enum.TextXAlignment.Left
buttontitle.TextColor3 = color.Dark(uipallet.Text, 0.16)
buttontitle.TextSize = 15
buttontitle.TextTruncate = Enum.TextTruncate.AtEnd
buttontitle.FontFace = uipallet.Font
buttontitle.Parent = button
local items = buttontitle:Clone()
items.Name = 'Items'
items.Position = UDim2.fromOffset(5, 21)
items.Text = 'Ignore none'
items.TextColor3 = color.Dark(uipallet.Text, 0.16)
items.TextSize = 11
items.Parent = button
addCorner(button, UDim.new(0, 4))
local tool = Instance.new('Frame')
tool.Size = UDim2.fromOffset(65, 12)
tool.Position = UDim2.fromOffset(52, 8)
tool.BackgroundTransparency = 1
tool.Parent = button
local toollist = Instance.new('UIListLayout')
toollist.FillDirection = Enum.FillDirection.Horizontal
toollist.Padding = UDim.new(0, 6)
toollist.Parent = tool
local window = Instance.new('TextButton')
window.Name = 'TargetsTextWindow'
window.Size = UDim2.fromOffset(220, 145)
window.BackgroundColor3 = uipallet.Main
window.BorderSizePixel = 0
window.AutoButtonColor = false
window.Visible = false
window.Text = ''
window.Parent = clickgui
optionapi.Window = window
addBlur(window)
addCorner(window)
local icon = Instance.new('ImageLabel')
icon.Name = 'Icon'
icon.Size = UDim2.fromOffset(18, 12)
icon.Position = UDim2.fromOffset(10, 15)
icon.BackgroundTransparency = 1
icon.Image = getcustomasset('newvape/assets/new/targetstab.png')
icon.Parent = window
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.new(1, -36, 0, 20)
title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 11)
title.BackgroundTransparency = 1
title.Text = 'Target settings'
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.FontFace = uipallet.Font
title.Parent = window
--local close = addCloseButton(window)
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab.Targets = {
		Players = self.Players.Enabled,
		NPCs = self.NPCs.Enabled,
		Invisible = self.Invisible.Enabled,
		Walls = self.Walls.Enabled
	}
end

function optionapi:Load(tab)
	if self.Players.Enabled ~= tab.Players then
		self.Players:Toggle()
	end
	if self.NPCs.Enabled ~= tab.NPCs then
		self.NPCs:Toggle()
	end
	if self.Invisible.Enabled ~= tab.Invisible then
		self.Invisible:Toggle()
	end
	if self.Walls.Enabled ~= tab.Walls then
		self.Walls:Toggle()
	end
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	bkg.BackgroundColor3 = rainbowcheck and Color3.fromHSV(mainapi:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	if self.Players.Enabled then
		tween:Cancel(self.Players.Object.Frame)
		self.Players.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
	if self.NPCs.Enabled then
		tween:Cancel(self.NPCs.Object.Frame)
		self.NPCs.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
	if self.Invisible.Enabled then
		tween:Cancel(self.Invisible.Object.Knob)
		self.Invisible.Object.Knob.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
	if self.Walls.Enabled then
		tween:Cancel(self.Walls.Object.Knob)
		self.Walls.Object.Knob.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
end

optionapi.Players = components.TargetsButton({
	Position = UDim2.fromOffset(11, 45),
	Icon = getcustomasset('newvape/assets/new/targetplayers1.png'),
	IconSize = UDim2.fromOffset(15, 16),
	IconParent = tool,
	ToolIcon = getcustomasset('newvape/assets/new/targetplayers2.png'),
	ToolSize = UDim2.fromOffset(11, 12),
	Tooltip = 'Players',
	Function = optionsettings.Function
}, window, tool)
optionapi.NPCs = components.TargetsButton({
	Position = UDim2.fromOffset(112, 45),
	Icon = getcustomasset('newvape/assets/new/targetnpc1.png'),
	IconSize = UDim2.fromOffset(12, 16),
	IconParent = tool,
	ToolIcon = getcustomasset('newvape/assets/new/targetnpc2.png'),
	ToolSize = UDim2.fromOffset(9, 12),
	Tooltip = 'NPCs',
	Function = optionsettings.Function
}, window, tool)
optionapi.Invisible = components.Toggle({
	Name = 'Ignore invisible',
	Function = function()
		local text = 'none'
		if optionapi.Invisible.Enabled then
			text = 'invisible'
		end
		if optionapi.Walls.Enabled then
			text = text == 'none' and 'behind walls' or text..', behind walls'
		end
		items.Text = 'Ignore '..text
		optionsettings.Function()
	end
}, window, {Options = {}})
optionapi.Invisible.Object.Position = UDim2.fromOffset(0, 81)
optionapi.Walls = components.Toggle({
	Name = 'Ignore behind walls',
	Function = function()
		local text = 'none'
		if optionapi.Invisible.Enabled then
			text = 'invisible'
		end
		if optionapi.Walls.Enabled then
			text = text == 'none' and 'behind walls' or text..', behind walls'
		end
		items.Text = 'Ignore '..text
		optionsettings.Function()
	end
}, window, {Options = {}})
optionapi.Walls.Object.Position = UDim2.fromOffset(0, 111)
if optionsettings.Players then
	optionapi.Players:Toggle()
end
if optionsettings.NPCs then
	optionapi.NPCs:Toggle()
end
if optionsettings.Invisible then
	optionapi.Invisible:Toggle()
end
if optionsettings.Walls then
	optionapi.Walls:Toggle()
end

--close.MouseButton1Click:Connect(function()
--	window.Visible = false
--end)
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
	local actualPosition = (textlist.AbsolutePosition + Vector2.new(0, 60)) / scale.Scale
	window.Position = UDim2.fromOffset(actualPosition.X + 220, actualPosition.Y)
end)

optionapi.Object = textlist
api.Options.Targets = optionapi

return optionapi