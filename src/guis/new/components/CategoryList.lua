local component = {
	Expanded = false,
	List = {},
	ListEnabled = {},
	Objects = {},
	Options = {},
	Type = 'CategoryList'
}
props.Color = props.Color or Color3.fromRGB(5, 134, 105)

local window = Instance.new('TextButton')
window.AutoButtonColor = false
window.BackgroundColor3 = uipallet.Main
window.Name = props.Name..'CategoryList'
window.Position = UDim2.fromOffset(240, 46)
window.Size = UDim2.fromOffset(220, 45)
window.Text = ''
window.Visible = false
window.Parent = clickgui
addBlur(window)
addCorner(window)
addDragHandler(window)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = props.Icon
icon.ImageColor3 = uipallet.Text
icon.Name = 'Icon'
icon.Size = props.Size
icon.Position = props.Position or UDim2.fromOffset(12, (props.Size.X.Offset > 20 and 13 or 12))
icon.Parent = window
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Name = 'Title'
title.Size = UDim2.new(1, -(props.Size.X.Offset > 20 and 44 or 36), 0, 20)
title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 12)
title.Text = props.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window
local arrowbutton = Instance.new('TextButton')
arrowbutton.BackgroundTransparency = 1
arrowbutton.Name = 'Arrow'
arrowbutton.Position = UDim2.new(1, -40, 0, 0)
arrowbutton.Size = UDim2.fromOffset(40, 40)
arrowbutton.Text = ''
arrowbutton.Parent = window
local arrow = Instance.new('ImageLabel')
arrow.Name = 'Arrow'
arrow.Size = UDim2.fromOffset(9, 4)
arrow.Position = UDim2.fromOffset(15, 20)
arrow.BackgroundTransparency = 1
arrow.Image = getvapeasset('newvape/assets/new/downexpand.png')
arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
arrow.Rotation = 180
arrow.Parent = arrowbutton
local children = Instance.new('ScrollingFrame')
children.Name = 'Children'
children.Size = UDim2.new(1, 0, 1, -45)
children.Position = UDim2.fromOffset(0, 45)
children.BackgroundTransparency = 1
children.BorderSizePixel = 0
children.Visible = false
children.ScrollBarThickness = 2
children.ScrollBarImageTransparency = 0.75
children.CanvasSize = UDim2.new()
children.Parent = window
local childrentwo = Instance.new('Frame')
childrentwo.BackgroundTransparency = 1
childrentwo.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
childrentwo.Visible = false
childrentwo.Parent = children
local settings = Instance.new('ImageButton')
settings.AutoButtonColor = false
settings.BackgroundTransparency = 1
settings.Image = getvapeasset('newvape/assets/new/settings.png')
settings.ImageColor3 = color.Dark(uipallet.Text, 0.43)
settings.Name = 'Settings'
settings.Position = UDim2.new(1, -56, 0, 15)
settings.Size = UDim2.fromOffset(14, 14)
settings.Parent = window
local divider = Instance.new('Frame')
divider.BackgroundColor3 = Color3.new(1, 1, 1)
divider.BackgroundTransparency = 0.928
divider.BorderSizePixel = 0
divider.Name = 'Divider'
divider.Position = UDim2.fromOffset(0, 41)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Visible = false
divider.Parent = window
local stroke = Instance.new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(85, 85, 85)
stroke.Transparency = 0.8
stroke.Parent = window
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.Padding = UDim.new(0, 4)
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children
local windowlisttwo = Instance.new('UIListLayout')
windowlisttwo.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlisttwo.SortOrder = Enum.SortOrder.LayoutOrder
windowlisttwo.Parent = childrentwo
local addbkg = Instance.new('Frame')
addbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
addbkg.Position = UDim2.fromOffset(10, 45)
addbkg.Size = UDim2.fromOffset(200, 31)
addbkg.Parent = children
addCorner(addbkg)
local addbox = addbkg:Clone()
addbox.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
addbox.Position = UDim2.fromOffset(1, 1)
addbox.Size = UDim2.new(1, -2, 1, -2)
addbox.Parent = addbkg
local addvalue = Instance.new('TextBox')
addvalue.BackgroundTransparency = 1
addvalue.ClearTextOnFocus = false
addvalue.FontFace = uipallet.Font
addvalue.PlaceholderText = props.Placeholder or 'Add entry...'
addvalue.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
addvalue.Position = UDim2.fromOffset(10, 0)
addvalue.Size = UDim2.new(1, -35, 1, 0)
addvalue.Text = ''
addvalue.TextColor3 = Color3.new(1, 1, 1)
addvalue.TextSize = 13
addvalue.TextXAlignment = Enum.TextXAlignment.Left
addvalue.Parent = addbkg
local addbutton = Instance.new('ImageButton')
addbutton.BackgroundTransparency = 1
addbutton.Image = getvapeasset('newvape/assets/new/add.png')
addbutton.ImageColor3 = props.Color
addbutton.ImageTransparency = 0.3
addbutton.Position = UDim2.new(1, -26, 0, 8)
addbutton.Size = UDim2.fromOffset(16, 16)
addbutton.Parent = addbkg
local cursedpadding = Instance.new('Frame')
cursedpadding.BackgroundTransparency = 1
cursedpadding.Size = UDim2.fromOffset()
cursedpadding.Parent = children
props.Function = props.Function or function() end

function component:CreateProfile(value, data)
	local profile = {
		Name = value
	}

	profile.Bind = components.Bind({
		Module = true,
		Cover = true
	}, nil, profile)
	profile.Bind.Object.Position = UDim2.new(1, -30, 0, 7)
	profile.Bind.Triggered:Connect(function(isPressed)
		if isPressed and vape.Profile ~= value then
			vape:Save(value)
			vape:Load(true)
			self:ChangeValue()
		end
	end)

	if data then
		profile.Bind:Load(data)
	end

	table.insert(self.List, profile)
end

function component:ChangeValue(value, skipGUI)
	if value then
		if props.Profiles then
			local index, profile = self:GetValue(value)
			if index then
				if value ~= 'default' then
					profile.Bind:Destroy()
					table.remove(self.List, index)

					if isfile('newvape/profiles/'..value..vape.Place..'.txt') and delfile then
						delfile('newvape/profiles/'..value..vape.Place..'.txt')
					end
				end
			else
				self:CreateProfile(value)
			end
		else
			local index = table.find(self.List, value)
			if index then
				table.remove(self.List, index)

				index = table.find(self.ListEnabled, value)
				if index then
					table.remove(self.ListEnabled, index)
				end
			else
				table.insert(self.List, value)
				table.insert(self.ListEnabled, value)
			end
		end
	end

	props.Function()
	for _, obj in self.Objects do
		obj:Destroy()
	end
	table.clear(self.Objects)
	self.Selected = nil

	if vape.ThreadFix then
		setthreadidentity(8)
	end

	for _, name in self.List do
		if props.Profiles then
			local obj = Instance.new('TextButton')
			obj.Name = name.Name
			obj.Size = UDim2.fromOffset(200, 32)
			obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			obj.AutoButtonColor = false
			obj.Text = ''
			obj.Parent = children
			addCorner(obj)
			local stroke = Instance.new('UIStroke')
			stroke.Color = color.Light(uipallet.Main, 0.1)
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Enabled = false
			stroke.Parent = obj
			local label = Instance.new('TextLabel')
			label.Name = 'Title'
			label.Size = UDim2.new(1, -10, 1, 0)
			label.Position = UDim2.fromOffset(10, 0)
			label.BackgroundTransparency = 1
			label.Text = name.Name
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextColor3 = color.Dark(uipallet.Text, 0.4)
			label.TextSize = 15
			label.FontFace = uipallet.Font
			label.Parent = obj
			local dotsbutton = Instance.new('TextButton')
			dotsbutton.BackgroundTransparency = 1
			dotsbutton.Name = 'Dots'
			dotsbutton.Position = UDim2.new(1, -25, 0, 0)
			dotsbutton.Size = UDim2.fromOffset(25, 32)
			dotsbutton.Text = ''
			dotsbutton.Parent = obj
			local dots = Instance.new('ImageLabel')
			dots.BackgroundTransparency = 1
			dots.Image = getvapeasset('newvape/assets/new/settingdots.png')
			dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
			dots.Name = 'Dots'
			dots.Position = UDim2.fromOffset(11, 9)
			dots.Size = UDim2.fromOffset(3, 16)
			dots.Parent = dotsbutton
			name.Bind:SetParent(obj)
			name.Enabled = name.Name == vape.Profile

			dotsbutton.MouseButton1Click:Connect(function()
				if not name.Enabled then
					component:ChangeValue(name.Name)
				end
			end)

			dotsbutton.MouseEnter:Connect(function()
				if not name.Enabled then
					dots.ImageColor3 = uipallet.Text
				end
			end)

			dotsbutton.MouseLeave:Connect(function()
				if not name.Enabled then
					dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
				end
			end)


			obj.MouseButton1Click:Connect(function()
				vape:Save(name.Name)
				vape:Load(true)
				self:ChangeValue()
			end)

			obj.MouseEnter:Connect(function()
				name.Bind:SetVisible(true)
			end)

			obj.MouseLeave:Connect(function()
				name.Bind:SetVisible(false)
			end)

			if name.Enabled then
				self.Selected = obj
			else
				name.Bind:SetColor(color.Dark(uipallet.Text, 0.43))
			end

			table.insert(self.Objects, {
				Destroy = function()
					name.Bind:SetParent(nil)
					obj:Destroy()
				end
			})
		else
			local isEnabled = table.find(self.ListEnabled, name)
			local obj = Instance.new('TextButton')
			obj.Name = name
			obj.Size = UDim2.fromOffset(200, 31)
			obj.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
			obj.AutoButtonColor = false
			obj.Text = ''
			obj.Parent = children
			addCorner(obj)
			local bkg = Instance.new('Frame')
			bkg.BackgroundColor3 = uipallet.Main
			bkg.Position = UDim2.fromOffset(1, 1)
			bkg.Size = UDim2.new(1, -2, 1, -2)
			bkg.Visible = false
			bkg.Parent = obj
			addCorner(bkg)
			local dot = Instance.new('Frame')
			dot.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.37)
			dot.Position = UDim2.fromOffset(10, 12)
			dot.Size = UDim2.fromOffset(10, 11)
			dot.Parent = obj
			addCorner(dot, UDim.new(1, 0))
			local dotin = dot:Clone()
			dotin.BackgroundColor3 = isEnabled and props.Color or color.Light(uipallet.Main, 0.02)
			dotin.Position = UDim2.fromOffset(1, 1)
			dotin.Size = UDim2.fromOffset(8, 9)
			dotin.Parent = dot
			local label = Instance.new('TextLabel')
			label.BackgroundTransparency = 1
			label.FontFace = uipallet.Font
			label.Position = UDim2.fromOffset(30, 0)
			label.Size = UDim2.new(1, -30, 1, 0)
			label.Text = name
			label.TextColor3 = color.Dark(uipallet.Text, 0.16)
			label.TextSize = 15
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = obj
			local close = Instance.new('ImageButton')
			close.AutoButtonColor = false
			close.BackgroundColor3 = Color3.new(1, 1, 1)
			close.BackgroundTransparency = 1
			close.Image = getvapeasset('newvape/assets/new/closetiny.png')
			close.ImageColor3 = color.Light(uipallet.Text, 0.2)
			close.ImageTransparency = 0.5
			close.Position = UDim2.new(1, -27, 0, 8)
			close.Size = UDim2.fromOffset(18, 17)
			close.Parent = obj
			addCorner(close, UDim.new(1, 0))

			close.MouseEnter:Connect(function()
				close.ImageTransparency = 0.3
				tween:Tween(close, uipallet.Tween, {
					BackgroundTransparency = 0.6
				})
			end)

			close.MouseLeave:Connect(function()
				close.ImageTransparency = 0.5
				tween:Tween(close, uipallet.Tween, {
					BackgroundTransparency = 1
				})
			end)

			close.MouseButton1Click:Connect(function()
				component:ChangeValue(name)
			end)

			obj.MouseEnter:Connect(function()
				bkg.Visible = true
			end)

			obj.MouseLeave:Connect(function()
				bkg.Visible = false
			end)

			obj.MouseButton1Click:Connect(function()
				local index = table.find(self.ListEnabled, name)
				if index then
					table.remove(self.ListEnabled, index)
					dot.BackgroundColor3 = color.Light(uipallet.Main, 0.37)
					dotin.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				else
					table.insert(self.ListEnabled, name)
					dot.BackgroundColor3 = props.Color
					dotin.BackgroundColor3 = props.Color
				end

				props.Function()
			end)

			table.insert(self.Objects, obj)
		end
	end

	if not skipGUI then
		vape:UpdateGUI()
	end
end

function component:Color(hue, sat, val, isRainbow)
	for _, component in self.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end

	addbutton.ImageColor3 = isRainbow and Color3.fromHSV(vape:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)

	if self.Selected then
		self.Selected.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color(hue % 1)) or Color3.fromHSV(hue, sat, val)
		self.Selected.Title.TextColor3 = vape.GUIColor.Rainbow and Color3.new(0.19, 0.19, 0.19) or vape:TextColor(hue, sat, val)
		self.Selected.Dots.Dots.ImageColor3 = self.Selected.Title.TextColor3
		self.Selected.Bind.Icon.ImageColor3 = self.Selected.Title.TextColor3
		self.Selected.Bind.TextLabel.TextColor3 = self.Selected.Title.TextColor3
	end
end

function component:Expand()
	self.Expanded = not self.Expanded
	children.Visible = self.Expanded
	arrow.Rotation = self.Expanded and 0 or 180
	window.Size = UDim2.fromOffset(220, self.Expanded and math.min(51 + windowlist.AbsoluteContentSize.Y / scale.Scale, 611) or 45)
	divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
end

function component:GetValue(name)
	for index, profile in self.List do
		if profile.Name == name then
			return index, profile
		end
	end
end

function component:Load(data)
	vape:LoadOptions(self, data.Options)

	if data.Enabled then
		self.Button:Toggle()
	end

	if data.Expanded then
		self:Expand()
	end

	if props.Profiles then
		for _, profile in data.List do
			self:CreateProfile(profile.Name, profile.Bind)
		end

		self:ChangeValue(nil, true)
	else
		if data.List and (#self.List > 0 or #data.List > 0) then
			self.List = data.List or {}
			self.ListEnabled = data.ListEnabled or {}
			self:ChangeValue(nil, true)
		end
	end

	if data.Position then
		window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
	end
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Button.Enabled,
		Expanded = self.Expanded,
		List = self.List,
		ListEnabled = self.ListEnabled,
		Options = vape:SaveOptions(self),
		Position = {
			X = window.Position.X.Offset,
			Y = window.Position.Y.Offset
		}
	}

	if props.Profiles then
		local newList = {}

		for _, profile in self.List do
			local entry = {
				Name = profile.Name
			}

			profile.Bind:Save(entry)
			table.insert(newList, entry)
		end

		data[props.Name].List = newList
	end
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, childrentwo, component)
	end
end

addbutton.MouseEnter:Connect(function()
	addbutton.ImageTransparency = 0
end)

addbutton.MouseLeave:Connect(function()
	addbutton.ImageTransparency = 0.3
end)

addbutton.MouseButton1Click:Connect(function()
	if not table.find(component.List, addvalue.Text) then
		component:ChangeValue(addvalue.Text)
		addvalue.Text = ''
	end
end)

arrowbutton.MouseEnter:Connect(function()
	arrow.ImageColor3 = Color3.fromRGB(220, 220, 220)
end)

arrowbutton.MouseLeave:Connect(function()
	arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
end)

arrowbutton.MouseButton1Click:Connect(function()
	component:Expand()
end)

arrowbutton.MouseButton2Click:Connect(function()
	component:Expand()
end)

addvalue.FocusLost:Connect(function(enter)
	if enter and not table.find(component.List, addvalue.Text) then
		component:ChangeValue(addvalue.Text)
		addvalue.Text = ''
	end
end)

addvalue.MouseEnter:Connect(function()
	tween:Tween(addbkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.14)
	})
end)

addvalue.MouseLeave:Connect(function()
	tween:Tween(addbkg, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.02)
	})
end)

children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
	divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
end)

settings.MouseEnter:Connect(function()
	settings.ImageColor3 = uipallet.Text
end)

settings.MouseLeave:Connect(function()
	settings.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

settings.MouseButton1Click:Connect(function()
	childrentwo.Visible = not childrentwo.Visible
end)

window.InputBegan:Connect(function(input)
	if input.Position.Y < window.AbsolutePosition.Y + 41 and input.UserInputType == Enum.UserInputType.MouseButton2 then
		component:Expand()
	end
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
	if component.Expanded then
		window.Size = UDim2.fromOffset(220, math.min(51 + windowlist.AbsoluteContentSize.Y / scale.Scale, 611))
	end
end)

windowlisttwo:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	childrentwo.Size = UDim2.fromOffset(220, windowlisttwo.AbsoluteContentSize.Y / scale.Scale)
end)

component.Button = vape.Categories.Main:CreateGUIButton({
	Name = props.Name,
	Icon = props.CategoryIcon,
	Size = props.CategorySize,
	Window = window
})

component.Object = window
vape.Categories[props.Name] = component

return component