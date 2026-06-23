local optionapi = {
	Type = 'ColorSlider',
	Hue = optionsettings.DefaultHue or 0.44,
	Sat = optionsettings.DefaultSat or 1,
	Value = optionsettings.DefaultValue or 1,
	Opacity = optionsettings.DefaultOpacity or 1,
	Rainbow = false,
	Index = 0
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
valuebutton.Text = '0, 255, 60'
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
valuebox.Text = valuebutton.Text
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
bkg.BackgroundColor3 = Color3.new(1, 1, 1)
bkg.Parent = slider
addCorner(bkg, UDim.new(1, 0))
local fill = bkg:Clone()
fill.Name = 'Fill'
fill.Size = UDim2.fromScale(0.44, 1)
fill.Position = UDim2.new()
fill.BackgroundTransparency = 1
fill.Parent = bkg
local rainbowTable = {}
for i = 0, 1, 0.1 do
	table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
end
local gradient = Instance.new('UIGradient')
gradient.Color = ColorSequence.new(rainbowTable)
gradient.Parent = bkg
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(10, 10)
knob.Position = UDim2.new(1, -5, 0, -3)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.Parent = fill
addCorner(knob, UDim.new(1, 0))
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab[optionsettings.Name] = {
		Hue = self.Hue,
		Sat = self.Sat,
		Value = self.Value,
		Opacity = self.Opacity,
		Rainbow = self.Rainbow
	}
end

function optionapi:Load(tab)
	if tab.Rainbow ~= self.Rainbow then
		self:Toggle()
	end
	if self.Hue ~= tab.Hue or self.Sat ~= tab.Sat or self.Value ~= tab.Value or self.Opacity ~= tab.Opacity then
		self:SetValue(tab.Hue, tab.Sat, tab.Value, tab.Opacity)
	end
end

function optionapi:SetValue(h, s, v, o)
	self.Hue = h or self.Hue
	self.Sat = s or self.Sat
	self.Value = v or self.Value
	self.Opacity = o or self.Opacity
	if self.Rainbow then
		fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0, 0.99), 1)
		valuebutton.Text = 'Rainbow'
	else
		tween:Tween(fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Hue, 0, 0.99), 1)
		})
		local text = Color3.fromHSV(self.Hue, self.Sat, self.Value)
		valuebutton.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
	end
	optionsettings.Function(self.Hue, self.Sat, self.Value, self.Opacity)
end

function optionapi:Toggle()
	self.Rainbow = not self.Rainbow
	if self.Rainbow then
		table.insert(mainapi.RainbowTable, self)
	else
		local ind = table.find(mainapi.RainbowTable, self)
		if ind then
			table.remove(mainapi.RainbowTable, ind)
		end
	end
end

local doubleClick = tick()
slider.InputBegan:Connect(function(inputObj)
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
		if doubleClick > tick() then
			optionapi:Toggle()
		end
		doubleClick = tick() + 0.3
		local changed = inputService.InputChanged:Connect(function(input)
			if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				optionapi:SetValue(math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1))
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
	valuebox:CaptureFocus()
	local text = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
	valuebox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
end)
valuebox.FocusLost:Connect(function(enter)
	valuebutton.Visible = true
	valuebox.Visible = false
	if enter then
		local commas = valuebox.Text:split(',')
		local suc, res = pcall(function()
			return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(valuebox.Text)
		end)
		if suc then
			if optionapi.Rainbow then
				optionapi:Toggle()
			end
			optionapi:SetValue(res:ToHSV())
		end
	end
end)

optionapi.Object = slider
api.Options[optionsettings.Name] = optionapi

return optionapi