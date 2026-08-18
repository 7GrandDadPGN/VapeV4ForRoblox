local component = {
	Enabled = false,
	Type = 'TargetsButton'
}

local targetsbutton = Instance.new('TextButton')
targetsbutton.AutoButtonColor = false
targetsbutton.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
targetsbutton.Position = props.Position
targetsbutton.Size = UDim2.fromOffset(98, 31)
targetsbutton.Text = ''
targetsbutton.Visible = props.Visible == nil or props.Visible
targetsbutton.Parent = children
component.Object = targetsbutton
addCorner(targetsbutton)
addTooltip(targetsbutton, props.Tooltip)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = uipallet.Main
holder.Position = UDim2.fromOffset(1, 1)
holder.Size = UDim2.new(1, -2, 1, -2)
holder.Parent = targetsbutton
addCorner(holder)
local icon = Instance.new('ImageLabel')
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.BackgroundTransparency = 1
icon.Image = props.Icon
icon.ImageColor3 = color.Light(uipallet.Main, 0.37)
icon.Position = UDim2.fromScale(0.5, 0.5)
icon.Size = props.IconSize
icon.Parent = holder
props.Function = props.Function or function() end

function component:Toggle()
	self.Enabled = not self.Enabled

	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = self.Enabled and Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value) or uipallet.Main
	})

	tween:Tween(icon, uipallet.Tween, {
		ImageColor3 = self.Enabled and Color3.new(1, 1, 1) or color.Light(uipallet.Main, 0.37)
	})

	props.Targets:UpdateText()
	props.Function(self.Enabled)
end

targetsbutton.MouseEnter:Connect(function()
	if not component.Enabled then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value - 0.25)
		})

		tween:Tween(icon, uipallet.Tween, {
			ImageColor3 = Color3.new(1, 1, 1)
		})
	end
end)

targetsbutton.MouseLeave:Connect(function()
	if not component.Enabled then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = uipallet.Main
		})

		tween:Tween(icon, uipallet.Tween, {
			ImageColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)

targetsbutton.MouseButton1Click:Connect(function()
	component:Toggle()
end)

return component