local component = {
	Type = 'ColorSlider',
	Hue = props.DefaultHue or 0.44,
	Sat = props.DefaultSat or 1,
	Value = props.DefaultValue or 1,
	Opacity = props.DefaultOpacity or 1,
	Rainbow = false,
	Index = 0
}

local function createExtraSlider(name, gradientColor)
	local colorslidercustom = Instance.new('TextButton')
	colorslidercustom.AutoButtonColor = false
	colorslidercustom.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
	colorslidercustom.BorderSizePixel = 0
	colorslidercustom.Size = UDim2.new(1, 0, 0, 50)
	colorslidercustom.Text = ''
	colorslidercustom.Visible = false
	colorslidercustom.Parent = children
	local title = Instance.new('TextLabel')
	title.BackgroundTransparency = 1
	title.FontFace = uipallet.Font
	title.Position = UDim2.fromOffset(10, 2)
	title.Size = UDim2.fromOffset(60, 30)
	title.Text = name
	title.TextColor3 = color.Dark(uipallet.Text, 0.16)
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = colorslidercustom
	local holder = Instance.new('Frame')
	holder.BackgroundColor3 = Color3.new(1, 1, 1)
	holder.BorderSizePixel = 0
	holder.Name = 'Holder'
	holder.Position = UDim2.fromOffset(10, 37)
	holder.Size = UDim2.new(1, -20, 0, 2)
	holder.Parent = colorslidercustom
	local uigradient = Instance.new('UIGradient')
	uigradient.Color = gradientColor
	uigradient.Parent = holder
	local fill = Instance.new('Frame')
	fill.BackgroundTransparency = 1
	fill.Name = 'Fill'
	fill.Size = UDim2.fromScale(math.clamp(name == 'Saturation' and component.Sat or name == 'Vibrance' and component.Value or component.Opacity, 0.04, 0.96), 1)
	fill.Parent = holder
	local knobholder = Instance.new('Frame')
	knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
	knobholder.BackgroundColor3 = colorslidercustom.BackgroundColor3
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

	colorslidercustom.InputBegan:Connect(function(input)
		if
			(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			and (input.Position.Y - colorslidercustom.AbsolutePosition.Y) > (20 * scale.Scale)
		then
			local releaseConnection
			local moveConnection = inputService.InputChanged:Connect(function(newInput)
				if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local newValue = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
					component:SetValue(nil, name == 'Saturation' and newValue or nil, name == 'Vibrance' and newValue or nil, name == 'Opacity' and newValue or nil)
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

	colorslidercustom.MouseEnter:Connect(function()
		tween:Tween(knob, uipallet.Tween, {
			Size = UDim2.fromOffset(16, 16)
		})
	end)

	colorslidercustom.MouseLeave:Connect(function()
		tween:Tween(knob, uipallet.Tween, {
			Size = UDim2.fromOffset(14, 14)
		})
	end)

	return colorslidercustom
end

local colorslider = Instance.new('TextButton')
colorslider.AutoButtonColor = false
colorslider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
colorslider.BorderSizePixel = 0
colorslider.Size = UDim2.new(1, 0, 0, 50)
colorslider.Text = ''
colorslider.Visible = props.Visible == nil or props.Visible
colorslider.Parent = children
component.Object = colorslider
addTooltip(colorslider, props.Tooltip)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(10, 2)
title.Size = UDim2.fromOffset(60, 30)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = colorslider
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
custombox.Parent = colorslider
local holder = Instance.new('Frame')
holder.BackgroundColor3 = Color3.new(1, 1, 1)
holder.BorderSizePixel = 0
holder.Position = UDim2.fromOffset(10, 39)
holder.Size = UDim2.new(1, -20, 0, 2)
holder.Parent = colorslider
local rainbowTable = {}
for i = 0, 1, 0.1 do
	table.insert(rainbowTable, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
end
local uigradient = Instance.new('UIGradient')
uigradient.Color = ColorSequence.new(rainbowTable)
uigradient.Parent = holder
local fill = Instance.new('Frame')
fill.BackgroundTransparency = 1
fill.Size = UDim2.fromScale(math.clamp(component.Hue, 0.04, 0.96), 1)
fill.Parent = holder
local knobholder = Instance.new('Frame')
knobholder.AnchorPoint = Vector2.new(0.5, 0.5)
knobholder.BackgroundColor3 = colorslider.BackgroundColor3
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
local preview = Instance.new('ImageButton')
preview.BackgroundTransparency = 1
preview.Image = getvapeasset('newvape/assets/new/colorpreview.png')
preview.ImageColor3 = Color3.fromHSV(component.Hue, component.Sat, component.Value)
preview.ImageTransparency = 1 - component.Opacity
preview.Position = UDim2.new(1, -22, 0, 10)
preview.Size = UDim2.fromOffset(12, 12)
preview.Parent = colorslider
local expand = Instance.new('TextButton')
expand.BackgroundTransparency = 1
expand.Position = UDim2.fromOffset(getfontbounds(title.Text, title.TextSize, title.FontFace).X + 11, 7)
expand.Size = UDim2.fromOffset(17, 13)
expand.Text = ''
expand.Parent = colorslider
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
rainbow.Parent = colorslider
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
props.Function = props.Function or function() end

local satSlider = createExtraSlider('Saturation', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, component.Value)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, 1, component.Value))
}))

local vibSlider = createExtraSlider('Vibrance', ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, 1))
}))

local opSlider = createExtraSlider('Opacity', ColorSequence.new({
	ColorSequenceKeypoint.new(0, color.Dark(uipallet.Main, 0.02)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(component.Hue, component.Sat, component.Value))
}))

function component:Load(data)
	if data.Rainbow ~= self.Rainbow then
		self:Toggle()
	end

	if self.Hue ~= data.Hue or self.Sat ~= data.Sat or self.Value ~= data.Value or self.Opacity ~= data.Opacity then
		self:SetValue(data.Hue, data.Sat, data.Value, data.Opacity)
	end
end

function component:Save(data)
	data[props.Name] = {
		Hue = self.Hue,
		Sat = self.Sat,
		Value = self.Value,
		Opacity = self.Opacity,
		Rainbow = self.Rainbow
	}
end

function component:SetValue(h, s, v, o)
	self.Hue = h or self.Hue
	self.Sat = s or self.Sat
	self.Value = v or self.Value
	self.Opacity = o or self.Opacity
	preview.ImageColor3 = Color3.fromHSV(self.Hue, self.Sat, self.Value)
	preview.ImageTransparency = 1 - self.Opacity

	satSlider.Holder.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, self.Value)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, 1, self.Value))
	})

	vibSlider.Holder.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Hue, self.Sat, 1))
	})

	opSlider.Holder.UIGradient.Color = ColorSequence.new({
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
		tween:Tween(satSlider.Holder.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Sat, 0.04, 0.96), 1)
		})
	end

	if v then
		tween:Tween(vibSlider.Holder.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Value, 0.04, 0.96), 1)
		})
	end

	if o then
		tween:Tween(opSlider.Holder.Fill, uipallet.Tween, {
			Size = UDim2.fromScale(math.clamp(self.Opacity, 0.04, 0.96), 1)
		})
	end

	props.Function(self.Hue, self.Sat, self.Value, self.Opacity)
end

function component:Toggle()
	self.Rainbow = not self.Rainbow

	if self.Rainbow then
		table.insert(vape.RainbowSliders, self)

		ring1.ImageColor3 = Color3.fromRGB(5, 127, 100)
		task.delay(0.1, function()
			if not self.Rainbow then return end
			ring2.ImageColor3 = Color3.fromRGB(228, 125, 43)
			task.delay(0.1, function()
				if not self.Rainbow then return end
				ring3.ImageColor3 = Color3.fromRGB(225, 46, 52)
			end)
		end)
	else
		local index = table.find(vape.RainbowSliders, self)
		if index then
			table.remove(vape.RainbowSliders, index)
		end

		ring3.ImageColor3 = color.Light(uipallet.Main, 0.37)
		task.delay(0.1, function()
			if self.Rainbow then return end
			ring2.ImageColor3 = color.Light(uipallet.Main, 0.37)
			task.delay(0.1, function()
				if self.Rainbow then return end
				ring1.ImageColor3 = color.Light(uipallet.Main, 0.37)
			end)
		end)
	end
end

preview.MouseButton1Click:Connect(function()
	preview.Visible = false
	custombox.Visible = true
	custombox:CaptureFocus()

	local text = Color3.fromHSV(component.Hue, component.Sat, component.Value)
	custombox.Text = math.round(text.R * 255)..', '..math.round(text.G * 255)..', '..math.round(text.B * 255)
end)

local doubleClick = os.clock()
colorslider.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and (input.Position.Y - colorslider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
		local releaseConnection
		local moveConnection = inputService.InputChanged:Connect(function(newInput)
			if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				component:SetValue(math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1))
			end
		end)

		releaseConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				moveConnection:Disconnect()
				releaseConnection:Disconnect()
			end
		end)

		if doubleClick > os.clock() then
			component:Toggle()
		else
			component:SetValue(math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1))
		end

		doubleClick = os.clock() + 0.3
	end
end)

colorslider.MouseEnter:Connect(function()
	tween:Tween(knob, uipallet.Tween, {
		Size = UDim2.fromOffset(16, 16)
	})
end)

colorslider.MouseLeave:Connect(function()
	tween:Tween(knob, uipallet.Tween, {
		Size = UDim2.fromOffset(14, 14)
	})
end)

colorslider:GetPropertyChangedSignal('Visible'):Connect(function()
	satSlider.Visible = icon.Rotation == 180 and colorslider.Visible
	vibSlider.Visible = satSlider.Visible
	opSlider.Visible = satSlider.Visible
end)

expand.MouseEnter:Connect(function()
	icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
end)

expand.MouseLeave:Connect(function()
	icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
end)

expand.MouseButton1Click:Connect(function()
	satSlider.Visible = not satSlider.Visible
	vibSlider.Visible = satSlider.Visible
	opSlider.Visible = satSlider.Visible
	icon.Rotation = satSlider.Visible and 180 or 0
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
			return tonumber(commas[1]) and Color3.fromRGB(tonumber(commas[1]), tonumber(commas[2]), tonumber(commas[3])) or Color3.fromHex(valuebox.Text)
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