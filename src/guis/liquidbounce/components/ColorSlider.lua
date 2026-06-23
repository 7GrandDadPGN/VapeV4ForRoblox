local optionapi = {
	Type = 'ColorSlider',
	Hue = optionsettings.DefaultHue or 0.44,
	Sat = optionsettings.DefaultSat or 1,
	Value = optionsettings.DefaultValue or 1,
	Opacity = optionsettings.DefaultOpacity or 1,
	Rainbow = false,
	Index = 0
}

local function createSlider(name, gradientColor)
	local slider = Instance.new('TextButton')
	slider.Name = optionsettings.Name..'Slider'..name
	slider.Size = UDim2.new(1, 0, 0, 50)
	slider.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
	slider.BorderSizePixel = 0
	slider.AutoButtonColor = false
	slider.Visible = false
	slider.Text = ''
	slider.Parent = children
	local title = Instance.new('TextLabel')
	title.Name = 'Title'
	title.Size = UDim2.fromOffset(60, 30)
	title.Position = UDim2.fromOffset(10, 2)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 11
	title.FontFace = uipallet.Font
	title.Parent = slider
	local bkg = Instance.new('Frame')
	bkg.Name = 'Slider'
	bkg.Size = UDim2.new(1, -20, 0, 2)
	bkg.Position = UDim2.fromOffset(10, 37)
	bkg.BackgroundColor3 = Color3.new(1, 1, 1)
	bkg.BorderSizePixel = 0
	bkg.Parent = slider
	local gradient = Instance.new('UIGradient')
	gradient.Color = gradientColor
	gradient.Parent = bkg
	local fill = bkg:Clone()
	fill.Name = 'Fill'
	fill.Size = UDim2.fromScale(math.clamp(name == 'Saturation' and optionapi.Sat or name == 'Vibrance' and optionapi.Value or optionapi.Opacity, 0.04, 0.96), 1)
	fill.Position = UDim2.new()
	fill.BackgroundTransparency = 1
	fill.Parent = bkg
	local knobholder = Instance.new('Frame')
	knobholder.Name = 'Knob'
	knobholder.Size = UDim2.fromOffset(24, 4)
	knobholder.Position = UDim2.fromScale(1, 0.5)
	knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
	knobholder.BackgroundColor3 = slider.BackgroundColor3
	knobholder.BorderSizePixel = 0
	knobholder.Parent = fill
	local knob = Instance.new('Frame')
	knob.Name = 'Knob'
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.fromScale(0.5, 0.5)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = uipallet.Text
	knob.Parent = knobholder
	addCorner(knob, UDim.new(1, 0))

	slider.InputBegan:Connect(function(inputObj)
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
		then
			local changed = inputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					optionapi:SetValue(nil, name == 'Saturation' and math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1) or nil, name == 'Vibrance' and math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1) or nil, name == 'Opacity' and math.clamp((input.Position.X - bkg.AbsolutePosition.X) / bkg.AbsoluteSize.X, 0, 1) or nil)
				end
			end)

			local ended
			ended = inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					if changed then changed:Disconnect() end
					if ended then ended:Disconnect() end
				end
			end)
		end
	end)
	slider.MouseEnter:Connect(function()
		tween:Tween(knob, uipallet.Tween, {
			Size = UDim2.fromOffset(16, 16)
		})
	end)
	slider.MouseLeave:Connect(function()
		tween:Tween(knob, uipallet.Tween, {
			Size = UDim2.fromOffset(14, 14)
		})
	end)

	return slider
end

local slider = Instance.new('TextButton')
slider.Name = optionsettings.Name..'Slider'
slider.Size = UDim2.new(1, 0, 0, 50)
slider.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
slider.BorderSizePixel = 0
slider.AutoButtonColor = false
slider.Visible = optionsettings.Visible == nil or optionsettings.Visible
slider.Text = ''
slider.Parent = children
--addTooltip(slider, optionsettings.Tooltip)
local title = Instance.new('TextLabel')
title.Name = 'Title'
title.Size = UDim2.fromOffset(60, 30)
title.Position = UDim2.fromOffset(10, 2)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 11
title.FontFace = uipallet.Font
title.Parent = slider
local valuebox = Instance.new('TextBox')
valuebox.Name = 'Box'
valuebox.Size = UDim2.fromOffset(60, 15)
valuebox.Position = UDim2.new(1, -69, 0, 9)
valuebox.BackgroundTransparency = 1
valuebox.Visible = false
valuebox.Text = ''
valuebox.TextXAlignment = Enum.TextXAlignment.Right
valuebox.TextColor3 = color.Dark(uipallet.Text, 0.16)
valuebox.TextSize = 11
valuebox.FontFace = uipallet.Font
valuebox.ClearTextOnFocus = true
valuebox.Parent = slider
local bkg = Instance.new('Frame')
bkg.Name = 'Slider'
bkg.Size = UDim2.new(1, -20, 0, 2)
bkg.Position = UDim2.fromOffset(10, 39)
bkg.BackgroundColor3 = Color3.new(1, 1, 1)
bkg.BorderSizePixel = 0
bkg.Parent = slider
local rainbowTable = {}
for i = 0, 1, 0.1 do
	table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
end
local gradient = Instance.new('UIGradient')
gradient.Color = ColorSequence.new(rainbowTable)
gradient.Parent = bkg
local fill = bkg:Clone()
fill.Name = 'Fill'
fill.Size = UDim2.fromScale(math.clamp(optionapi.Hue, 0.04, 0.96), 1)
fill.Position = UDim2.new()
fill.BackgroundTransparency = 1
fill.Parent = bkg
local preview = Instance.new('ImageButton')
preview.Name = 'Preview'
preview.Size = UDim2.fromOffset(12, 12)
preview.Position = UDim2.new(1, -22, 0, 10)
preview.BackgroundTransparency = 1
preview.Image = getcustomasset('newvape/assets/new/colorpreview.png')
preview.ImageColor3 = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
preview.ImageTransparency = 1 - optionapi.Opacity
preview.Parent = slider
local expandbutton = Instance.new('TextButton')
expandbutton.Name = 'Expand'
expandbutton.Size = UDim2.fromOffset(17, 13)
expandbutton.Position = UDim2.new(0, getfontsize(title.Text, title.TextSize, title.Font, Vector2.new(1000, 1000)).X + 11, 0, 7)
expandbutton.BackgroundTransparency = 1
expandbutton.Text = ''
expandbutton.Parent = slider
local expand = Instance.new('ImageLabel')
expand.Name = 'Expand'
expand.Size = UDim2.fromOffset(9, 5)
expand.Position = UDim2.fromOffset(4, 4)
expand.BackgroundTransparency = 1
expand.Image = getcustomasset('newvape/assets/new/expandicon.png')
expand.ImageColor3 = color.Dark(uipallet.Text, 0.43)
expand.Parent = expandbutton
local rainbow = Instance.new('TextButton')
rainbow.Name = 'Rainbow'
rainbow.Size = UDim2.fromOffset(12, 12)
rainbow.Position = UDim2.new(1, -42, 0, 10)
rainbow.BackgroundTransparency = 1
rainbow.Text = ''
rainbow.Parent = slider
local rainbow1 = Instance.new('ImageLabel')
rainbow1.Size = UDim2.fromOffset(12, 12)
rainbow1.BackgroundTransparency = 1
rainbow1.Image = getcustomasset('newvape/assets/new/rainbow_1.png')
rainbow1.ImageColor3 = color.Light(uipallet.Main, 0.37)
rainbow1.Parent = rainbow
local rainbow2 = rainbow1:Clone()
rainbow2.Image = getcustomasset('newvape/assets/new/rainbow_2.png')
rainbow2.Parent = rainbow
local rainbow3 = rainbow1:Clone()
rainbow3.Image = getcustomasset('newvape/assets/new/rainbow_3.png')
rainbow3.Parent = rainbow
local rainbow4 = rainbow1:Clone()
rainbow4.Image = getcustomasset('newvape/assets/new/rainbow_4.png')
rainbow4.Parent = rainbow
local knobholder = Instance.new('Frame')
knobholder.Name = 'Knob'
knobholder.Size = UDim2.fromOffset(24, 4)
knobholder.Position = UDim2.fromScale(1, 0.5)
knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
knobholder.BackgroundColor3 = slider.BackgroundColor3
knobholder.BorderSizePixel = 0
knobholder.Parent = fill
local knob = Instance.new('Frame')
knob.Name = 'Knob'
knob.Size = UDim2.fromOffset(14, 14)
knob.Position = UDim2.fromScale(0.5, 0.5)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = uipallet.Text
knob.Parent = knobholder
addCorner(knob, UDim.new(1, 0))
optionsettings.Function = optionsettings.Function or function() end
local satSlider = createSlider('Saturation', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, optionapi.Value)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(optionapi.Hue, 1, optionapi.Value))
}))
local vibSlider = createSlider('Vibrance', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(optionapi.Hue, optionapi.Sat, 1))
}))
local opSlider = createSlider('Opacity', ColorSequence.new({
	ColorSequenceKeypoint.new(0, color.Dark(uipallet.Main, 0.02)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value))
}))

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
	preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
	preview.ImageTransparency = 1 - self.Opacity
	satSlider.Slider.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, self.Value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, self.Value))
	})
	vibSlider.Slider.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, 1))
	})
	opSlider.Slider.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color.Dark(uipallet.Main, 0.02)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, self.Value))
	})

	if self.Rainbow then
		fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
	else
		tween:Tween(fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
		})
	end

	if s then
		tween:Tween(satSlider.Slider.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
		})
	end
	if v then
		tween:Tween(vibSlider.Slider.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
		})
	end
	if o then
		tween:Tween(opSlider.Slider.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Opacity, 0.04, 0.96), 1)
		})
	end

	optionsettings.Function(self.Hue, self.Sat, self.Value, self.Opacity)
end

function optionapi:Toggle()
	self.Rainbow = not self.Rainbow
	if self.Rainbow then
		table.insert(mainapi.RainbowTable, self)
		rainbow1.ImageColor3 = Color3.fromRGB(5, 127, 100)
		task.delay(0.1, function()
			if not self.Rainbow then return end
			rainbow2.ImageColor3 = Color3.fromRGB(228, 125, 43)
			task.delay(0.1, function()
				if not self.Rainbow then return end
				rainbow3.ImageColor3 = Color3.fromRGB(225, 46, 52)
			end)
		end)
	else
		local ind = table.find(mainapi.RainbowTable, self)
		if ind then
			table.remove(mainapi.RainbowTable, ind)
		end
		rainbow3.ImageColor3 = color.Light(uipallet.Main, 0.37)
		task.delay(0.1, function()
			if self.Rainbow then return end
			rainbow2.ImageColor3 = color.Light(uipallet.Main, 0.37)
			task.delay(0.1, function()
				if self.Rainbow then return end
				rainbow1.ImageColor3 = color.Light(uipallet.Main, 0.37)
			end)
		end)
	end
end

local doubleClick = tick()
preview.MouseButton1Click:Connect(function()
	preview.Visible = false
	valuebox.Visible = true
	valuebox:CaptureFocus()
	local text = Color3.fromHSV(optionapi.Hue, optionapi.Sat, optionapi.Value)
	valuebox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
end)
slider.InputBegan:Connect(function(inputObj)
	if
		(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
		and (inputObj.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
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
slider.MouseEnter:Connect(function()
	tween:Tween(knob, uipallet.Tween, {
		Size = UDim2.fromOffset(16, 16)
	})
end)
slider.MouseLeave:Connect(function()
	tween:Tween(knob, uipallet.Tween, {
		Size = UDim2.fromOffset(14, 14)
	})
end)
slider:GetPropertyChangedSignal('Visible'):Connect(function()
	satSlider.Visible = expand.Rotation == 180 and slider.Visible
	vibSlider.Visible = satSlider.Visible
	opSlider.Visible = satSlider.Visible
end)
expandbutton.MouseEnter:Connect(function()
	expand.ImageColor3 = color.Dark(uipallet.Text, 0.16)
end)
expandbutton.MouseLeave:Connect(function()
	expand.ImageColor3 = color.Dark(uipallet.Text, 0.43)
end)
expandbutton.MouseButton1Click:Connect(function()
	satSlider.Visible = not satSlider.Visible
	vibSlider.Visible = satSlider.Visible
	opSlider.Visible = satSlider.Visible
	expand.Rotation = satSlider.Visible and 180 or 0
end)
rainbow.MouseButton1Click:Connect(function()
	optionapi:Toggle()
end)
valuebox.FocusLost:Connect(function(enter)
	preview.Visible = true
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