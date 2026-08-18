local divider = Instance.new('Frame')
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
divider.BorderSizePixel = 0
divider.Parent = children

if props and props.Text then
	local label = Instance.new('TextLabel')
	label.Size = UDim2.fromOffset(218, 27)
	label.BackgroundTransparency = 1
	label.Text = '          '..props.Text:upper()
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = color.Dark(uipallet.Text, 0.43)
	label.TextSize = 9
	label.FontFace = uipallet.Font
	label.Parent = children
	divider.BackgroundTransparency = 1
	--divider.Position = UDim2.fromOffset(0, 26)
	divider.Parent = label
end