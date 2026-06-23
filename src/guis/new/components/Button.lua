local button = Instance.new('TextButton')
button.Name = optionsettings.Name..'Button'
button.Size = UDim2.new(1, 0, 0, 31)
button.BackgroundColor3 = color.Dark(children.BackgroundColor3, optionsettings.Darker and 0.02 or 0)
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Visible = optionsettings.Visible == nil or optionsettings.Visible
button.Text = ''
button.Parent = children
addTooltip(button, optionsettings.Tooltip)
local bkg = Instance.new('Frame')
bkg.Size = UDim2.fromOffset(200, 27)
bkg.Position = UDim2.fromOffset(10, 2)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
bkg.Parent = button
addCorner(bkg)
local label = Instance.new('TextLabel')
label.Size = UDim2.new(1, -4, 1, -4)
label.Position = UDim2.fromOffset(2, 2)
label.BackgroundColor3 = uipallet.Main
label.Text = optionsettings.Name
label.TextColor3 = color.Dark(uipallet.Text, 0.16)
label.TextSize = 14
label.FontFace = uipallet.Font
label.Parent = bkg
addCorner(label, UDim.new(0, 4))
optionsettings.Function = optionsettings.Function or function() end

button.MouseEnter:Connect(function()
	tween:Tween(bkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
	})
end)
button.MouseLeave:Connect(function()
	tween:Tween(bkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.05)
	})
end)
button.MouseButton1Click:Connect(optionsettings.Function)