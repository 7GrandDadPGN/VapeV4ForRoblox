local component = {
	CustomColor = false,
	Hue = 0.46,
	Notch = 4,
	Rainbow = false,
	Sat = 0.96,
	Type = 'GUISlider',
	Value = 0.52
}
local colors = {
	Color3.fromRGB(250, 50, 56),
	Color3.fromRGB(242, 99, 33),
	Color3.fromRGB(252, 179, 22),
	Color3.fromRGB(5, 133, 104),
	Color3.fromRGB(47, 122, 229),
	Color3.fromRGB(126, 84, 217),
	Color3.fromRGB(232, 96, 152)
}
local colorPositions = {
	4,
	33,
	62,
	90,
	119,
	148,
	177
}

local function createSlider(name, gradientColor)
	local slider = Instance.new('TextButton')
	slider.Name = props.Name..'Slider'..name
	slider.Size = UDim2.fromOffset(220, 50)
	slider.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
	slider.BorderSizePixel = 0
	slider.AutoButtonColor = false
	slider.Visible = false
	slider.Text = ''
	slider.Parent = children
	local title = Instance.new('TextLabel')
	title.BackgroundTransparency = 1
	title.FontFace = uipallet.Font
	title.Position = UDim2.fromOffset(10, 2)
	title.Size = UDim2.fromOffset(60, 30)
	title.Text = name
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = slider
	local holder = Instance.new('Frame')
	holder.BackgroundColor3 = Color3.new(1, 1, 1)
	holder.BorderSizePixel = 0
	holder.Name = 'Holder'
	holder.Position = UDim2.fromOffset(10, 37)
	holder.Size = UDim2.new(1, -20, 0, 2)
	holder.Parent = slider
	local uigradient = Instance.new('UIGradient')
	uigradient.Color = gradientColor
	uigradient.Parent = holder
	local fill = Instance.new('Frame')
	fill.BackgroundTransparency = 1
	fill.Name = 'Fill'
	fill.Size = UDim2.fromScale(math.clamp(1, 0.04, 0.96), 1)
	fill.Parent = holder
	local knobholder = Instance.new('Frame')
	knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
	knobholder.BackgroundColor3 = slider.BackgroundColor3
	knobholder.BorderSizePixel = 0
	knobholder.Position = UDim2.fromScale(1, 0.5)
	knobholder.Size = UDim2.fromOffset(24, 4)
	knobholder.Parent = fill
	local knob = Instance.new('Frame')
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = uipallet.Text
	knob.Position = UDim2.fromScale(0.5, 0.5)
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Parent = knobholder
	addCorner(knob, UDim.new(1, 0))

	if name == 'Custom color' then
		local reset = Instance.new('TextButton')
		reset.BackgroundTransparency = 1
		reset.FontFace = uipallet.Font
		reset.Position = UDim2.new(1, -52, 0, 5)
		reset.Size = UDim2.fromOffset(45, 20)
		reset.Text = 'RESET'
		reset.TextColor3 = color.Dark(uipallet.Text, 0.16)
		reset.TextSize = 11
		reset.Parent = slider

		reset.MouseButton1Click:Connect(function()
			component:SetValue(nil, nil, nil, 4)
		end)
	end

	slider.InputBegan:Connect(function(input)
		if
			(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
		then
			local releaseConnection
			local moveConnection = inputService.InputChanged:Connect(function(newInput)
				if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local value = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
					component:SetValue(
						name == 'Custom color' and value or nil,
						name == 'Saturation' and value or nil,
						name == 'Vibrance' and value or nil,
						name == 'Opacity' and value or nil
					)
				end
			end)

			releaseConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					moveConnection:Disconnect()
					releaseConnection:Disconnect()
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
slider.AutoButtonColor = false
slider.BackgroundTransparency = 1
slider.Name = props.Name..'Slider'
slider.Size = UDim2.fromOffset(220, 50)
slider.Text = ''
slider.Parent = children
component.Object = slider
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Name = 'Title'
title.Position = UDim2.fromOffset(10, 2)
title.Size = UDim2.fromOffset(60, 30)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = slider
local holder = Instance.new('Frame')
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.Name = 'Slider'
holder.Position = UDim2.fromOffset(10, 37)
holder.Size = UDim2.fromOffset(200, 2)
holder.Parent = slider
local colorXPos = 0
for index, colorValue in colors do
	local colorframe = Instance.new('Frame')
	colorframe.BackgroundColor3 = colorValue
	colorframe.BorderSizePixel = 0
	colorframe.Position = UDim2.fromOffset(colorXPos, 0)
	colorframe.Size = UDim2.fromOffset(27 + (((index + 1) % 2) == 0 and 1 or 0), 2)
	colorframe.Parent = holder
	colorXPos += (colorframe.Size.X.Offset + 1)
end
local preview = Instance.new('ImageButton')
preview.BackgroundTransparency = 1
preview.Image = getvapeasset('newvape/assets/new/colorpreview.png')
preview.ImageColor3 = Color3.fromHSV(component.Hue, component.Sat, component.Value)
preview.Position = UDim2.new(1, -22, 0, 10)
preview.Size = UDim2.fromOffset(12, 12)
preview.Parent = slider
local custombox = Instance.new('TextBox')
custombox.BackgroundTransparency = 1
custombox.FontFace = uipallet.Font
custombox.Position = UDim2.new(1, -69, 0, 9)
custombox.Size = UDim2.fromOffset(60, 15)
custombox.Text = ''
custombox.TextColor3 = color.Dark(uipallet.Text, 0.16)
custombox.TextSize = 11
custombox.TextXAlignment = Enum.TextXAlignment.Right
custombox.Visible = false
custombox.Parent = slider
local expand = Instance.new('TextButton')
expand.BackgroundTransparency = 1
expand.Position = UDim2.new(0, getfontbounds(title.Text, title.TextSize, title.Font).X + 11, 0, 7)
expand.Size = UDim2.fromOffset(17, 13)
expand.Text = ''
expand.Parent = slider
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/downexpandslider.png')
icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
icon.Position = UDim2.fromOffset(4, 4)
icon.Size = UDim2.fromOffset(10, 5)
icon.Parent = expand
local rainbow = Instance.new('TextButton')
rainbow.BackgroundTransparency = 1
rainbow.Position = UDim2.new(1, -42, 0, 10)
rainbow.Size = UDim2.fromOffset(12, 12)
rainbow.Text = ''
rainbow.Parent = slider
local ring1 = Instance.new('ImageLabel')
ring1.BackgroundTransparency = 1
ring1.Image = getvapeasset('newvape/assets/new/rainbow_1.png')
ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
ring1.Size = UDim2.fromOffset(12, 12)
ring1.Parent = rainbow
local ring2 = Instance.fromExisting(ring1)
ring2.Image = getvapeasset('newvape/assets/new/rainbow_2.png')
ring2.Parent = rainbow
local ring3 = Instance.fromExisting(ring1)
ring3.Image = getvapeasset('newvape/assets/new/rainbow_3.png')
ring3.Parent = rainbow
local ring4 = Instance.fromExisting(ring1)
ring4.Image = getvapeasset('newvape/assets/new/rainbow_4.png')
ring4.Parent = rainbow
local knob = Instance.new('ImageLabel')
knob.BackgroundTransparency = 1
knob.Image = getvapeasset('newvape/assets/new/theme.png')
knob.ImageColor3 = colors[4]
knob.Name = 'Knob'
knob.Position = UDim2.fromOffset(colorPositions[4] - 3, -5)
knob.Size = UDim2.fromOffset(26, 12)
knob.Parent = holder
props.Function = props.Function or function() end
local rainbowTable = {}
for i = 0, 1, 0.1 do
	table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
end

local colorSlider = createSlider('Custom color', ColorSequence.new(rainbowTable))
local satSlider = createSlider('Saturation', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, component.Value)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, 1, component.Value))
}))

local vibSlider = createSlider('Vibrance', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, 1))
}))

local normalknob = getvapeasset('newvape/assets/new/theme.png')
local rainbowknob = getvapeasset('newvape/assets/new/customtheme.png')
local rainbowthread
local currentNotch

function component:Load(data)
	if data.Rainbow then
		self:Toggle()
	end

	if self.Rainbow or data.CustomColor then
		self:SetValue(data.Hue, data.Sat, data.Value)
	else
		self:SetValue(nil, nil, nil, data.Notch)
	end
end

function component:Save(data)
	data[props.Name] = {
		Hue = self.Hue,
		Sat = self.Sat,
		Value = self.Value,
		Notch = self.Notch,
		CustomColor = self.CustomColor,
		Rainbow = self.Rainbow
	}
end

function component:SetValue(h, s, v, n)
	if n then
		if self.Rainbow then
			self:Toggle()
		end

		self.CustomColor = false
		h, s, v = colors[n]:ToHSV()
	else
		self.CustomColor = true
	end

	self.Hue = h or self.Hue
	self.Sat = s or self.Sat
	self.Value = v or self.Value
	self.Notch = n
	preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)

	satSlider.Holder.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, self.Value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, self.Value))
	})

	vibSlider.Holder.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, 1))
	})

	local newNotch = (self.Rainbow or self.CustomColor) and 4 or n or currentNotch
	if self.Rainbow or self.CustomColor then
		knob.Image = rainbowknob
		knob.ImageColor3 = Color3.new(1, 1, 1)

		if newNotch ~= currentNotch then
			tween:Tween(knob, uipallet.Tween, {
				Position = UDim2.fromOffset(colorPositions[4] - 3, -5)
			})
		end
	else
		knob.Image = normalknob
		knob.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)

		if newNotch ~= currentNotch then
			tween:Tween(knob, uipallet.Tween, {
				Position = UDim2.fromOffset(colorPositions[n or 4] - 3, -5)
			})
		end
	end

	currentNotch = newNotch
	if self.Rainbow then
		if h then
			colorSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
		end

		if s then
			satSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
		end

		if v then
			vibSlider.Holder.Fill.Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
		end
	else
		if h then
			tween:Tween(colorSlider.Holder.Fill, uipallet.Tween, {
				Size = UDim2.fromScale(math.clamp(self.Hue, 0.04, 0.96), 1)
			})
		end

		if s then
			tween:Tween(satSlider.Holder.Fill, uipallet.Tween, {
				Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
			})
		end

		if v then
			tween:Tween(vibSlider.Holder.Fill, uipallet.Tween, {
				Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
			})
		end
	end

	props.Function(self.Hue, self.Sat, self.Value)
end

function component:Toggle()
	self.Rainbow = not self.Rainbow
	if rainbowthread then
		task.cancel(rainbowthread)
	end

	if self.Rainbow then
		knob.Image = rainbowknob
		table.insert(vape.RainbowSliders, self)

		ring1.ImageColor3 = Color3.fromRGB(5, 127, 100)
		rainbowthread = task.delay(0.1, function()
			ring2.ImageColor3 = Color3.fromRGB(228, 125, 43)
			rainbowthread = task.delay(0.1, function()
				ring3.ImageColor3 = Color3.fromRGB(225, 46, 52)
				rainbowthread = nil
			end)
		end)
	else
		self:SetValue(nil, nil, nil, 4)
		knob.Image = normalknob
		local index = table.find(vape.RainbowSliders, self)
		if index then
			table.remove(vape.RainbowSliders, index)
		end

		ring3.ImageColor3 = color.Light(uipallet.Main, 0.37)
		rainbowthread = task.delay(0.1, function()
			ring2.ImageColor3 = color.Light(uipallet.Main, 0.37)
			rainbowthread = task.delay(0.1, function()
				ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
				rainbowthread = nil
			end)
		end)
	end
end

expand.MouseEnter:Connect(function()
	icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
end)

expand.MouseLeave:Connect(function()
	icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
end)

expand.MouseButton1Click:Connect(function()
	colorSlider.Visible = not colorSlider.Visible
	satSlider.Visible = colorSlider.Visible
	vibSlider.Visible = satSlider.Visible
	icon.Rotation = satSlider.Visible and 180 or 0
end)

preview.MouseButton1Click:Connect(function()
	preview.Visible = false
	custombox.Visible = true
	custombox:CaptureFocus()
	local text = Color3.fromHSV(component.Hue, component.Sat, component.Value)
	custombox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
end)

slider.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
		local releaseConnection
		local moveConnection = inputService.InputChanged:Connect(function(newInput)
			if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				component:SetValue(nil, nil, nil, math.clamp(math.round((newInput.Position.X - holder.AbsolutePosition.X) / scale.Scale / 27), 1, 7))
			end
		end)

		releaseConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				moveConnection:Disconnect()
				releaseConnection:Disconnect()
			end
		end)

		component:SetValue(nil, nil, nil, math.clamp(math.round((input.Position.X - holder.AbsolutePosition.X) / scale.Scale / 27), 1, 7))
	end
end)

rainbow.MouseButton1Click:Connect(function()
	component:Toggle()
end)

custombox.FocusLost:Connect(function(enter)
	preview.Visible = true
	custombox.Visible = false

	if enter then
		local success, parsed = pcall(function()
			local commas = custombox.Text:split(',')
			return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(custombox.Text)
		end)

		if success then
			if component.Rainbow then
				component:Toggle()
			end

			component:SetValue(parsed:ToHSV())
		end
	end
end)

api.Options[props.Name] = component

return component