local component = {
	Index = 0,
	Type = 'TextBox',
	Value = props.Default or ''
}

local textbox = Instance.new('TextButton')
textbox.AutoButtonColor = false
textbox.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
textbox.BorderSizePixel = 0
textbox.Size = UDim2.new(1, 0, 0, 58)
textbox.Text = ''
textbox.Visible = props.Visible == nil or props.Visible
textbox.Parent = children
component.Object = textbox
addTooltip(textbox, props.Tooltip)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.FontFace = uipallet.Font
title.Position = UDim2.fromOffset(10, 3)
title.Size = UDim2.new(1, -10, 0, 20)
title.Text = props.Name
title.TextColor3 = uipallet.Text
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = textbox
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
holder.Position = UDim2.fromOffset(10, 23)
holder.Size = UDim2.new(1, -20, 0, 29)
holder.Parent = textbox
addCorner(holder, UDim.new(0, 4))
local inputbox = Instance.new('TextBox')
inputbox.BackgroundTransparency = 1
inputbox.ClearTextOnFocus = false
inputbox.FontFace = uipallet.Font
inputbox.PlaceholderColor3 = color.Dark(uipallet.Text, 0.31)
inputbox.PlaceholderText = props.Placeholder or 'Click to set'
inputbox.Position = UDim2.fromOffset(8, 0)
inputbox.Size = UDim2.new(1, -8, 1, 0)
inputbox.Text = props.Default or ''
inputbox.TextColor3 = color.Dark(uipallet.Text, 0.16)
inputbox.TextSize = 12
inputbox.TextXAlignment = Enum.TextXAlignment.Left
inputbox.Parent = holder
props.Function = props.Function or function() end

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

function component:SetValue(val, enter)
	self.Value = val
	inputbox.Text = val
	props.Function(enter)
end

textbox.MouseButton1Click:Connect(function()
	inputbox:CaptureFocus()
end)

inputbox.FocusLost:Connect(function(enter)
	component:SetValue(inputbox.Text, enter)
end)

inputbox:GetPropertyChangedSignal('Text'):Connect(function()
	component:SetValue(inputbox.Text)
end)

api.Options[props.Name] = component

return component