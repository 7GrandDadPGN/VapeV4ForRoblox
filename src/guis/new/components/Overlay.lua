local window
local component
component = {
	Button = vape.Overlays:CreateImageToggle({
		Name = props.Name,
		Function = function(callback)
			window.Visible = callback and (clickgui.Visible or component.Pinned)

			if not callback then
				for _, v in component.Connections do
					v:Disconnect()
				end
				table.clear(component.Connections)
			end

			if props.Function then
				task.spawn(props.Function, callback)
			end
		end,
		Icon = props.Icon,
		Size = props.Size,
		Position = props.Position
	}),
	Expanded = false,
	Pinned = false,
	Options = {},
	Type = 'Overlay'
}

window = Instance.new('TextButton')
window.AutoButtonColor = false
window.BackgroundColor3 = uipallet.Main
window.Name = props.Name..'Overlay'
window.Position = UDim2.fromOffset(240, 46)
window.Size = UDim2.fromOffset(props.CategorySize or 220, 41)
window.Text = ''
window.Visible = false
window.Parent = scaledgui
component.Object = window
local blur = addBlur(window)
addCorner(window)
addDragHandler(window)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = props.Icon
icon.ImageColor3 = uipallet.Text
icon.Position = UDim2.fromOffset(12, (icon.Size.X.Offset > 14 and 14 or 13))
icon.Size = props.Size
icon.Parent = window
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Size = UDim2.new(1, -32, 0, 41)
title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 0)
title.Text = props.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window
local pin = Instance.new('ImageButton')
pin.Name = 'Pin'
pin.Size = UDim2.fromOffset(14, 14)
pin.Position = UDim2.new(1, -37, 0, 14)
pin.BackgroundTransparency = 1
pin.AutoButtonColor = false
pin.Image = getvapeasset('newvape/assets/new/pin.png')
pin.ImageColor3 = color.Dark(uipallet.Text, 0.43)
pin.Parent = window
local dotsbutton = Instance.new('TextButton')
dotsbutton.Name = 'Dots'
dotsbutton.Size = UDim2.fromOffset(17, 40)
dotsbutton.Position = UDim2.new(1, -17, 0, 0)
dotsbutton.BackgroundTransparency = 1
dotsbutton.Text = ''
dotsbutton.Parent = window
local dots = Instance.new('ImageLabel')
dots.BackgroundTransparency = 1
dots.Image = getvapeasset('newvape/assets/new/overlaydots.png')
dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
dots.Position = UDim2.fromOffset(5, 15)
dots.Size = UDim2.fromOffset(2, 12)
dots.Parent = dotsbutton
local customchildren = Instance.new('Frame')
customchildren.BackgroundTransparency = 1
customchildren.Position = UDim2.fromScale(0, 1)
customchildren.Size = UDim2.new(1, 0, 0, 200)
customchildren.Parent = window
local children = Instance.new('ScrollingFrame')
children.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
children.BorderSizePixel = 0
children.CanvasSize = UDim2.new()
children.Position = UDim2.fromOffset(0, 37)
children.Size = UDim2.new(1, 0, 1, -41)
children.ScrollBarThickness = 2
children.ScrollBarImageTransparency = 0.75
children.Visible = false
children.Parent = window
local stroke = Instance.new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(85, 85, 85)
stroke.Transparency = 0.8
stroke.Parent = window
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children
addMaid(component)

function component:Color(hue, sat, val, isRainbow)
	for _, component in self.Options do
		if component.Color then
			component:Color(hue, sat, val, isRainbow)
		end
	end
end

function component:Expand(visCheck)
	if visCheck and not blur.Enabled then return end

	self.Expanded = not self.Expanded
	children.Visible = self.Expanded
	dots.ImageColor3 = self.Expanded and uipallet.Text or color.Light(uipallet.Main, 0.37)

	if self.Expanded then
		window.Size = UDim2.fromOffset(window.Size.X.Offset, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
	else
		window.Size = UDim2.fromOffset(window.Size.X.Offset, 41)
	end
end

function component:Load(data)
	vape:LoadOptions(self, data.Options)

	if self.Button.Enabled ~= data.Enabled then
		self.Button:Toggle()
	end

	if self.Pinned ~= data.Pinned then
		self:Pin()
		self:Update()
	end

	if data.Position then
		window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
	end
end

function component:Pin()
	self.Pinned = not self.Pinned
	pin.ImageColor3 = self.Pinned and uipallet.Text or color.Dark(uipallet.Text, 0.43)
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Button.Enabled,
		Options = vape:SaveOptions(self),
		Pinned = self.Pinned,
		Position = {
			X = window.Position.X.Offset,
			Y = window.Position.Y.Offset
		}
	}
end

function component:Update()
	window.Visible = self.Button.Enabled and (clickgui.Visible or self.Pinned)
	if self.Expanded then
		self:Expand()
	end

	if clickgui.Visible then
		window.Size = UDim2.fromOffset(window.Size.X.Offset, 41)
		window.BackgroundTransparency = 0
		blur.Enabled = true
		stroke.Enabled = true
		icon.Visible = true
		title.Visible = true
		pin.Visible = true
		dotsbutton.Visible = true
	else
		window.Size = UDim2.fromOffset(window.Size.X.Offset, 0)
		window.BackgroundTransparency = 1
		blur.Enabled = false
		stroke.Enabled = false
		icon.Visible = false
		title.Visible = false
		pin.Visible = false
		dotsbutton.Visible = false
	end
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, children, component)
	end
end

vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
	component:Update()
end))

dotsbutton.MouseEnter:Connect(function()
	if not children.Visible then
		dots.ImageColor3 = uipallet.Text
	end
end)

dotsbutton.MouseLeave:Connect(function()
	if not children.Visible then
		dots.ImageColor3 = color.Light(uipallet.Main, 0.37)
	end
end)

dotsbutton.MouseButton1Click:Connect(function()
	component:Expand(true)
end)

dotsbutton.MouseButton2Click:Connect(function()
	component:Expand(true)
end)

pin.MouseButton1Click:Connect(function()
	component:Pin()
end)

window.MouseButton2Click:Connect(function()
	component:Expand(true)
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
	if component.Expanded then
		window.Size = UDim2.fromOffset(window.Size.X.Offset, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
	end
end)

component.Children = customchildren
vape.Categories[props.Name] = component

return component