local component = {
	Index = getTableSize(api.Options),
	Max = props.Max,
	Type = 'TwoSlider',
	ValueMin = props.DefaultMin or props.Min,
	ValueMax = props.DefaultMax or 10
}

local twoslider = Instance.new('TextButton')
twoslider.AutoButtonColor = false
twoslider.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
twoslider.BorderSizePixel = 0
twoslider.Size = UDim2.new(1, 0, 0, 50)
twoslider.Text = ''
twoslider.Visible = props.Visible == nil or props.Visible
twoslider.Parent = children
component.Object = twoslider
addTooltip(twoslider, props.Tooltip)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(10, 2)
title.Size = UDim2.fromOffset(60, 30)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = twoslider
local maxvalue = Instance.new('TextButton')
maxvalue.BackgroundTransparency = 1
maxvalue.FontFace = uipallet.Font
maxvalue.Position = UDim2.new(1, -69, 0, 9)
maxvalue.Size = UDim2.fromOffset(60, 15)
maxvalue.Text = component.ValueMax
maxvalue.TextColor3 = color.Dark(uipallet.Text, 0.16)
maxvalue.TextSize = 11
maxvalue.TextXAlignment = Enum.TextXAlignment.Right
maxvalue.Parent = twoslider
local minvalue = maxvalue:Clone()
minvalue.Position = UDim2.new(1, -125, 0, 9)
minvalue.Text = component.ValueMin
minvalue.Parent = twoslider
local custommax = Instance.new('TextBox')
custommax.BackgroundTransparency = 1
custommax.ClearTextOnFocus = false
custommax.FontFace = uipallet.Font
custommax.Position = maxvalue.Position
custommax.Size = UDim2.fromOffset(60, 15)
custommax.Text = component.ValueMax
custommax.TextColor3 = color.Dark(uipallet.Text, 0.16)
custommax.TextSize = 11
custommax.TextXAlignment = Enum.TextXAlignment.Right
custommax.Visible = false
custommax.Parent = twoslider
local custommin = custommax:Clone()
custommin.Position = minvalue.Position
custommin.Parent = twoslider
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
holder.BorderSizePixel = 0
holder.Position = UDim2.fromOffset(10, 37)
holder.Size = UDim2.new(1, -20, 0, 2)
holder.Parent = twoslider
local fill = Instance.new('Frame')
fill.BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
fill.BorderSizePixel = 0
fill.Position = UDim2.fromScale(math.clamp(component.ValueMin / props.Max, 0.04, 0.96), 0)
fill.Size = UDim2.fromScale(math.clamp(math.clamp(component.ValueMax / props.Max, 0, 1), 0.04, 0.96) - fill.Position.X.Scale, 1)
fill.Parent = holder
local knob = Instance.new('Frame')
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.BackgroundColor3 = twoslider.BackgroundColor3
knob.BorderSizePixel = 0
knob.Position = UDim2.fromScale(0, 0.5)
knob.Size = UDim2.fromOffset(16, 4)
knob.Parent = fill
local knobknob = Instance.new('ImageLabel')
knobknob.AnchorPoint = Vector2.new(0.5, 0.5)
knobknob.BackgroundTransparency = 1
knobknob.Image = getvapeasset('newvape/assets/new/range.png')
knobknob.ImageColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)
knobknob.Position = UDim2.fromScale(0.5, 0.5)
knobknob.Size = UDim2.fromOffset(9, 16)
knobknob.Parent = knob
local knobmax = knob:Clone()
knobmax.Position = UDim2.fromScale(1, 0.5)
knobmax.Parent = fill
local knobmaxknob = knobmax.ImageLabel
knobmaxknob.Rotation = 180
local arrow = Instance.new('ImageLabel')
arrow.BackgroundTransparency = 1
arrow.Image = getvapeasset('newvape/assets/new/rangeindicator.png')
arrow.ImageColor3 = color.Light(uipallet.Main, 0.14)
arrow.Position = UDim2.new(1, -56, 0, 10)
arrow.Size = UDim2.fromOffset(12, 6)
arrow.Parent = twoslider
props.Function = props.Function or function() end
props.Decimal = props.Decimal or 1
local random = Random.new()

function component:Color(hue, sat, val, isRainbow)
	fill.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	knobknob.ImageColor3 = fill.BackgroundColor3
	knobmaxknob.ImageColor3 = fill.BackgroundColor3
end

function component:GetRandomValue()
	return random:NextNumber(component.ValueMin, component.ValueMax)
end

function component:Load(data)
	if self.ValueMin ~= data.ValueMin then
		self:SetValue(false, data.ValueMin)
	end

	if self.ValueMax ~= data.ValueMax then
		self:SetValue(true, data.ValueMax)
	end
end

function component:Save(data)
	data[props.Name] = {
		ValueMin = self.ValueMin,
		ValueMax = self.ValueMax
	}
end

function component:SetValue(isMax, value)
	if not math.isfinite(value) then
		return
	end

	self[isMax and 'ValueMax' or 'ValueMin'] = value
	maxvalue.Text = self.ValueMax
	minvalue.Text = self.ValueMin

	local size = math.clamp(math.clamp(self.ValueMin / props.Max, 0, 1), 0.04, 0.96)
	tween:Tween(fill, TweenInfo.new(0.1), {
		Position = UDim2.fromScale(size, 0),
		Size = UDim2.fromScale(math.clamp(math.clamp(self.ValueMax / props.Max, 0.04, 0.96) - size, 0, 1), 1)
	})
end

knob.MouseEnter:Connect(function()
	tween:Tween(knobknob, uipallet.Tween, {
		Size = UDim2.fromOffset(11, 18)
	})
end)

knob.MouseLeave:Connect(function()
	tween:Tween(knobknob, uipallet.Tween, {
		Size = UDim2.fromOffset(9, 16)
	})
end)

knobmax.MouseEnter:Connect(function()
	tween:Tween(knobmaxknob, uipallet.Tween, {
		Size = UDim2.fromOffset(11, 18)
	})
end)

knobmax.MouseLeave:Connect(function()
	tween:Tween(knobmaxknob, uipallet.Tween, {
		Size = UDim2.fromOffset(9, 16)
	})
end)

twoslider.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and (input.Position.Y - twoslider.AbsolutePosition.Y) > (20 * scale.Scale)
	then
		local maxCheck = (input.Position.X - knobmax.AbsolutePosition.X) > -10
		local newPosition = math.clamp((input.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)

		local releaseConnection
		local moveConnection = inputService.InputChanged:Connect(function(newInput)
			if newInput.UserInputType == (input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
				local newPosition = math.clamp((newInput.Position.X - holder.AbsolutePosition.X) / holder.AbsoluteSize.X, 0, 1)
				component:SetValue(maxCheck, math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
			end
		end)

		releaseConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				moveConnection:Disconnect()
				releaseConnection:Disconnect()
			end
		end)

		component:SetValue(maxCheck, math.floor((props.Min + (props.Max - props.Min) * newPosition) * props.Decimal) / props.Decimal, newPosition)
	end
end)

maxvalue.MouseButton1Click:Connect(function()
	maxvalue.Visible = false
	custommax.Visible = true
	custommax.Text = component.ValueMax
	custommax:CaptureFocus()
end)

minvalue.MouseButton1Click:Connect(function()
	minvalue.Visible = false
	custommin.Visible = true
	custommin.Text = component.ValueMin
	custommin:CaptureFocus()
end)

custommax.FocusLost:Connect(function(enter)
	maxvalue.Visible = true
	custommax.Visible = false

	if enter and tonumber(custommax.Text) then
		component:SetValue(true, tonumber(custommax.Text))
	end
end)

custommin.FocusLost:Connect(function(enter)
	minvalue.Visible = true
	custommin.Visible = false

	if enter and tonumber(custommin.Text) then
		component:SetValue(false, tonumber(custommin.Text))
	end
end)

api.Options[props.Name] = component

return component