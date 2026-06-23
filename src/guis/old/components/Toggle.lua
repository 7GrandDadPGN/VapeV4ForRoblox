local optionapi = {
	Type = 'Toggle',
	Enabled = false,
	Index = getTableSize(api.Options)
}

local toggle = Instance.new('TextButton')
toggle.Name = optionsettings.Name..'Toggle'
toggle.Size = UDim2.new(1, api.Category and -8 or 0, 0, 24)
toggle.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
toggle.BackgroundTransparency = api.Category and 0 or 1
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = false
toggle.Visible = optionsettings.Visible == nil or optionsettings.Visible
toggle.Text = string.rep(' ', 32)..optionsettings.Name
toggle.TextXAlignment = Enum.TextXAlignment.Left
toggle.TextColor3 = uipallet.Text
toggle.TextSize = 13
toggle.FontFace = uipallet.Font
toggle.Parent = children
addTooltip(toggle, optionsettings.Tooltip)
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(22, 15)
knobholder.Position = UDim2.fromOffset(7, 4)
knobholder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
knobholder.Parent = toggle
addCorner(knobholder, UDim.new(1, 0))
local knob = knobholder:Clone()
knob.Size = UDim2.fromOffset(12, 11)
knob.Position = UDim2.fromOffset(2, 2)
knob.BackgroundColor3 = uipallet.Main
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
		tween:Cancel(knobholder)
		knobholder.BackgroundColor3 = rainbowcheck and Color3.fromHSV(mainapi:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	end
	knob.BackgroundColor3 = mainapi.GUIColor.Rainbow and uipallet.Main or mainapi:TextColor(hue, sat, val, uipallet.Main)
end

function optionapi:Toggle()
	self.Enabled = not self.Enabled
	local rainbowcheck = mainapi.GUIColor.Rainbow and mainapi.RainbowMode.Value ~= 'Retro'
	knobholder.BackgroundColor3 = self.Enabled and (rainbowcheck and Color3.fromHSV(mainapi:Color((mainapi.GUIColor.Hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)) or color.Light(uipallet.Main, 0.14)
	tween:Tween(knob, uipallet.Tween, {
		Position = UDim2.fromOffset(self.Enabled and 8 or 2, 2)
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