local component = {
	Type = 'SearchBar'
}

local function listenProperty(src, dest, prop, obj)
	dest[prop] = src[prop]
	local connection = src:GetPropertyChangedSignal(prop):Connect(function()
		dest[prop] = src[prop]
	end)

	obj.Destroying:Once(function()
		connection:Disconnect()
	end)
end

local search = Instance.new('Frame')
search.AnchorPoint = Vector2.new(0.5, 0)
search.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
search.Name = 'Search'
search.Position = UDim2.new(0.5, 0, 0, 13)
search.Size = UDim2.fromOffset(220, 37)
search.Parent = clickgui
component.Object = search
addBlur(search)
addCorner(search)
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/search.png')
icon.ImageColor3 = color.Light(uipallet.Main, 0.37)
icon.Position = UDim2.new(1, -25, 0, 11)
icon.Size = UDim2.fromOffset(14, 14)
icon.Parent = search
local legiticon = Instance.new('ImageButton')
legiticon.BackgroundTransparency = 1
legiticon.Image = getvapeasset('newvape/assets/new/legit_switch.png')
legiticon.Name = 'Legit'
legiticon.Position = UDim2.fromOffset(8, 11)
legiticon.Size = UDim2.fromOffset(29, 16)
legiticon.Parent = search
listenProperty(vape.Categories.Main.Object.VapeLogo.V4Logo, legiticon, 'ImageColor3', legiticon)
local legitdivider = Instance.new('Frame')
legitdivider.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
legitdivider.BorderSizePixel = 0
legitdivider.Name = 'LegitDivider'
legitdivider.Position = UDim2.fromOffset(43, 13)
legitdivider.Size = UDim2.fromOffset(2, 12)
legitdivider.Parent = search
local box = Instance.new('TextBox')
box.BackgroundTransparency = 1
box.ClearTextOnFocus = false
box.FontFace = uipallet.Font
box.PlaceholderText = ''
box.Position = UDim2.fromOffset(50, 0)
box.Size = UDim2.new(1, -50, 0, 37)
box.Text = ''
box.TextColor3 = uipallet.Text
box.TextSize = 12
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = search
local children = Instance.new('ScrollingFrame')
children.BackgroundTransparency = 1
children.BorderSizePixel = 0
children.CanvasSize = UDim2.new()
children.Position = UDim2.fromOffset(0, 34)
children.ScrollBarThickness = 2
children.ScrollBarImageTransparency = 0.75
children.Size = UDim2.new(1, 0, 1, -37)
children.Parent = search
local divider = Instance.new('Frame')
divider.BackgroundColor3 = Color3.new(1, 1, 1)
divider.BackgroundTransparency = 0.928
divider.BorderSizePixel = 0
divider.Position = UDim2.fromOffset(0, 33)
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Visible = false
divider.Parent = search
local stroke = Instance.new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(85, 85, 85)
stroke.Transparency = 0.8
stroke.Parent = search
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children

box:GetPropertyChangedSignal('Text'):Connect(function()
	for _, obj in children:GetChildren() do
		if obj:IsA('TextButton') then
			obj:Destroy()
		end
	end

	if box.Text == '' then return end

	for name, module in vape.Modules do
		if name:lower():find(box.Text:lower()) then
			local button = module.Object:Clone()
			button.Bind:Destroy()

			button.MouseButton1Click:Connect(function()
				module:Toggle()
			end)

			button.MouseButton2Click:Connect(function()
				module.Object.Parent.Parent.Visible = true
				local frame = module.Object.Parent
				local highlight = Instance.new('Frame')
				highlight.Size = UDim2.fromScale(1, 1)
				highlight.BackgroundColor3 = Color3.new(1, 1, 1)
				highlight.BackgroundTransparency = 0.6
				highlight.BorderSizePixel = 0
				highlight.Parent = module.Object

				tween:Tween(highlight, TweenInfo.new(0.5), {
					BackgroundTransparency = 1
				})
				task.delay(0.5, highlight.Destroy, highlight)
				frame.CanvasPosition = Vector2.new(0, (module.Object.LayoutOrder * 40) - (math.min(frame.CanvasSize.Y.Offset, 600) / 2))
			end)

			for _, prop in {'Text', 'TextColor3', 'BackgroundColor3'} do
				listenProperty(module.Object, button, prop, button)
			end

			listenProperty(module.Object.UIGradient, button.UIGradient, 'Color', button)
			listenProperty(module.Object.UIGradient, button.UIGradient, 'Enabled', button)
			listenProperty(module.Object.Dots.Dots, button.Dots.Dots, 'ImageColor3', button)

			button.Parent = children
		end
	end
end)

children:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
	divider.Visible = children.CanvasPosition.Y > 10 and children.Visible
end)

legiticon.MouseButton1Click:Connect(function()
	clickgui.Visible = false
	vape.Legit.Window.Visible = true
	vape.Legit.Window.Position = UDim2.new(0.5, -350, 0.5, -194)
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
	search.Size = UDim2.fromOffset(220, math.min(37 + windowlist.AbsoluteContentSize.Y / scale.Scale, 437))
end)

return component