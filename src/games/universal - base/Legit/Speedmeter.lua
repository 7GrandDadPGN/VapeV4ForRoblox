local Speedmeter
local label

Speedmeter = vape.Legit:CreateModule({
	Name = 'Speedmeter',
	Function = function(callback)
		if callback then
			repeat
				local lastpos = entitylib.isAlive and entitylib.character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) or Vector3.zero
				local dt = task.wait(0.2)
				local newpos = entitylib.isAlive and entitylib.character.HumanoidRootPart.Position * Vector3.new(1, 0, 1) or Vector3.zero
				label.Text = math.round(((lastpos - newpos) / dt).Magnitude)..' sps'
			until not Speedmeter.Enabled
		end
	end,
	Size = UDim2.fromOffset(100, 41),
	Tooltip = 'A label showing the average velocity in studs'
})
Speedmeter:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
Speedmeter:CreateColorSlider({
	Name = 'Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		label.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		label.BackgroundTransparency = 1 - opacity
	end
})
label = Instance.new('TextLabel')
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 0.5
label.TextSize = 15
label.Font = Enum.Font.Gotham
label.Text = '0 sps'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = Speedmeter.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label