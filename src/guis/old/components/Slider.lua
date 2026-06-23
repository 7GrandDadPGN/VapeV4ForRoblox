local optionapi = {
	Type = 'Slider',
	Value = optionsettings.Default or optionsettings.Min,
	Max = optionsettings.Max,
	Index = getTableSize(api.Options)
}

local slider = Instance.new('TextButton')
slider.Name = optionsettings.Name..'Slider'
slider.Size = UDim2.new(1, api.Category and -8 or 0, 0, 31)
slider.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
slider.BackgroundTransparency = api.Category and 0 or 1
slider.BorderSizePixel = 0
slider.AutoButtonColor = false
slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
slider.Text = ''
slider.Parent = children
addTooltip(slider, optionsettings.Tooltip)
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.fromOffset(60, 15)
title.Position = UDim2.fromOffset(10, 4)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 12
title.FontFace = uipallet.Font
title.Parent = slider
local valuebutton = Instance.new('TextButton')
valuebutton.Name = 'Value'
valuebutton.Size = UDim2.fromOffset(60, 15)
valuebutton.Position = UDim2.new(1, -72, 0, 4)
valuebutton.BackgroundTransparency = 1
valuebutton.Text = optionapi.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(optionapi.Value) or optionsettings.Suffix) or '')
valuebutton.TextXAlignment = Enum.TextXAlignment.Right
valuebutton.TextColor3 = uipallet.Text
valuebutton.TextSize = 13
valuebutton.FontFace = uipallet.Font
valuebutton.Parent = slider
local valuebox = Instance.new('TextBox')
valuebox.Name = 'Box'
valuebox.Size = UDim2.fromOffset(60, 15)
valuebox.Position = valuebutton.Position
valuebox.BackgroundTransparency = 1
valuebox.Visible = false
valuebox.Text = optionapi.Value
valuebox.TextXAlignment = Enum.TextXAlignment.Right
valuebox.TextColor3 = uipallet.Text
valuebox.TextSize = 13
valuebox.FontFace = uipallet.Font
valuebox.ClearTextOnFocus = false
valuebox.Parent = slider
local bkg = Instance.new('Frame')
bkg.Name = 'Slider'
bkg.Size = UDim2.new(1, -10, 0, 6)
bkg.Position = UDim2.fromOffset(5, 21)
bkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.2)
bkg.BorderSizePixel = 0
bkg.Parent = slider
addCorner(bkg, UDim.new(1, 0))
local fill = bkg:Clone()
fill.Name = 'Fill'
fill.Size = UDim2.fromScale(math.clamp((optionapi.Value - optionsettings.Min) / optionsettings.Max, 0.02, 0.98), 1)
fill.Position = UDim2.new()
fill.BackgroundColor3 = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value)
fill.Parent = bkg
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(24, 4)
knobholder.Position = UDim2.fromScale(1, 0.5)
knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
knobholder.BackgroundTransparency = 1
knobholder.Parent = fill
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(12, 12)
knob.Position = UDim2.fromScale(0.5, 0.5)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
knob.Parent = knobholder
addCorner(knob, UDim.new(1, 0))
optionsettings.Function = optionsettings.Function or function() end
optionsettings.Decimal = optionsettings.Decimal or 1

function optionapi:Save(tab)
	tab[optionsettings.Name] = {
		Value = self.Value,
		Max = self.Max
	}
end

function optionapi:Load(tab)
	local newval = tab.Value == tab.Max and tab.Max ~= self.Max and self.Max or tab.Value
	if self.Value ~= newval then
		self:SetValue(newval, nil, true)
	end
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	fill.BackgroundColor3 = rainbowcheck and Color3.fromHSV(mainapi:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	knob.BackgroundColor3 = mainapi.GUIColor.Rainbow and color.Light(uipallet.Main, 0.14) or mainapi:TextColor(hue, sat, val)
end

function optionapi:SetValue(value, pos, final)
	if tonumber(value) == math.huge or value ~= value then return end
	local check = self.Value ~= value
	self.Value = value
	tween:Tween(fill, uipallet.Tween, {
		Size = UDim2.fromScale(math.clamp(pos or math.clamp(value / optionsettings.Max, 0, 1), 0.02, 0.98), 1)
	})
	valuebutton.Text = self.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(self.Value) or optionsettings.Suffix) or '')
	if check or final then
		optionsettings.Function(value, final)
	end
end

slider.InputBegan:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and (inputObj.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale) then
		local newPosition = math.clamp((inputObj.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
		optionapi:SetValue(math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
		local lastValue = optionapi.Value
		local lastPosition = newPosition

		local changed = inputService.InputChanged:Connect(function(input)
			if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				local newPosition = math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
				optionapi:SetValue(math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
				lastValue = optionapi.Value
				lastPosition = newPosition
			end
		end)

		local ended
		ended = inputObj.Changed:Connect(function()
			if inputObj.UserInputState == Enum.UserInputState.End then
				if changed then
					changed:Disconnect()
				end
				if ended then
					ended:Disconnect()
				end
				optionapi:SetValue(lastValue, lastPosition, true)
			end
		end)

	end
end)
valuebutton.MouseButton1Click:Connect(function()
	valuebutton.Visible = false
	valuebox.Visible = true
	valuebox.Text = optionapi.Value
	valuebox:CaptureFocus()
end)
valuebox.FocusLost:Connect(function(enter)
	valuebutton.Visible = true
	valuebox.Visible = false
	if enter and tonumber(valuebox.Text) then
		optionapi:SetValue(tonumber(valuebox.Text), nil, true)
	end
end)

optionapi.Object = slider
api.Options[optionsettings.Name] = optionapi

return optionapi