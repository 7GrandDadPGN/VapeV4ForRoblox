local button = Instance.new('TextButton')
button.Name = optionsettings.Name..'Button'
button.Size = UDim2.new(1, 0, 0, 41)
button.BackgroundTransparency = 1
button.Visible = optionsettings.Visible == nil or optionsettings.Visible
button.Text = ''
button.Parent = children
--addTooltip(button, optionsettings.Tooltip)
local accentbar = Instance.new('Frame')
accentbar.Size = UDim2.new(0, 4, 1, 0)
accentbar.BackgroundColor3 = uipallet.Main
accentbar.BorderSizePixel = 0
accentbar.Parent = button
local bkg = Instance.new('Frame')
bkg.Size = UDim2.new(1, -22, 1, -14)
bkg.Position = UDim2.fromOffset(11, 7)
bkg.BackgroundColor3 = uipallet.Main
bkg.Parent = button
addCorner(bkg, UDim.new(0, 4))
local label = Instance.new('TextLabel')
label.Size = UDim2.new(1, -4, 1, -4)
label.Position = UDim2.fromOffset(2, 2)
label.BackgroundTransparency = 1
label.Text = optionsettings.Name
label.TextColor3 = uipallet.Text
label.TextSize = 14
label.FontFace = uipallet.FontSemiBold
label.Parent = bkg
optionsettings.Function = optionsettings.Function or function() end

button.MouseButton1Click:Connect(optionsettings.Function)