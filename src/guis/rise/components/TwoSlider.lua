local optionapi = {
	Type = 'TwoSlider',
	ValueMin = optionsettings.DefaultMin or optionsettings.Min,
	ValueMax = optionsettings.DefaultMax or 10,
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
valuebutton.Text = optionapi.ValueMin..' '..optionapi.ValueMax
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
valuebox.Text = optionapi.ValueMin..' '..optionapi.ValueMax
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
fill.Position = UDim2.fromScale(math.clamp(optionapi.ValueMin / optionsettings.Max, 0, 1), 0)
fill.Size = UDim2.fromScale(math.clamp(math.clamp(optionapi.ValueMax / optionsettings.Max, 0, 1), 0, 1) - fill.Position.X.Scale, 1)
fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
fill.Parent = bkg
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(10, 10)
knob.Position = UDim2.fromOffset(-5, -3)
knob.BackgroundColor3 = uipallet.MainColor
knob.Parent = fill
addCorner(knob, UDim.new(1, 0))
local knobmax = knob:Clone()
knobmax.Name = 'KnobMax'
knobmax.Position = UDim2.new(1, -5, 0, -3)
knobmax.Parent = fill
optionsettings.Function = optionsettings.Function or function() end
optionsettings.Decimal = optionsettings.Decimal or 1
local random = Random.new()

function optionapi:Save(tab)
	tab[optionsettings.Name] = {
		ValueMin = self.ValueMin,
		ValueMax = self.ValueMax
	}
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
	fill.BackgroundColor3 = color.Dark(uipallet.MainColor, 0.5)
	knob.BackgroundColor3 = uipallet.MainColor
	knobmax.BackgroundColor3 = uipallet.MainColor
end

function optionapi:GetRandomValue()
	return random:NextNumber(optionapi.ValueMin, optionapi.ValueMax)
end

function optionapi:SetValue(max, value)
	if tonumber(value) == math.huge or value ~= value then return end
	self[max and 'ValueMax' or 'ValueMin'] = value
	valuebutton.Text = self.ValueMin..' '..self.ValueMax
	local size = math.clamp(math.clamp(self.ValueMin / optionsettings.Max, 0, 1), 0.04, 0.96)
	tween:Tween(fill, TweenInfo.new(0.1), {
		Position = UDim2.fromScale(size, 0), Size = UDim2.fromScale(math.clamp(math.clamp(math.clamp(self.ValueMax / optionsettings.Max, 0.04, 0.96), 0.04, 0.96) - size, 0, 1), 1)
	})
end

slider.InputBegan:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
		local maxCheck = (inputObj.Position.X - knobmax.AbsolutePosition.X) > -10
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
	valuebox.Text = optionapi.ValueMin..' '..optionapi.ValueMax
	valuebox:CaptureFocus()
end)
valuebox.FocusLost:Connect(function(enter)
	valuebutton.Visible = true
	valuebox.Visible = false
	if enter then
		for i, v in valuebox.Text:split(' ') do
			if tonumber(v) then
				optionapi:SetValue(i == 2, tonumber(v))
			end
		end
	end
end)

optionapi.Object = slider
api.Options[optionsettings.Name] = optionapi

return optionapi