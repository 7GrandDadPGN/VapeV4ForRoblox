local component = {
	Options = {},
	Type = 'OverlayBar'
}

local bar = Instance.new('Frame')
bar.Name = 'Overlays'
bar.Size = UDim2.fromOffset(220, 36)
bar.BackgroundColor3 = uipallet.Main
bar.BorderSizePixel = 0
bar.Parent = children
components.Divider(nil, bar)
local button = Instance.new('ImageButton')
button.AutoButtonColor = false
button.BackgroundTransparency = 1
button.Image = getvapeasset('newvape/assets/new/overlays.png')
button.ImageColor3 = color.Light(uipallet.Main, 0.37)
button.Position = UDim2.new(1, -34, 0, 7)
button.Size = UDim2.fromOffset(24, 24)
button.Parent = bar
addCorner(button, UDim.new(1, 0))
addTooltip(button, 'Open overlays menu')
local shadow = Instance.new('TextButton')
shadow.AutoButtonColor = false
shadow.BackgroundColor3 = Color3.new()
shadow.BackgroundTransparency = 1
shadow.ClipsDescendants = true
shadow.Name = 'Shadow'
shadow.Size = UDim2.new(1, 0, 1, -5)
shadow.Text = ''
shadow.Visible = false
shadow.Parent = api.Object
addCorner(shadow)
local window = Instance.new('Frame')
window.BackgroundColor3 = uipallet.Main
window.Position = UDim2.fromScale(0, 1)
window.Size = UDim2.fromOffset(220, 42)
window.Parent = shadow
addCorner(window)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/overlayslarge.png')
icon.ImageColor3 = uipallet.Text
icon.Position = UDim2.fromOffset(10, 13)
icon.Size = UDim2.fromOffset(14, 12)
icon.Parent = window
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(36, 0)
title.Size = UDim2.new(1, -36, 0, 38)
title.Text = 'Overlays'
title.TextColor3 = uipallet.Text
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window
local close = addCloseButton(window, false, UDim2.new(1, -35, 0, 7))
local divider = Instance.new('Frame')
divider.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
divider.BorderSizePixel = 0
divider.Position = UDim2.fromOffset(0, 37)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Parent = window
local childrentoggle = Instance.new('Frame')
childrentoggle.BackgroundColor3 = uipallet.Main
childrentoggle.BackgroundTransparency = 1
childrentoggle.Position = UDim2.fromOffset(0, 38)
childrentoggle.Parent = window
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = childrentoggle

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, childrentoggle, component)
	end
end

button.MouseEnter:Connect(function()
	button.ImageColor3 = uipallet.Text
	tween:Tween(button, uipallet.Tween, {
		BackgroundTransparency = 0.9
	})
end)

button.MouseLeave:Connect(function()
	button.ImageColor3 = color.Light(uipallet.Main, 0.37)
	tween:Tween(button, uipallet.Tween, {
		BackgroundTransparency = 1
	})
end)

button.MouseButton1Click:Connect(function()
	shadow.Visible = true
	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 0.5
	})

	tween:Tween(window, uipallet.Tween, {
		Position = UDim2.new(0, 0, 1, -(window.Size.Y.Offset))
	})
end)

close.MouseButton1Click:Connect(function()
	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 1
	})

	tween:Tween(window, uipallet.Tween, {
		Position = UDim2.fromScale(0, 1)
	})

	task.delay(0.2, function()
		shadow.Visible = false
	end)
end)

shadow.MouseButton1Click:Connect(function()
	tween:Tween(shadow, uipallet.Tween, {
		BackgroundTransparency = 1
	})

	tween:Tween(window, uipallet.Tween, {
		Position = UDim2.fromScale(0, 1)
	})

	task.delay(0.2, function()
		shadow.Visible = false
	end)
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	window.Size = UDim2.fromOffset(220, math.min(37 + windowlist.AbsoluteContentSize.Y / scale.Scale, 605))
	childrentoggle.Size = UDim2.fromOffset(220, window.Size.Y.Offset - 5)
end)

vape.Overlays = component

return component