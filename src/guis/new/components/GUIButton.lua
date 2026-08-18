local component = {
	Enabled = false,
	Index = getTableSize(api.Buttons),
	Name = props.Name
}

local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = uipallet.Main
button.BorderSizePixel = 0
button.FontFace = uipallet.Font
button.Name = props.Name
button.Size = UDim2.fromOffset(220, 40)
button.Text = (props.Icon and string.rep(' ', 39) or props.Window and string.rep(' ', 17) or string.rep(' ', 10))..props.Name
button.TextColor3 = color.Dark(uipallet.Text, 0.16)
button.TextSize = 14
button.TextXAlignment = Enum.TextXAlignment.Left
button.Parent = children
component.Object = button

local icon
if props.Icon then
	icon = Instance.new('ImageLabel')
	icon.BackgroundTransparency = 1
	icon.Image = props.Icon
	icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
	icon.Position = UDim2.fromOffset(16, 13)
	icon.Size = props.Size
	icon.Parent = button
	component.Icon = icon
end

if props.Name == 'Profiles' then
	local label = Instance.new('TextLabel')
	label.AnchorPoint = Vector2.new(1, 0)
	label.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
	label.FontFace = uipallet.Font
	label.Position = UDim2.new(1, -36, 0, 8)
	label.Size = UDim2.fromOffset(53, 24)
	label.Text = 'default'
	label.TextColor3 = color.Dark(uipallet.Text, 0.29)
	label.TextSize = 12
	label.Parent = button
	addCorner(label)
	vape.ProfileLabel = label
end

local arrow = Instance.new('ImageLabel')
arrow.BackgroundTransparency = 1
arrow.Image = getvapeasset('newvape/assets/new/expandarrow.png')
arrow.ImageColor3 = color.Light(uipallet.Main, 0.37)
arrow.Name = 'Arrow'
arrow.Position = UDim2.new(1, -20, 0, 16)
arrow.Size = UDim2.fromOffset(4, 8)
arrow.Parent = button

function component:Destroy()
	button:Destroy()
	button:ClearAllChildren()
end

function component:Toggle()
	if props.Window then
		self.Enabled = not self.Enabled
		tween:Tween(arrow, uipallet.Tween, {
			Position = UDim2.new(1, self.Enabled and -14 or -20, 0, 16)
		})

		button.TextColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or uipallet.Text
		if icon then
			icon.ImageColor3 = button.TextColor3
		end

		button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		props.Window.Visible = self.Enabled
	else
		props.Function()
	end
end

button.MouseEnter:Connect(function()
	if not component.Enabled then
		button.TextColor3 = uipallet.Text
		if buttonicon then
			buttonicon.ImageColor3 = uipallet.Text
		end

		button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	end
end)

button.MouseLeave:Connect(function()
	if not component.Enabled then
		button.TextColor3 = color.Dark(uipallet.Text, 0.16)
		if buttonicon then
			buttonicon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
		end

		button.BackgroundColor3 = uipallet.Main
	end
end)

button.MouseButton1Click:Connect(function()
	component:Toggle()
end)

api.Buttons[props.Name] = component

return component