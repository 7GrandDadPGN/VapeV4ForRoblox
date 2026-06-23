local button = Instance.new('TextButton')
button.Name = optionsettings.Name..'Button'
button.Size = UDim2.new(1, api.Category and -8 or 0, 0, 26)
button.BackgroundColor3 = color.Dark(children.BackgroundColor3, 0.05)
button.BackgroundTransparency = api.Category and 0 or 1
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Visible = optionsettings.Visible == nil or optionsettings.Visible
button.Text = ''
button.Parent = children
addTooltip(button, optionsettings.Tooltip)
local bkg = Instance.new('Frame')
bkg.Size = UDim2.new(1, -10, 0, 18)
bkg.Position = UDim2.fromOffset(5, 4)
bkg.BackgroundColor3 = color.Light(uipallet.Main, 0.1)
bkg.BorderSizePixel = 0
bkg.Parent = button
local label = Instance.new('TextLabel')
label.Size = UDim2.new(1, -4, 1, -4)
label.Position = UDim2.fromOffset(2, 2)
label.BackgroundTransparency = 1
label.Text = optionsettings.Name
label.TextColor3 = uipallet.Text
label.TextSize = 14
label.FontFace = uipallet.Font
label.Parent = bkg
optionsettings.Function = optionsettings.Function or function() end

button.MouseButton1Click:Connect(optionsettings.Function)