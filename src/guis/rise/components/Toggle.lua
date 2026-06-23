local optionapi = {
	Type = 'Toggle',
	Enabled = false,
	Index = getTableSize(api.Options)
}

local toggle = Instance.new('TextButton')
toggle.Name = optionsettings.Name..'Toggle'
toggle.Size = UDim2.new(1, 0, 0, 28)
toggle.BackgroundTransparency = 1
toggle.Text = ''
toggle.Visible = optionsettings.Visible == nil or optionsettings.Visible
toggle.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 1, 0)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = toggle
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(10, 10)
knobholder.Position = UDim2.fromOffset(getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 22, 10)
knobholder.BackgroundColor3 = uipallet.Main
knobholder.Parent = toggle
addCorner(knobholder, UDim.new(1, 0))
local knob = knobholder:Clone()
knob.Size = UDim2.new()
knob.Position = UDim2.fromScale(0.5, 0.5)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = uipallet.MainColor
knob.Parent = knobholder
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab[optionsettings.Name] = {Enabled = self.Enabled}
end

function optionapi:Load(tab)
	if self.Enabled ~= tab.Enabled then
		self:Toggle()
	end
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	if self.Enabled then
		knob.BackgroundColor3 = uipallet.MainColor
	end
end

function optionapi:Toggle()
	self.Enabled = not self.Enabled
	knob.Visible = true
	tween:Tween(knob, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
		Size = UDim2.fromOffset(self.Enabled and 10 or 0, self.Enabled and 10 or 0)
	})
	task.delay(0.1, function()
		knob.Visible = knob.Size ~= UDim2.new() or self.Enabled
	end)
	optionsettings.Function(self.Enabled)
end

toggle.MouseButton1Click:Connect(function()
	optionapi:Toggle()
end)

if optionsettings.Default then
	optionapi:Toggle()
end
optionapi.Object = toggle
if not optionsettings.Special then
	api.Options[optionsettings.Name] = optionapi
end

return optionapi