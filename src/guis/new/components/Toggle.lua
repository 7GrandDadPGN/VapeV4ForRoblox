local component = {
	Enabled = false,
	Index = getTableSize(api.Options),
	Name = props.Name,
	Type = 'Toggle'
}

local isHover = false
local toggle = Instance.new('TextButton')
toggle.AutoButtonColor = false
toggle.BackgroundColor3 = color.Dark(children.BackgroundColor3, props.Darker and 0.02 or 0)
toggle.BorderSizePixel = 0
toggle.FontFace = uipallet.Font
toggle.Size = UDim2.new(1, 0, 0, 30)
toggle.Text = '          '..props.Name
toggle.TextColor3 = color.Dark(uipallet.Text, 0.16)
toggle.TextSize = 14
toggle.TextXAlignment = Enum.TextXAlignment.Left
toggle.Visible = props.Visible == nil or props.Visible
toggle.Parent = children
component.Object = toggle
addTooltip(toggle, props.Tooltip)
local holder = Instance.new('Frame')
holder.BackgroundColor3 = color.Light(uipallet.Main, 0.14)
holder.Name = 'Holder'
holder.Position = UDim2.new(1, -30, 0, 9)
holder.Size = UDim2.fromOffset(22, 12)
holder.Parent = toggle
addCorner(holder, UDim.new(1, 0))
local knob = Instance.new('Frame')
knob.BackgroundColor3 = uipallet.Main
knob.Position = UDim2.fromOffset(2, 2)
knob.Size = UDim2.fromOffset(8, 8)
knob.Parent = holder
addCorner(knob, UDim.new(1, 0))
props.Function = props.Function or function() end

function component:Color(hue, sat, val, isRainbow)
	if self.Enabled then
		tween:Cancel(holder)
		holder.BackgroundColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(hue, sat, val)
	end
end

function component:Load(data)
	if self.Enabled ~= data.Enabled then
		self:Toggle()
	end

	if self.Bind and data.Bind then
		self.Bind:Load(data.Bind)
	end
end

function component:Save(data)
	data[props.Name] = {
		Enabled = self.Enabled
	}

	if self.Bind then
		self.Bind:Save(data[props.Name])
	end
end

function component:Toggle()
	local isRainbow = vape.GUIColor.Rainbow and vape.RainbowMode.Value ~= 'Retro'
	self.Enabled = not self.Enabled

	tween:Tween(holder, uipallet.Tween, {
		BackgroundColor3 = self.Enabled and (isRainbow and Color3.fromHSV(vape:Color((vape.GUIColor.Hue - (self.Index * 0.075)) % 1)) or Color3.fromHSV(vape.GUIColor.Hue, vape.GUIColor.Sat, vape.GUIColor.Value)) or (isHover and color.Light(uipallet.Main, 0.37) or color.Light(uipallet.Main, 0.14))
	})

	tween:Tween(knob, uipallet.Tween, {
		Position = UDim2.fromOffset(self.Enabled and 12 or 2, 2)
	})

	props.Function(self.Enabled)
end

toggle.MouseEnter:Connect(function()
	isHover = true

	if not component.Enabled then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.37)
		})
	end
end)

toggle.MouseLeave:Connect(function()
	isHover = false

	if not component.Enabled then
		tween:Tween(holder, uipallet.Tween, {
			BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		})
	end
end)

toggle.MouseButton1Click:Connect(function()
	component:Toggle()
end)

if props.Default then
	component:Toggle()
end

api.Options[props.Name] = component

return component