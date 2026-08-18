local component = {
	Index = getTableSize(api.Options),
	Max = props.Max,
	Type = 'Slider',
	Value = props.Default or props.Min,
}

local slider = Instance.new('TextButton')
slider.AutoButtonColor = false
slider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
slider.BorderSizePixel = 0
slider.Size = UDim2.new(1, 0, 0, 50)
slider.Text = ''
slider.Visible = props.Visible == nil or props.Visible
slider.Parent = children
component.Object = slider
addTooltip(slider, props.Tooltip)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(10, 2)
title.Size = UDim2.fromOffset(60, 30)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = slider
local valuelabel = Instance.new('TextButton')
valuelabel.BackgroundTransparency = 1
valuelabel.FontFace = uipallet.Font
valuelabel.Position = UDim2.new(1, -69, 0, 9)
valuelabel.Size = UDim2.fromOffset(60, 15)
valuelabel.Text = component.Value..(props.Suffix and ' '..(type(props.Suffix) == 'function' and props.Suffix(component.Value) or props.Suffix) or '')
valuelabel.TextColor3 = color.Dark(uipallet.Text, 0.16)
valuelabel.TextSize = 11
valuelabel.TextXAlignment = Enum.TextXAlignment.Right
valuelabel.Parent = slider
local custombox = Instance.new('TextBox')
custombox.BackgroundTransparency = 1
custombox.ClearTextOnFocus = false
custombox.FontFace = uipallet.Font
custombox.Position = valuelabel.Position
custombox.Size = valuelabel.Size
custombox.Text = component.Value
custombox.TextColor3 = color.Dark(uipallet.Text, 0.16)
custombox.TextSize = 11
custombox.TextXAlignment = Enum.TextXAlignment.Right
custombox.Visible = false
custombox.Parent = slider
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
holder.BorderSizePixel = 0
holder.Position = UDim2.fromOffset(10, 37)
holder.Size = UDim2.new(1, -20, 0, 2)
holder.Parent = slider
local fill = Instance.new('Frame')
fill.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
fill.BorderSizePixel = 0
fill.Size = UDim2.fromScale(math.clamp((component.Value - props.Min) / props.Max, 0.04, 0.96), 1)
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
knob.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
knob.Position = UDim2.fromScale(0.5, 0.5)
knob.Size = UDim2.fromOffset(14, 14)
knob.Parent = knobholder
addCorner(knob, UDim.new(1, 0))
props.Function = props.Function or function() end
props.Decimal = props.Decimal or 1

function component:Color(hue, sat, val, isRainbow)
	fill.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	knob.BackgroundColor3 = fill.BackgroundColor3
end

function component:Load(data)
	local newValue = data.Value == data.Max and data.Max ~= self.Max and self.Max or data.Value
	if self.Value ~= newValue then
		self:SetValue(newValue, nil, true)
	end
end

function component:Save(data)
	data[props.Name] = {
		Value = self.Value,
		Max = self.Max
	}
end

function component:SetValue(value, position, wasReleased)
	if not math.isfinite(value) then
		return
	end

	tween:Tween(fill, uipallet.Tween, {
		Size = UDim2.fromScale(math.clamp(position or math.clamp(value / props.Max, 0, 1), 0.04, 0.96), 1)
	})

	if self.Value ~= value or wasReleased then
		self.Value = value
		valuelabel.Text = self.Value..(props.Suffix and ' '..(type(props.Suffix) == 'function' and props.Suffix(self.Value) or props.Suffix) or '')
		props.Function(value, wasReleased)
	end
end

slider.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and (input.Position.Y - slider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
		local newPosition = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
		local lastPosition = newPosition

		local releaseConnection
		local moveConnection = inputService.InputChanged:Connect(function(newInput)
			if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				local newPosition = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
				component:SetValue(math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
				lastPosition = newPosition
			end
		end)

		releaseConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				moveConnection:Disconnect()
				releaseConnection:Disconnect()
				component:SetValue(component.Value, lastPosition, true)
			end
		end)

		component:SetValue(math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
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

valuelabel.MouseButton1Click:Connect(function()
	valuelabel.Visible = false
	custombox.Visible = true
	custombox.Text = component.Value
	custombox:CaptureFocus()
end)

custombox.FocusLost:Connect(function(enter)
	valuelabel.Visible = true
	custombox.Visible = false

	if enter and tonumber(custombox.Text) then
		component:SetValue(tonumber(custombox.Text), nil, true)
	end
end)

api.Options[props.Name] = component

return component