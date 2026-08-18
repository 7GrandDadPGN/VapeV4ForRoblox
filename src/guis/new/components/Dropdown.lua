local component = {
	Index = 0,
	Type = 'Dropdown',
	Value = props.List[1] or 'None'
}

local dropdown = Instance.new('TextButton')
dropdown.AutoButtonColor = false
dropdown.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
dropdown.BorderSizePixel = 0
dropdown.Size = UDim2.new(1, 0, 0, 40)
dropdown.Text = ''
dropdown.Visible = props.Visible == nil or props.Visible
dropdown.Parent = children
component.Object = dropdown
addTooltip(dropdown, props.Tooltip or props.Name)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
holder.Position = UDim2.fromOffset(10, 4)
holder.Size = UDim2.new(1, -20, 1, -11)
holder.Parent = dropdown
addCorner(holder, UDim.new(0, 6))
local button = Instance.new('TextButton')
button.AutoButtonColor = false
button.BackgroundColor3 = uipallet.Main
button.Position = UDim2.fromOffset(1, 1)
button.Size = UDim2.new(1, -2, 1, -2)
button.Text = ''
button.Parent = holder
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Size = UDim2.new(1, 0, 0, 29)
title.Text = '         '..props.Name..' - '..component.Value
title.TextColor3 = color.Dark(uipallet.Text, 0.16)
title.TextSize = 13
title.TextTruncate = Enum.TextTruncate.AtEnd
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = button
addCorner(button, UDim.new(0, 6))
local arrow = Instance.new('ImageLabel')
arrow.BackgroundTransparency = 1
arrow.Image = getvapeasset('newvape/assets/new/expandarrow.png')
arrow.ImageColor3 = Color3.fromRGB(140, 140, 140)
arrow.Position = UDim2.new(1, -17, 0, 11)
arrow.Rotation = 90
arrow.Size = UDim2.fromOffset(4, 8)
arrow.Parent = button
props.Function = props.Function or function() end
local dropdownchildren

function component:Change(list)
	props.List = list or {}
	if not table.find(props.List, self.Value) then
		self:SetValue(self.Value)
	end
end

function component:Load(data)
	if self.Value ~= data.Value then
		self:SetValue(data.Value)
	end
end

function component:Save(data)
	data[props.Name] = {
		Value = self.Value
	}
end

function component:SetValue(value, isClick)
	self.Value = table.find(props.List, value) and value or props.List[1] or 'None'
	title.Text = '         '..props.Name..' - '..self.Value

	if dropdownchildren then
		arrow.Rotation = 90
		dropdownchildren:Destroy()
		dropdownchildren = nil
		dropdown.Size = UDim2.new(1, 0, 0, 40)
	end

	props.Function(self.Value, isClick)
end

button.MouseButton1Click:Connect(function()
	if not dropdownchildren then
		arrow.Rotation = 270
		dropdown.Size = UDim2.new(1, 0, 0, 43 + (#props.List - 1) * 26)
		dropdownchildren = Instance.new('Frame')
		dropdownchildren.BackgroundTransparency = 1
		dropdownchildren.Position = UDim2.fromOffset(0, 27)
		dropdownchildren.Size = UDim2.new(1, 0, 0, (#props.List - 1) * 26)
		dropdownchildren.Parent = button

		local index = 0
		for _, v in props.List do
			if v == component.Value then continue end
			local entry = Instance.new('TextButton')
			entry.AutoButtonColor = false
			entry.BackgroundColor3 = uipallet.Main
			entry.BorderSizePixel = 0
			entry.FontFace = uipallet.Font
			entry.Position = UDim2.fromOffset(0, index * 26)
			entry.Size = UDim2.new(1, 0, 0, 26)
			entry.Text = '         '..v
			entry.TextColor3 = color.Dark(uipallet.Text, 0.16)
			entry.TextSize = 13
			entry.TextTruncate = Enum.TextTruncate.AtEnd
			entry.TextXAlignment = Enum.TextXAlignment.Left
			entry.Parent = dropdownchildren

			entry.MouseEnter:Connect(function()
				entry.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
				entry.TextColor3 = uipallet.Text
			end)

			entry.MouseLeave:Connect(function()
				entry.BackgroundColor3 = uipallet.Main
				entry.TextColor3 = color.Dark(uipallet.Text, 0.16)
			end)

			entry.MouseButton1Click:Connect(function()
				component:SetValue(v, true)
			end)

			index += 1
		end
	else
		component:SetValue(component.Value, true)
	end
end)

dropdown.MouseEnter:Connect(function()
	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.0875)
	})
end)

dropdown.MouseLeave:Connect(function()
	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = color.Light(uipallet.Main, 0.034)
	})
end)

api.Options[props.Name] = component

return component