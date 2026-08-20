vape:Remove(props.Name)
local component = {
	Category = api.Name,
	Enabled = false,
	ExtraText = props.ExtraText,
	Index = getTableSize(vape.Modules),
	Name = props.Name,
	Options = {},
	Visible = true
}

local isHover = false
local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = uipallet.Main
button.BorderSizePixel = 0
button.FontFace = uipallet.Font
button.Name = props.Name
button.Size = UDim2.fromOffset(220, 40)
button.Text = string.rep(' ', 12)..props.Name
button.TextColor3 = color.Dark(uipallet.Text, 0.16)
button.TextSize = 14
button.TextXAlignment = Enum.TextXAlignment.Left
button.Parent = children
component.Object = button
addTooltip(button, props.Tooltip)
local gradient = Instance.new('UIGradient')
gradient.Enabled = false
gradient.Rotation = 90
gradient.Parent = button
local modulechildren = Instance.new('Frame')
modulechildren.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
modulechildren.BorderSizePixel = 0
modulechildren.Name = props.Name..'Children'
modulechildren.Size = UDim2.new(1, 0, 0, 0)
modulechildren.Visible = false
modulechildren.Parent = children
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = modulechildren
local dotsbutton = Instance.new('TextButton')
dotsbutton.BackgroundTransparency = 1
dotsbutton.Name = 'Dots'
dotsbutton.Position = UDim2.new(1, -25, 0, 0)
dotsbutton.Size = UDim2.fromOffset(25, 40)
dotsbutton.Text = ''
dotsbutton.Parent = button
local dots = Instance.new('ImageLabel')
dots.BackgroundTransparency = 1
dots.Image = getvapeasset('newvape/assets/new/settingdots.png')
dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
dots.Name = 'Dots'
dots.Position = UDim2.fromOffset(4, 12)
dots.Size = UDim2.fromOffset(3, 16)
dots.Parent = dotsbutton
local divider = Instance.new('Frame')
divider.BackgroundColor3 = Color3.new(0.19, 0.19, 0.19)
divider.BackgroundTransparency = 0.52
divider.BorderSizePixel = 0
divider.Name = 'Divider'
divider.Position = UDim2.new(0, 0, 1, -1)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Visible = false
divider.Parent = button
local edit = Instance.new('TextButton')
edit.AutoButtonColor = false
edit.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
edit.BorderSizePixel = 0
edit.Size = UDim2.fromOffset(40, 40)
edit.Text = ''
edit.Visible = false
edit.Parent = button
local editbox = Instance.new('Frame')
editbox.BorderSizePixel = 0
editbox.Position = UDim2.fromOffset(16, 16)
editbox.Size = UDim2.fromOffset(8, 8)
editbox.Parent = edit
local editborder = Instance.new('UIStroke')
editborder.BorderOffset = UDim.new(0, 1)
editborder.LineJoinMode = Enum.LineJoinMode.Miter
editborder.Parent = editbox
props.Function = props.Function or function() end
component.Edit = edit
component.Children = modulechildren
addMaid(component)

function component:Color(hue, sat, val, isRainbow)
	if self.Enabled then
		button.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
		button.TextColor3 = vape.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or vape:TextColor(hue, sat, val)
		button.UIGradient.Enabled = isRainbow and vape.RainbowMode.Value == 'Gradient'

		if button.UIGradient.Enabled then
			button.BackgroundColor3 = Color3.new(1, 1, 1)
			button.UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1))),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(vape:Color((hue - ((self.Index + 1) * 0.025)) % 1)))
			})
		end

		self.Bind:SetColor(self.Object.TextColor3)
		dots.ImageColor3 = self.Object.TextColor3
	end

	if self.Visible then
		editbox.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)
		editborder.Color = editbox.BackgroundColor3
	end

	for _, component in self.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

function component:Destroy()
	self.Bind:Destroy()

	for _, option in self.Options do
		if option.Type == 'Bind' then
			option:Destroy()
		end
	end
end

function component:Load(data)
	vape:LoadOptions(self, data.Options)
	self.Bind:Load(data.Bind)

	if self.Enabled ~= (data.Enabled and not self.Bind.Hold) then
		self:Toggle(true)
	end

	if self.Visible ~= data.Visible then
		self:SetVisible(data.Visible, true)
	end
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Enabled,
		Options = vape:SaveOptions(self),
		Visible = self.Visible
	}

	self.Bind:Save(data[props.Name])
end

function component:SetVisible(isVisible, isLoad)
	self.Visible = isVisible
	editbox.BackgroundTransparency = isVisible and 0 or 1
	editborder.Color = isVisible and editbox.BackgroundColor3 or color.Light(uipallet.Main, 0.37)

	if isLoad and not vape.EditGUI then
		button.Visible = isVisible
	end
end

function component:Toggle(multiple)
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	self.Enabled = not self.Enabled
	divider.Visible = self.Enabled
	gradient.Enabled = self.Enabled
	button.TextColor3 = (isHover or modulechildren.Visible) and uipallet.Text or color.Dark(uipallet.Text, 0.16)
	button.BackgroundColor3 = (isHover or modulechildren.Visible) and color.Light(uipallet.Main, 0.02) or uipallet.Main
	dots.ImageColor3 = self.Enabled and Color3.fromRGB(50, 50, 50) or color.Light(uipallet.Main, 0.37)
	component.Bind:SetColor(color.Dark(uipallet.Text, 0.43))

	if not self.Enabled then
		for _, v in self.Connections do
			v:Disconnect()
		end
		table.clear(self.Connections)
	end

	if multiple then
		if not vape.TextGUIThread then
			vape.TextGUIThread = task.defer(function()
				if vape.Loaded ~= nil then
					vape:UpdateTextGUI()
				end

				vape.TextGUIThread = nil
			end)
		end
	else
		vape:UpdateTextGUI()
	end

	task.spawn(props.Function, self.Enabled)
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, modulechildren, component)
	end
end

button.MouseEnter:Connect(function()
	isHover = true
	if not component.Enabled and not modulechildren.Visible then
		button.TextColor3 = uipallet.Text
		button.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	end

	component.Bind:SetVisible(isHover or modulechildren.Visible)
end)

button.MouseLeave:Connect(function()
	isHover = false
	if not component.Enabled and not modulechildren.Visible then
		button.TextColor3 = color.Dark(uipallet.Text, 0.16)
		button.BackgroundColor3 = uipallet.Main
	end

	component.Bind:SetVisible(isHover or modulechildren.Visible)
end)

button.MouseButton1Click:Connect(function()
	if vape.EditGUI then
		return
	end

	component:Toggle()
end)

button.MouseButton2Click:Connect(function()
	modulechildren.Visible = not modulechildren.Visible
end)

dotsbutton.MouseButton1Click:Connect(function()
	modulechildren.Visible = not modulechildren.Visible
end)

dotsbutton.MouseButton2Click:Connect(function()
	modulechildren.Visible = not modulechildren.Visible
end)

dotsbutton.MouseEnter:Connect(function()
	if not component.Enabled then
		dots.ImageColor3 = uipallet.Text
	end
end)

dotsbutton.MouseLeave:Connect(function()
	if not component.Enabled then
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
	end
end)

edit.MouseButton1Click:Connect(function()
	component:SetVisible(not component.Visible)
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	modulechildren.Size = UDim2.new(1, 0, 0, windowlist.AbsoluteContentSize.Y / scale.Scale)
end)

local bind = component:CreateBind({
	Module = true,
	Cover = true
})

bind.Triggered:Connect(function(isDown)
	if bind.Hold then
		if component.Enabled ~= isDown then
			if vape.ToggleNotifications.Enabled then
				vape:CreateNotification(props.Name, (not component.Enabled and "<font color='#00AA00'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>"), 1.5)
			end

			component:Toggle(true)
		end
	else
		if vape.ToggleNotifications.Enabled then
			vape:CreateNotification(props.Name, (not component.Enabled and "<font color='#00AA00'>Enabled</font>" or "<font color='#FF5A5A'>Disabled</font>"), 1.5)
		end

		component:Toggle(true)
	end
end)

if inputService.TouchEnabled then
	local isHeld = false

	button.MouseButton1Down:Connect(function()
		isHeld = true
		local holdtime, holdPos = os.clock(), inputService:GetMouseLocation()
		repeat
			isHeld = (inputService:GetMouseLocation() - holdPos).Magnitude < 3
			task.wait()
		until (os.clock() - holdtime) > 1 or not isHeld or not clickgui.Visible

		if isHeld and clickgui.Visible then
			if vape.ThreadFix then
				setthreadidentity(8)
			end

			clickgui.Visible = false
			tooltip.Visible = false
			vape:BlurCheck()
			for _, module in vape.Modules do
				if module.Bind.Mobile then
					module.Bind.Mobile.Visible = true
				end
			end

			local connection
			connection = inputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					if vape.ThreadFix then
						setthreadidentity(8)
					end

					bind:CreateMobileButton(input.Position + Vector3.new(0, guiService:GetGuiInset().Y, 0))
					clickgui.Visible = true
					vape:BlurCheck()

					for _, module in vape.Modules do
						if module.Bind.Mobile then
							module.Bind.Mobile.Visible = false
						end
					end

					connection:Disconnect()
				end
			end)
		end
	end)

	button.MouseButton1Up:Connect(function()
		isHeld = false
	end)
end

vape.Modules[props.Name] = component
vape:SortCategories()

return component