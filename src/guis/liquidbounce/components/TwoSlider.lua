local optionapi = {
	Type = 'TwoSlider',
	ValueMin = optionsettings.DefaultMin or optionsettings.Min,
	ValueMax = optionsettings.DefaultMax or 10,
	Max = optionsettings.Max,
	Index = getTableSize(api.Options)
}

local slider = Instance.new('TextButton')
slider.Name = optionsettings.Name..'Slider'
slider.Size = UDim2.new(1, 0, 0, 46)
slider.BackgroundTransparency = 1
slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
slider.Text = ''
slider.Parent = children
--addTooltip(slider, optionsettings.Tooltip)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = slider
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.fromOffset(60, 15)
title.Position = UDim2.fromOffset(10, 7)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = uipallet.Text
title.TextSize = 14
title.FontFace = uipallet.FontSemiBold
title.Parent = slider
local valuebutton = Instance.new('TextButton')
valuebutton.Name = 'Value'
valuebutton.Size = UDim2.fromOffset(60, 15)
valuebutton.Position = UDim2.new(1, -69, 0, 7)
valuebutton.BackgroundTransparency = 1
valuebutton.Text = optionapi.ValueMax
valuebutton.TextXAlignment = Enum.TextXAlignment.Right
valuebutton.TextColor3 = uipallet.Text
valuebutton.TextSize = 14
valuebutton.FontFace = uipallet.FontSemiBold
valuebutton.Parent = slider
local valuebutton2 = valuebutton:Clone()
valuebutton2.Position = UDim2.new(1, -125, 0, 7)
valuebutton2.Text = optionapi.ValueMin
valuebutton2.Parent = slider
local valuebox = Instance.new('TextBox')
valuebox.Name = 'Box'
valuebox.Size = valuebutton.Size
valuebox.Position = valuebutton.Position
valuebox.BackgroundTransparency = 1
valuebox.Visible = false
valuebox.Text = optionapi.ValueMin
valuebox.TextXAlignment = Enum.TextXAlignment.Right
valuebox.TextColor3 = uipallet.Text
valuebox.TextSize = 14
valuebox.FontFace = uipallet.FontSemiBold
valuebox.ClearTextOnFocus = false
valuebox.Parent = slider
local valuebox2 = valuebox:Clone()
valuebox2.Position = valuebutton2.Position
valuebox2.Parent = slider
local bkg = Instance.new('Frame')
bkg.Name = 'Slider'
bkg.Size = UDim2.new(1, -22, 0, 2)
bkg.Position = UDim2.fromOffset(11, 32)
bkg.BackgroundColor3 = color.Dark(uipallet.Text, 0.8)
bkg.BorderSizePixel = 0
bkg.Parent = slider
local fill = bkg:Clone()
fill.Name = 'Fill'
fill.Position = UDim2.fromScale(math.clamp(optionapi.ValueMin / optionsettings.Max, 0.04, 0.96), 0)
fill.Size = UDim2.fromScale(math.clamp(math.clamp(optionapi.ValueMax / optionsettings.Max, 0, 1), 0.04, 0.96) - fill.Position.X.Scale, 1)
fill.BackgroundColor3 = uipallet.Main
fill.Parent = bkg
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(24, 4)
knobholder.Position = UDim2.fromScale(0, 0.5)
knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
knobholder.BackgroundTransparency = 1
knobholder.Parent = fill
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(14, 14)
knob.Position = UDim2.fromScale(0.5, 0.5)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = uipallet.Main
knob.Parent = knobholder
addCorner(knob, UDim.new(1, 0))
local knobholdermax = knobholder:Clone()
knobholdermax.Name = 'KnobMax'
knobholdermax.Position = UDim2.fromScale(1, 0.5)
knobholdermax.Parent = fill
knobholdermax.Knob.Rotation = 180
optionsettings.Function = optionsettings.Function or function() end
optionsettings.Decimal = optionsettings.Decimal or 1
local random = Random.new()

function optionapi:Save(tab)
	tab[optionsettings.Name] = {ValueMin = self.ValueMin, ValueMax = self.ValueMax}
end

function optionapi:Load(tab)
	if self.ValueMin ~= tab.ValueMin then
		self:SetValue(false, tab.ValueMin)
	end
	if self.ValueMax ~= tab.ValueMax then
		self:SetValue(true, tab.ValueMax)
	end
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	fill.BackgroundColor3 = rainbowcheck and Color3.fromHSV(mainapi:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	knob.ImageColor3 = fill.BackgroundColor3
	knobholdermax.Knob.ImageColor3 = fill.BackgroundColor3
end

function optionapi:GetRandomValue()
	return random:NextNumber(optionapi.ValueMin, optionapi.ValueMax)
end

function optionapi:SetValue(max, value)
	if tonumber(value) == math.huge or value ~= value then return end
	self[max and 'ValueMax' or 'ValueMin'] = value
	valuebutton.Text = self.ValueMax
	valuebutton2.Text = self.ValueMin
	local size = math.clamp(math.clamp(self.ValueMin / optionsettings.Max, 0, 1), 0.03, 0.97)
	tween:Tween(fill, TweenInfo.new(0.1), {
		Position = UDim2.fromScale(size, 0),
		Size = UDim2.fromScale(math.clamp(math.clamp(math.clamp(self.ValueMax / optionsettings.Max, 0.04, 0.96), 0.03, 0.97) - size, 0, 1), 1)
	})
end

slider.InputBegan:Connect(function(inputObj)
	if
		(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
		and (inputObj.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
		local maxCheck = (inputObj.Position.X - knobholdermax.AbsolutePosition.X) > -10
		local newPosition = math.clamp((inputObj.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
		optionapi:SetValue(maxCheck, math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)

		local changed = inputService.InputChanged:Connect(function(input)
			if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				local newPosition = math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1)
				optionapi:SetValue(maxCheck, math.floor((optionsettings.Min + (optionsettings.Max - optionsettings.Min) * newPosition) * optionsettings.Decimal) / optionsettings.Decimal, newPosition)
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
			end
		end)
	end
end)
valuebutton.MouseButton1Click:Connect(function()
	valuebutton.Visible = false
	valuebox.Visible = true
	valuebox.Text = optionapi.ValueMax
	valuebox:CaptureFocus()
end)
valuebutton2.MouseButton1Click:Connect(function()
	valuebutton2.Visible = false
	valuebox2.Visible = true
	valuebox2.Text = optionapi.ValueMin
	valuebox2:CaptureFocus()
end)
valuebox.FocusLost:Connect(function(enter)
	valuebutton.Visible = true
	valuebox.Visible = false
	if enter and tonumber(valuebox.Text) then
		optionapi:SetValue(true, tonumber(valuebox.Text))
	end
end)
valuebox2.FocusLost:Connect(function(enter)
	valuebutton2.Visible = true
	valuebox2.Visible = false
	if enter and tonumber(valuebox2.Text) then
		optionapi:SetValue(false, tonumber(valuebox2.Text))
	end
end)

optionapi.Object = slider
api.Options[optionsettings.Name] = optionapi

return optionapi