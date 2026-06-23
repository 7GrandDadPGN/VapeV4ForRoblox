local optionapi = {
	Type = 'Slider',
	Value = optionsettings.Default or optionsettings.Min,
	Max = optionsettings.Max,
	Index = getTableSize(api.Options)
}

local startpos = getfontsize(optionsettings.Name, 18, uipallet.Font).X + (optionsettings.Darker and 20 or 0) + 26
local slider = Instance.new('TextButton')
slider.Name = optionsettings.Name..'Slider'
slider.Size = UDim2.new(1, 0, 0, 28)
slider.BackgroundTransparency = 1
slider.Text = ''
slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
slider.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 1, 0)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = slider
local valuebutton = Instance.new('TextButton')
valuebutton.Name = 'Value'
valuebutton.Size = UDim2.new(1, -13, 1, 0)
valuebutton.Position = UDim2.fromOffset(startpos + 210, 0)
valuebutton.BackgroundTransparency = 1
valuebutton.Text = optionapi.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(optionapi.Value) or optionsettings.Suffix) or '')
valuebutton.TextColor3 = color.Dark(uipallet.Text, 0.21)
valuebutton.TextSize = 18
valuebutton.TextXAlignment = Enum.TextXAlignment.Left
valuebutton.FontFace = uipallet.Font
valuebutton.Parent = slider
local valuebox = Instance.new('TextBox')
valuebox.Name = 'Box'
valuebox.Size = valuebutton.Size
valuebox.Position = valuebutton.Position
valuebox.BackgroundTransparency = 1
valuebox.Text = optionapi.Value
valuebox.TextColor3 = color.Dark(uipallet.Text, 0.21)
valuebox.TextSize = 18
valuebox.TextXAlignment = Enum.TextXAlignment.Left
valuebox.FontFace = uipallet.Font
valuebox.ClearTextOnFocus = false
valuebox.Visible = false
valuebox.Parent = slider
local bkg = Instance.new('Frame')
bkg.Name = 'Slider'
bkg.Size = UDim2.fromOffset(200, 4)
bkg.Position = UDim2.fromOffset(startpos, 13)
bkg.BackgroundColor3 = uipallet.Main
bkg.Parent = slider
addCorner(bkg, UDim.new(1, 0))
local fill = bkg:Clone()
fill.Name = 'Fill'
fill.Size = UDim2.fromScale(math.clamp((optionapi.Value - optionsettings.Min) / optionsettings.Max, 0, 1), 1)
fill.Position = UDim2.new()
fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
fill.Parent = bkg
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(10, 10)
knob.Position = UDim2.new(1, -5, 0, -3)
knob.BackgroundColor3 = uipallet.MainColor
knob.Parent = fill
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
	fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
	knob.BackgroundColor3 = uipallet.MainColor
end

function optionapi:SetValue(value, pos, final)
	if tonumber(value) == math.huge or value ~= value then return end
	local check = self.Value ~= value
	self.Value = value
	tween:Tween(fill, uipallet.Tween, {
		Size = UDim2.fromScale(math.clamp(pos or math.clamp(value / optionsettings.Max, 0, 1), 0, 1), 1)
	})
	valuebutton.Text = self.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(self.Value) or optionsettings.Suffix) or '')
	if check or final then
		optionsettings.Function(value, final)
	end
end

slider.InputBegan:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
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