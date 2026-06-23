local button = Instance.new('TextButton')
button.Name = optionsettings.Name..'Button'
button.Size = UDim2.new(1, 0, 0, 28)
button.BackgroundTransparency = 1
button.Text = ''
button.Visible = optionsettings.Visible == nil or optionsettings.Visible
button.Parent = children
local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -13, 1, 0)
title.Position = UDim2.fromOffset(13 + (optionsettings.Darker and 20 or 0), 0)
title.BackgroundTransparency = 1
title.Text = optionsettings.Name
title.TextColor3 = color.Dark(uipallet.Text, 0.21)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.FontFace = uipallet.Font
title.Parent = button
optionsettings.Function = optionsettings.Function or function() end

button.MouseButton1Click:Connect(function() optionsettings.Function() end)