local Ping
local label

Ping = vape.Legit:CreateModule({
	Name = 'Ping',
	Function = function(callback)
		if callback then
			repeat
				label.Text = math.floor(tonumber(cloneref(game:GetService('Stats')):FindFirstChild('PerformanceStats').Ping:GetValue()))..' ms'
				task.wait(1)
			until not Ping.Enabled
		end
	end,
	Size = UDim2.fromOffset(100, 41),
	Tooltip = 'Shows the current connection speed to the roblox server'
})
Ping:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
Ping:CreateColorSlider({
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
label.Text = '0 ms'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = Ping.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label