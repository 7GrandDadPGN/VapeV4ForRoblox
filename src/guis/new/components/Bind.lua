local component = {
	Hold = props.Hold or false,
	Keys = {},
	Triggered = createSignal(),
	Type = 'Bind'
}

local bind = Instance.new('TextButton')
bind.AnchorPoint = Vector2.new(1, 0)
bind.AutoButtonColor = false
bind.BackgroundColor3 = Color3.new(1, 1, 1)
bind.BackgroundTransparency = 0.92
bind.BorderSizePixel = 0
bind.Name = 'Bind'
bind.Size = UDim2.fromOffset(20, 20)
bind.Visible = false
bind.Text = ''
addCorner(bind, UDim.new(0, 4))
addTooltip(bind, '', function()
	local holdText = 'Bind functionality = '..(component.Hold and 'Enable while held' or 'Toggle')
	if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		holdText = "<font color='#FF5A5A'>"..holdText.."</font>"
	end

	return 'Click to bind\nShift click to modify bind functionality\n'..holdText
end)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/bind.png')
icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
icon.Name = 'Icon'
icon.Position = UDim2.new(0.5, -5, 0, 5)
icon.Size = UDim2.fromOffset(10, 10)
icon.Parent = bind
local label = Instance.new('TextLabel')
label.BackgroundTransparency = 1
label.FontFace = uipallet.Font
label.Position = UDim2.fromOffset(-1, 0)
label.Size = UDim2.fromScale(1, 1)
label.Text = ''
label.TextColor3 = color.Dark(uipallet.Text, 0.43)
label.TextSize = 12
label.Visible = false
label.Parent = bind
local cover
local coverlabel

if props.Module then
	if props.Cover then
		cover = Instance.new('ImageLabel')
		cover.BackgroundTransparency = 1
		cover.Image = getvapeasset('newvape/assets/new/bindbkg.png')
		cover.Name = 'Cover'
		cover.ScaleType = Enum.ScaleType.Slice
		cover.SliceCenter = Rect.new(0, 0, 141, 40)
		cover.Size = UDim2.fromOffset(154, 40)
		cover.Visible = false
		cover.Parent = api.Object
		coverlabel = Instance.new('TextLabel')
		coverlabel.BackgroundTransparency = 1
		coverlabel.FontFace = uipallet.Font
		coverlabel.Name = 'Text'
		coverlabel.Size = UDim2.new(1, -10, 1, -3)
		coverlabel.Text = 'PRESS A KEY TO BIND'
		coverlabel.TextColor3 = uipallet.Text
		coverlabel.TextSize = 11
		coverlabel.Parent = cover
	end

	bind.Position = UDim2.new(1, -36, 0, 10)
	bind.Parent = api.Object
	component.Object = bind
else
	local holder = Instance.new('TextButton')
	holder.AutoButtonColor = false
	holder.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
	holder.BorderSizePixel = 0
	holder.FontFace = uipallet.Font
	holder.Size = UDim2.new(1, 0, 0, 40)
	holder.Text = '          '..props.Name
	holder.TextColor3 = color.Dark(uipallet.Text, 0.16)
	holder.TextSize = 14
	holder.TextXAlignment = Enum.TextXAlignment.Left
	holder.Visible = props.Visible == nil or props.Visible
	holder.Parent = children
	addTooltip(holder, props.Tooltip)
	bind.Position = UDim2.new(1, -10, 0, 10)
	bind.Visible = true
	bind.Parent = holder
	component.Object = holder
end

function component:CreateMobileButton(position)
	self:DestroyMobileButton()

	local isHeld = false
	local button = Instance.new('TextButton')
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundColor3 = api.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	button.BackgroundTransparency = 0.5
	button.Font = Enum.Font.Gotham
	button.Position = UDim2.fromOffset(position.X, position.Y)
	button.Size = UDim2.fromOffset(40, 40)
	button.Text = api.Name or 'Button'
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Parent = gui
	local constraint = Instance.new('UITextSizeConstraint')
	constraint.MaxTextSize = 16
	constraint.Parent = button
	addCorner(button, UDim.new(1, 0))

	button.MouseButton1Down:Connect(function()
		isHeld = true

		local holdtime, holdPos = os.clock(), inputService:GetMouseLocation()
		repeat
			isHeld = (inputService:GetMouseLocation() - holdPos).Magnitude < 6

			task.wait()
		until (os.clock() - holdtime) > 1 or not isHeld

		if isHeld then
			self:DestroyMobileButton()
		end
	end)

	button.MouseButton1Up:Connect(function()
		isHeld = false
	end)

	button.MouseButton1Click:Connect(function()
		self.Triggered:Fire(true)
		button.BackgroundColor3 = api.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	end)

	self.Mobile = button
end

function component:Destroy()
	bind:Destroy()
	bind:ClearAllChildren()

	if self.Object then
		self.Object:Destroy()
		self.Object:ClearAllChildren()
	end

	if self.Mobile then
		self.Mobile:Destroy()
		self.Mobile = nil
	end

	local index = table.find(vape.ActiveBinds, self)
	if index then
		table.remove(vape.ActiveBinds, index)
	end
end

function component:DestroyMobileButton()
	if self.Mobile then
		self.Mobile:Destroy()
		self.Mobile = nil
	end
end

function component:Load(data)
	self.Hold = data.Hold
	self:SetBind(data.Keys)

	if data.Mobile then
		self:CreateMobileButton(Vector2.new(data.Mobile.X, data.Mobile.Y))
	end
end

function component:Save(data)
	data[props and props.Name or 'Bind'] = {
		Keys = self.Keys,
		Mobile = self.Mobile and {
			X = self.Mobile.Position.X.Offset,
			Y = self.Mobile.Position.Y.Offset
		},
		Hold = self.Hold
	}
end

function component:SetBind(keys, mouse)
	if props and props.NoRemove and #keys <= 0 then
		keys = props.Default
	end

	self.Binding = nil
	self.Keys = table.clone(keys)

	if mouse then
		icon.Image = getvapeasset('newvape/assets/new/edit.png')

		if cover then
			coverlabel.Text = #keys <= 0 and 'BIND REMOVED' or 'BOUND TO'
			cover.Size = UDim2.fromOffset(getfontbounds(coverlabel.Text, coverlabel.TextSize, coverlabel.FontFace).X + 20, 40)

			task.delay(1, function()
				cover.Visible = false
			end)
		end
	end

	if #keys <= 0 then
		label.Visible = false
		icon.Visible = true
		bind.Size = UDim2.fromOffset(20, 20)

		local index = table.find(vape.ActiveBinds, component)
		if index then
			table.remove(vape.ActiveBinds, index)
		end
	else
		bind.Visible = true
		label.Visible = true
		icon.Visible = false
		label.Text = table.concat(keys, ' + '):upper()
		bind.Size = UDim2.fromOffset(math.max(getfontbounds(label.Text, label.TextSize, label.FontFace).X + 10, 20), 20)

		if not table.find(vape.ActiveBinds, component) then
			table.insert(vape.ActiveBinds, component)
		end
	end
end

function component:SetColor(newColor)
	icon.ImageColor3 = newColor
	label.TextColor3 = newColor
end

function component:SetParent(parent)
	bind.Parent = parent

	if cover then
		cover.Parent = parent
	end
end

function component:SetVisible(visible)
	bind.Visible = #self.Keys > 0 or visible
end

bind.MouseEnter:Connect(function()
	label.Visible = false
	icon.Visible = not label.Visible
	icon.Image = getvapeasset(component.Binding and 'newvape/assets/new/close.png' or 'newvape/assets/new/edit.png')

	if not props.Cover or not api.Enabled then
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.16)
	end
end)

bind.MouseLeave:Connect(function()
	label.Visible = #component.Keys > 0
	icon.Visible = not label.Visible
	icon.Image = getvapeasset(component.Binding and 'newvape/assets/new/close.png' or 'newvape/assets/new/bind.png')

	if not props.Cover or not api.Enabled then
		icon.ImageColor3 = color.Dark(uipallet.Text, 0.43)
	end
end)

bind.MouseButton1Click:Connect(function()
	if vape.Binding then
		if vape.Binding == component then
			component:SetBind({}, true)
			vape.Binding = nil
		end

		return
	end

	if props.Module and inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		component.Hold = not component.Hold
		if vape.CurrentTooltip then
			vape.CurrentTooltip()
		end

		return
	end

	if cover then
		coverlabel.Text = 'PRESS A KEY TO BIND'
		cover.Size = UDim2.fromOffset(getfontbounds(coverlabel.Text, coverlabel.TextSize, coverlabel.FontFace).X + 20, 40)
		cover.Visible = true
	end

	component.Binding = true
	icon.Image = getvapeasset('newvape/assets/new/close.png')
	vape.Binding = component
end)

if props.Module then
	api.Bind = component
else
	if props.Default then
		component:SetBind(props.Default)
	end

	api.Options[props.Name] = component
end

return component