local Clock
local TwentyFourHour
local label

Clock = vape.Legit:CreateModule({
	Name = 'Clock',
	Function = function(callback)
		if callback then
			repeat
				label.Text = DateTime.now():FormatLocalTime('LT', TwentyFourHour.Enabled and 'zh-cn' or 'en-us')
				task.wait(1)
			until not Clock.Enabled
		end
	end,
	Size = UDim2.fromOffset(100, 41),
	Tooltip = 'Shows the current local time'
})
Clock:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
Clock:CreateColorSlider({
	Name = 'Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		label.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		label.BackgroundTransparency = 1 - opacity
	end
})
TwentyFourHour = Clock:CreateToggle({
	Name = '24 Hour Clock'
})
label = Instance.new('TextLabel')
label.Size = UDim2.new(0, 100, 0, 41)
label.BackgroundTransparency = 0.5
label.TextSize = 15
label.Font = Enum.Font.Gotham
label.Text = '0:00 PM'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = Clock.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label