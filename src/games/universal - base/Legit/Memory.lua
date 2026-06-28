local Memory
local label

Memory = vape.Legit:CreateModule({
	Name = 'Memory',
	Function = function(callback)
		if callback then
			repeat
				label.Text = math.floor(tonumber(cloneref(game:GetService('Stats')):FindFirstChild('PerformanceStats').Memory:GetValue()))..' MB'
				task.wait(1)
			until not Memory.Enabled
		end
	end,
	Size = UDim2.fromOffset(100, 41),
	Tooltip = 'A label showing the memory currently used by roblox'
})
Memory:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
Memory:CreateColorSlider({
	Name = 'Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		label.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		label.BackgroundTransparency = 1 - opacity
	end
})
label = Instance.new('TextLabel')
label.Size = UDim2.new(0, 100, 0, 41)
label.BackgroundTransparency = 0.5
label.TextSize = 15
label.Font = Enum.Font.Gotham
label.Text = '0 MB'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = Memory.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label
