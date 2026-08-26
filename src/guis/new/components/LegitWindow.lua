local component = {
	Modules = {}
}

local window = Instance.new('Frame')
window.BackgroundColor3 = uipallet.Main
window.Position = UDim2.new(0.5, -350, 0.5, -190)
window.Size = UDim2.fromOffset(700, 380)
window.Name = 'LegitGUI'
window.Visible = false
window.Parent = scaledgui
table.insert(vape.Windows, window)
component.Window = window
addBlur(window)
addCorner(window)
addDragHandler(window)
local modal = Instance.new('TextButton')
modal.BackgroundTransparency = 1
modal.Modal = true
modal.Text = ''
modal.Parent = window
local icon = Instance.new('ImageLabel')
icon.BackgroundTransparency = 1
icon.Image = getvapeasset('newvape/assets/new/legit_mode_icon.png')
icon.ImageColor3 = uipallet.Text
icon.Position = UDim2.fromOffset(18, 11)
icon.Size = UDim2.fromOffset(16, 16)
icon.Parent = window
local close = Instance.new('ImageButton')
close.BackgroundTransparency = 1
close.Image = getvapeasset('newvape/assets/new/min.png')
close.ImageColor3 = color.Light(uipallet.Main, 0.24)
close.Position = UDim2.new(1, -31, 0, 11)
close.Size = UDim2.fromOffset(16, 16)
close.Parent = window
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
holder.Position = UDim2.new(1, -253, 0, 42)
holder.Size = UDim2.fromOffset(242, 29)
holder.Parent = window
addCorner(holder, UDim.new(0, 4))
local stroke = Instance.new('UIStroke')
stroke.Color = color.Light(uipallet.Main, 0.02)
stroke.Parent = holder
local searchicon = Instance.new('ImageLabel')
searchicon.BackgroundTransparency = 1
searchicon.Image = getvapeasset('newvape/assets/new/search.png')
searchicon.ImageColor3 = color.Light(uipallet.Main, 0.42)
searchicon.Position = UDim2.new(1, -25, 0, 9)
searchicon.Size = UDim2.fromOffset(12, 12)
searchicon.Parent = holder
local box = Instance.new('TextBox')
box.BackgroundTransparency = 1
box.ClearTextOnFocus = false
box.FontFace = uipallet.Font
box.PlaceholderColor3 = color.Dark(uipallet.Text, 0.16)
box.PlaceholderText = 'Search mods'
box.Position = UDim2.fromOffset(8, 0)
box.Size = UDim2.new(1, -8, 1, 0)
box.Text = ''
box.TextColor3 = color.Dark(uipallet.Text, 0.16)
box.TextSize = 14
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = holder
local children = Instance.new('ScrollingFrame')
children.BackgroundTransparency = 1
children.BorderSizePixel = 0
children.CanvasSize = UDim2.new()
children.Position = UDim2.fromOffset(14, 76)
children.ScrollBarThickness = 2
children.ScrollBarImageTransparency = 0.75
children.Size = UDim2.fromOffset(684, 301)
children.Parent = window
local windowlist = Instance.new('UIGridLayout')
windowlist.CellSize = UDim2.fromOffset(163, 114)
windowlist.CellPadding = UDim2.fromOffset(6, 6)
windowlist.FillDirectionMaxCells = 4
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, children, component)
	end
end

function component:CreateModule(props)
	return components.LegitModule(props, children, component)
end

local function visibleCheck()
	for _, module in component.Modules do
		if module.Children then
			local visible = clickgui.Visible
			--[[for _, v2 in self.Windows do
				visible = visible or v2.Visible
			end]]

			module.Children.Visible = (not visible or window.Visible) and module.Enabled
		end
	end
end

box:GetPropertyChangedSignal('Text'):Connect(function()
	for name, module in component.Modules do
		module.Object.Visible = (box.Text == '' or name:lower():find(box.Text:lower())) and true or false
	end
end)

close.MouseButton1Click:Connect(function()
	window.Visible = false
	clickgui.Visible = true
end)

close.MouseEnter:Connect(function()
	close.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

close.MouseLeave:Connect(function()
	close.ImageColor3 = color.Light(uipallet.Main, 0.24)
end)

vape:Clean(clickgui:GetPropertyChangedSignal('Visible'):Connect(visibleCheck))

holder.MouseEnter:Connect(function()
	tween:Tween(stroke, uipallet.Tween, {
		Color = color.Light(uipallet.Main, 0.0875)
	})
end)

holder.MouseLeave:Connect(function()
	tween:Tween(stroke, uipallet.Tween, {
		Color = color.Light(uipallet.Main, 0.02)
	})
end)

window:GetPropertyChangedSignal('Visible'):Connect(function()
	vape:UpdateGUI()
	visibleCheck()
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / scale.Scale)
end)

vape.Legit = component

return component