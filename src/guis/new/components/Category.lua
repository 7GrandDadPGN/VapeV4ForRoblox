local component = {
	Expanded = false,
	Name = props.Name,
	Type = 'Category'
}

local window = Instance.new('TextButton')
window.AutoButtonColor = false
window.BackgroundColor3 = uipallet.Main
window.Name = props.Name..'Category'
window.Position = UDim2.fromOffset(236, 60)
window.Size = UDim2.fromOffset(220, 41)
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
icon.Position = UDim2.fromOffset(12, (icon.Size.X.Offset > 20 and 14 or 13))
icon.Size = props.Size
icon.Parent = window
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Size = UDim2.new(1, -(props.Size.X.Offset > 18 and 40 or 33), 0, 41)
title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 0)
title.Text = props.Name
title.TextColor3 = uipallet.Text
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window
local pencilbutton = Instance.new('TextButton')
pencilbutton.BackgroundTransparency = 1
pencilbutton.Position = UDim2.new(1, -49, 0, 0)
pencilbutton.Size = UDim2.fromOffset(20, 40)
pencilbutton.Text = ''
pencilbutton.Visible = false
pencilbutton.Parent = window
addTooltip(pencilbutton, 'Edit hidden modules')
local pencil = Instance.new('ImageLabel')
pencil.BackgroundTransparency = 1
pencil.Image = getvapeasset('newvape/assets/new/editlarge.png')
pencil.ImageColor3 = Color3.fromRGB(140, 140, 140)
pencil.Size = UDim2.fromOffset(12, 12)
pencil.Position = UDim2.fromOffset(4, 14)
pencil.Parent = pencilbutton
local arrowbutton = Instance.new('TextButton')
arrowbutton.BackgroundTransparency = 1
arrowbutton.Position = UDim2.new(1, -29, 0, 0)
arrowbutton.Size = UDim2.fromOffset(27, 40)
arrowbutton.Text = ''
arrowbutton.Parent = window
local arrow = Instance.new('ImageLabel')
arrow.BackgroundTransparency = 1
arrow.Image = getvapeasset('newvape/assets/new/downexpand.png')
arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
arrow.Size = UDim2.fromOffset(9, 4)
arrow.Position = UDim2.fromOffset(9, 18)
arrow.Rotation = 180
arrow.Parent = arrowbutton
local done = Instance.new('TextButton')
done.BackgroundTransparency = 1
done.FontFace = uipallet.Font
done.Position = UDim2.new(1, -73, 0, 0)
done.Size = UDim2.fromOffset(42, 40)
done.Text = 'DONE'
done.TextColor3 = Color3.fromRGB(140, 140, 140)
done.TextSize = 12
done.Visible = false
done.Parent = window
component.Done = done
local children = Instance.new('ScrollingFrame')
children.BackgroundTransparency = 1
children.BorderSizePixel = 0
children.CanvasSize = UDim2.new()
children.Name = 'Children'
children.Position = UDim2.fromOffset(0, 37)
children.ScrollBarThickness = 2
children.ScrollBarImageTransparency = 0.75
children.Size = UDim2.new(1, 0, 1, -41)
children.Visible = false
children.Parent = window
local divider = Instance.new('Frame')
divider.BackgroundColor3 = Color3.new(1, 1, 1)
divider.BackgroundTransparency = 0.928
divider.BorderSizePixel = 0
divider.Position = UDim2.fromOffset(0, 37)
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
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children

function component:Color(hue, sat, val, isRainbow) end

function component:Expand()
	self.Expanded = not self.Expanded
	children.Visible = self.Expanded
	arrow.Rotation = self.Expanded and 0 or 180
	window.Size = UDim2.fromOffset(220, self.Expanded and math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601) or 41)
	divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
end

function component:Load(data)
	if data.Enabled then
		self.Button:Toggle()
	end

	if data.Expanded then
		self:Expand()
	end

	if data.Position then
		window.Position = UDim2.fromOffset(data.Position.X, data.Position.Y)
	end
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Button.Enabled,
		Expanded = self.Expanded,
		Position = {
			X = window.Position.X.Offset,
			Y = window.Position.Y.Offset
		}
	}
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, children, component)
	end
end

arrowbutton.MouseButton1Click:Connect(function()
	component:Expand()
end)

arrowbutton.MouseButton2Click:Connect(function()
	component:Expand()
end)

arrowbutton.MouseEnter:Connect(function()
	arrow.ImageColor3 = Color3.fromRGB(220, 220, 220)
end)

arrowbutton.MouseLeave:Connect(function()
	arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
end)

done.MouseButton1Click:Connect(function()
	vape.EditGUI = false
	pencilbutton.Visible = true

	for _, category in vape.Categories do
		if category.Type == 'Category' then
			category.Done.Visible = false
		end
	end

	for _, module in vape.Modules do
		module.Object.Visible = module.Visible
		module.Object.Text = string.rep(' ', 12)..module.Name
		module.Edit.Visible = false
	end
end)

done.MouseEnter:Connect(function()
	done.TextColor3 = Color3.fromRGB(220, 220, 220)
end)

done.MouseLeave:Connect(function()
	done.TextColor3 = Color3.fromRGB(140, 140, 140)
end)

pencilbutton.MouseButton1Click:Connect(function()
	vape.EditGUI = true
	pencilbutton.Visible = false

	for _, category in vape.Categories do
		if category.Type == 'Category' then
			category.Done.Visible = true
		end
	end

	for _, module in vape.Modules do
		module.Object.Visible = true
		module.Object.Text = string.rep(' ', 50)..module.Name
		module.Edit.Visible = true
	end
end)

pencilbutton.MouseButton2Click:Connect(function()
	component:Expand()
end)

pencilbutton.MouseEnter:Connect(function()
	pencil.ImageColor3 = Color3.fromRGB(220, 220, 220)
end)

pencilbutton.MouseLeave:Connect(function()
	pencil.ImageColor3 = Color3.fromRGB(140, 140, 140)
end)

window.MouseEnter:Connect(function()
	pencilbutton.Visible = not vape.EditGUI
end)

window.MouseLeave:Connect(function()
	pencilbutton.Visible = false
end)

window.InputBegan:Connect(function(input)
	if input.Position.Y < window.AbsolutePosition.Y + 41 and input.UserInputType == Enum.UserInputType.MouseButton2 then
		component:Expand()
	end
end)

children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
	if component.Expanded then
		window.Size = UDim2.fromOffset(220, math.min(41 + windowlist.AbsoluteContentSize.Y / scale.Scale, 601))
	end
end)

component.Button = vape.Categories.Main:CreateGUIButton({
	Name = props.Name,
	Icon = props.Icon,
	Size = props.Size,
	Window = window
})

component.Object = window
vape.Categories[props.Name] = component

return component