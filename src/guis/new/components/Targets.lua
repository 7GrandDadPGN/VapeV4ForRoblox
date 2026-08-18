local component = {
	Index = getTableSize(api.Options),
	Type = 'Targets'
}

local targets = Instance.new('TextButton')
targets.AutoButtonColor = false
targets.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
targets.BorderSizePixel = 0
targets.Size = UDim2.new(1, 0, 0, 50)
targets.Text = ''
targets.Visible = props.Visible == nil or props.Visible
targets.Parent = children
component.Object = targets
addTooltip(targets, props.Tooltip)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
holder.Position = UDim2.fromOffset(10, 4)
holder.Size = UDim2.new(1, -20, 1, -9)
holder.Parent = targets
addCorner(holder, UDim.new(0, 4))
local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = uipallet.Main
button.Position = UDim2.fromOffset(1, 1)
button.Size = UDim2.new(1, -2, 1, -2)
button.Text = ''
button.Parent = holder
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(5, 6)
title.Size = UDim2.new(1, -5, 0, 15)
title.Text = 'Target:'
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 15
title.TextTruncate = Enum.TextTruncate.AtEnd
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = button
local items = Instance.new('TextLabel')
items.BackgroundTransparency = 1
items.FontFace = uipallet.Font
items.Position = UDim2.fromOffset(5, 21)
items.Size = UDim2.new(1, -5, 0, 15)
items.Text = 'Ignore none'
items.TextColor3 = color.Dark(uipallet.Text, 0.16)
items.TextSize = 11
items.TextTruncate = Enum.TextTruncate.AtEnd
items.TextXAlignment = Enum.TextXAlignment.Left
items.Parent = button
addCorner(button, UDim.new(0, 4))
local iconholder = Instance.new('Frame')
iconholder.BackgroundTransparency = 1
iconholder.Position = UDim2.fromOffset(52, 8)
iconholder.Size = UDim2.fromOffset(65, 12)
iconholder.Parent = button
local layout = Instance.new('UIListLayout')
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0, 6)
layout.Parent = iconholder
local targetswindow = Instance.new('TextButton')
targetswindow.AutoButtonColor = false
targetswindow.BackgroundColor3 = uipallet.Main
targetswindow.BorderSizePixel = 0
targetswindow.Position = UDim2.fromOffset(456, 139)
targetswindow.Size = UDim2.fromOffset(220, 145)
targetswindow.Text = ''
targetswindow.Visible = false
targetswindow.Parent = clickgui
component.Window = targetswindow
addBlur(targetswindow)
addCorner(targetswindow)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/aim.png')
icon.Position = UDim2.fromOffset(10, 15)
icon.Size = UDim2.fromOffset(18, 12)
icon.Parent = targetswindow
local windowtitle = Instance.new('TextLabel')
windowtitle.BackgroundTransparency = 1
windowtitle.FontFace = uipallet.Font
windowtitle.Size = UDim2.new(1, -36, 0, 20)
windowtitle.Position = UDim2.fromOffset(math.abs(windowtitle.Size.X.Offset), 11)
windowtitle.Text = 'Target settings'
windowtitle.TextColor3 = uipallet.Text
windowtitle.TextSize = 13
windowtitle.TextXAlignment = Enum.TextXAlignment.Left
windowtitle.Parent = targetswindow
local close = addCloseButton(targetswindow)
props.Function = props.Function or function() end

function component:Color(hue, sat, val, isRainbow)
	if targetswindow.Visible then
		holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	end

	if self.Players.Enabled then
		tween:Cancel(self.Players.Object.Frame)
		self.Players.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end

	if self.NPCs.Enabled then
		tween:Cancel(self.NPCs.Object.Frame)
		self.NPCs.Object.Frame.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end

	if self.Invisible.Enabled then
		tween:Cancel(self.Invisible.Object.Holder)
		self.Invisible.Object.Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end

	if self.Walls.Enabled then
		tween:Cancel(self.Walls.Object.Holder)
		self.Walls.Object.Holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
	end
end

function component:Load(data)
	if self.Players.Enabled ~= data.Players then
		self.Players:Toggle()
	end

	if self.NPCs.Enabled ~= data.NPCs then
		self.NPCs:Toggle()
	end

	if self.Invisible.Enabled ~= data.Invisible then
		self.Invisible:Toggle()
	end

	if self.Walls.Enabled ~= data.Walls then
		self.Walls:Toggle()
	end
end

function component:Save(data)
	data.Targets = {
		Players = self.Players.Enabled,
		NPCs = self.NPCs.Enabled,
		Invisible = self.Invisible.Enabled,
		Walls = self.Walls.Enabled
	}
end

function component:UpdateText()
	local newText = {}

	if self.Players.Enabled then
		table.insert(newText, 'Players')
	end

	if self.NPCs.Enabled then
		table.insert(newText, 'NPCs')
	end

	title.Text = 'Target: '..(#newText > 0 and table.concat(newText, ', ') or 'Nothing')
	title.TextColor3 = #newText > 0 and uipallet.Text or Color3.fromRGB(255, 90, 90)
end

component.Players = components.TargetsButton({
	Position = UDim2.fromOffset(11, 45),
	Icon = getvapeasset('newvape/assets/new/players.png'),
	IconSize = UDim2.fromOffset(16, 16),
	IconParent = iconholder,
	Targets = component,
	Tooltip = 'Target players',
	Function = props.Function
}, targetswindow, iconholder)

component.NPCs = components.TargetsButton({
	Position = UDim2.fromOffset(112, 45),
	Icon = getvapeasset('newvape/assets/new/npcs.png'),
	IconSize = UDim2.fromOffset(12, 16),
	IconParent = iconholder,
	Targets = component,
	Tooltip = 'Target NPCs',
	Function = props.Function
}, targetswindow, iconholder)

component.Invisible = components.Toggle({
	Name = 'Ignore invisible',
	Function = function()
		local newText = {}

		if component.Invisible.Enabled then
			table.insert(newText, 'invisible')
		end

		if component.Walls.Enabled then
			table.insert(newText, 'behind walls')
		end

		items.Text = 'Ignore '..(#newText > 0 and table.concat(newText, ', ') or 'none')
		props.Function()
	end
}, targetswindow, {Options = {}})
component.Invisible.Object.Position = UDim2.fromOffset(0, 81)

component.Walls = components.Toggle({
	Name = 'Ignore behind walls',
	Function = function()
		local newText = {}

		if component.Invisible.Enabled then
			table.insert(newText, 'invisible')
		end

		if component.Walls.Enabled then
			table.insert(newText, 'behind walls')
		end

		items.Text = 'Ignore '..(#newText > 0 and table.concat(newText, ', ') or 'none')
		props.Function()
	end
}, targetswindow, {Options = {}})
component.Walls.Object.Position = UDim2.fromOffset(0, 111)

if props.Players then
	component.Players:Toggle()
end

if props.NPCs then
	component.NPCs:Toggle()
end

if props.Invisible then
	component.Invisible:Toggle()
end

if props.Walls then
	component.Walls:Toggle()
end

close.MouseButton1Click:Connect(function()
	targetswindow.Visible = false
end)

button.MouseButton1Click:Connect(function()
	targetswindow.Visible = not targetswindow.Visible
	tween:Cancel(holder)

	holder.BackgroundColor3 = targetswindow.Visible and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or color.Light(uipallet.Main, 0.37)
end)

targets.MouseEnter:Connect(function()
	if not targetswindow.Visible then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)

targets.MouseLeave:Connect(function()
	if not targetswindow.Visible then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		})
	end
end)

targets:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	local actualPosition = (targets.AbsolutePosition + Vector2.new(0, 60)) / scale.Scale
	targetswindow.Position = UDim2.fromOffset(actualPosition.X + 223, actualPosition.Y)
end)

api.Options.Targets = component

return component