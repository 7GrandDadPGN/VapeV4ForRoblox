local optionapi = {
	Type = 'Toggle',
	Enabled = false,
	Index = getTableSize(api.Options)
}

local hovered = false
local toggle = Instance.new('TextButton')
toggle.Name = optionsettings.Name..'Toggle'
toggle.Size = UDim2.new(1, 0, 0, 30)
toggle.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
toggle.BorderSizePixel = 0
toggle.AutoButtonColor = false
toggle.Visible = optionsettings.Visible == nil or optionsettings.Visible
toggle.Text = '          '..optionsettings.Name
toggle.TextXAlignment = Enum.TextXAlignment.Left
toggle.TextColor3 = color.Dark(uipallet.Text, 0.16)
toggle.TextSize = 14
toggle.FontFace = uipallet.Font
toggle.Parent = children
addTooltip(toggle, optionsettings.Tooltip)
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(22, 12)
knobholder.Position = UDim2.new(1, -30, 0, 9)
knobholder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
knobholder.Parent = toggle
addCorner(knobholder, UDim.new(1, 0))
local knob = knobholder:Clone()
knob.Size = UDim2.fromOffset(8, 8)
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
end

function optionapi:Toggle()
	self.Enabled = not self.Enabled
	local rainbowcheck = mainapi.GUIColor.Rainbow and mainapi.RainbowMode.Value ~= 'Retro'
	tween:Tween(knobholder, uipallet.Tween, {
		BackgroundColor3 = self.Enabled and (rainbowcheck and Color3.fromHSV(mainapi:Color((mainapi.GUIColor.Hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)) or (hovered and color.Light(uipallet.Main, 0.37) or color.Light(uipallet.Main, 0.14))
	})
	tween:Tween(knob, uipallet.Tween, {
		Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
	})
	optionsettings.Function(self.Enabled)
end

toggle.MouseEnter:Connect(function()
	hovered = true
	if not optionapi.Enabled then
		tween:Tween(knobholder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)
toggle.MouseLeave:Connect(function()
	hovered = false
	if not optionapi.Enabled then
		tween:Tween(knobholder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		})
	end
end)
toggle.MouseButton1Click:Connect(function()
	optionapi:Toggle()
end)

if optionsettings.Default then
	optionapi:Toggle()
end
optionapi.Object = toggle
api.Options[optionsettings.Name] = optionapi

return optionapi