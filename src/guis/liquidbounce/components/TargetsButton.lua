local optionapi = {Enabled = false}

local targetbutton = Instance.new('TextButton')
targetbutton.Size = UDim2.fromOffset(98, 31)
targetbutton.Position = optionsettings.Position
targetbutton.BackgroundColor3 = color.Light(uipallet.Main, 0.05)
targetbutton.AutoButtonColor = false
targetbutton.Visible = optionsettings.Visible == nil or optionsettings.Visible
targetbutton.Text = ''
targetbutton.Parent = children
addCorner(targetbutton)
--addTooltip(targetbutton, optionsettings.Tooltip)
local bkg = Instance.new('Frame')
bkg.Size = UDim2.new(1, -2, 1, -2)
bkg.Position = UDim2.fromOffset(1, 1)
bkg.BackgroundColor3 = uipallet.Main
bkg.Parent = targetbutton
addCorner(bkg)
local icon = Instance.new('ImageLabel')
icon.Size = optionsettings.IconSize
icon.Position = UDim2.fromScale(0.5, 0.5)
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.BackgroundTransparency = 1
icon.Image = optionsettings.Icon
icon.ImageColor3 = color.Light(uipallet.Main, 0.37)
icon.Parent = bkg
optionsettings.Function = optionsettings.Function or function() end
local tooltipicon

function optionapi:Toggle()
	self.Enabled = not self.Enabled
	tween:Tween(bkg, uipallet.Tween, {
		BackgroundColor3 = self.Enabled and Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value) or uipallet.Main
	})
	tween:Tween(icon, uipallet.Tween, {
		ImageColor3 = self.Enabled and Color3.new(1, 1, 1) or color.Light(uipallet.Main, 0.37)
	})
	if tooltipicon then
		tooltipicon:Destroy()
	end
	if self.Enabled then
		tooltipicon = Instance.new('ImageLabel')
		tooltipicon.Size = optionsettings.ToolSize
		tooltipicon.BackgroundTransparency = 1
		tooltipicon.Image = optionsettings.ToolIcon
		tooltipicon.ImageColor3 = uipallet.Text
		tooltipicon.Parent = optionsettings.IconParent
	end
	optionsettings.Function(self.Enabled)
end

targetbutton.MouseEnter:Connect(function()
	if not optionapi.Enabled then
		tween:Tween(bkg, uipallet.Tween, {
			BackgroundColor3 = Color3.fromHSV(mainapi.GUIColor.Hue, mainapi.GUIColor.Sat, mainapi.GUIColor.Value - 0.25)
		})
		tween:Tween(icon, uipallet.Tween, {
			ImageColor3 = Color3.new(1, 1, 1)
		})
	end
end)
targetbutton.MouseLeave:Connect(function()
	if not optionapi.Enabled then
		tween:Tween(bkg, uipallet.Tween, {
			BackgroundColor3 = uipallet.Main
		})
		tween:Tween(icon, uipallet.Tween, {
			ImageColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)
targetbutton.MouseButton1Click:Connect(function()
	optionapi:Toggle()
end)

optionapi.Object = targetbutton

return optionapi