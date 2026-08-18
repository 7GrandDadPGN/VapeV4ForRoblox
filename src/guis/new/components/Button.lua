local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
button.BorderSizePixel = 0
button.Size = UDim2.new(1, 0, 0, 31)
button.Text = ''
button.Parent = children
addTooltip(button, props.Tooltip)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
holder.Position = UDim2.fromOffset(10, 2)
holder.Size = UDim2.fromOffset(200, 27)
holder.Parent = button
addCorner(holder)
local title = Instance.new('TextLabel')
title.BackgroundColor3 = uipallet.Main
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(2, 2)
title.Size = UDim2.new(1, -4, 1, -4)
title.Text = props.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 14
title.Parent = holder
addCorner(title, UDim.new(0, 4))
props.Function = props.Function or function() end

button.MouseEnter:Connect(function()
	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
	})
end)

button.MouseLeave:Connect(function()
	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.05)
	})
end)

button.MouseButton1Click:Connect(props.Function)