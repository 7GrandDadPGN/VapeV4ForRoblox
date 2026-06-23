local optionapi = {
	Type = 'Toggle',
	Enabled = false,
	Index = getTableSize(api.Options)
}

local toggle = Instance.new('TextButton')
toggle.Name = optionsettings.Name..'Toggle'
toggle.Size = UDim2.new(1, 0, 0, 28)
toggle.BackgroundTransparency = 1
toggle.Visible = optionsettings.Visible == nil or optionsettings.Visible
toggle.Text = ''
toggle.Parent = children
--addTooltip(toggle, optionsettings.Tooltip)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = toggle
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -40, 1, -2)
title.Position = UDim2.fromOffset(40, 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 14
title.FontFace = uipallet.FontSemiBold
title.Parent = toggle
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(22, 8)
knobholder.Position = UDim2.fromOffset(11, 10)
knobholder.BackgroundColor3 = color.Dark(uipallet.Text, 0.2)
knobholder.Parent = toggle
addCorner(knobholder, UDim.new(1, 0))
local knob = knobholder:Clone()
knob.Size = UDim2.fromOffset(12, 12)
knob.Position = UDim2.fromOffset(0, -2)
knob.BackgroundColor3 = uipallet.Text
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

function optionapi:Toggle()
	self.Enabled = not self.Enabled
	tween:Tween(knob, createTween(0.4), {
		BackgroundColor3 = self.Enabled and uipallet.Main or uipallet.Text,
		Position = UDim2.fromOffset(self.Enabled and 10 or 0, -2)
	})
	tween:Tween(knobholder, createTween(0.4), {
		BackgroundColor3 = self.Enabled and color.Saturate(uipallet.Main, 0.6) or color.Dark(uipallet.Text, 0.55)
	})

	optionsettings.Function(self.Enabled)
end

toggle.MouseButton1Click:Connect(function()
	optionapi:Toggle()
end)

if optionsettings.Default then
	optionapi:Toggle()
end
optionapi.Object = toggle
api.Options[optionsettings.Name] = optionapi

return optionapi