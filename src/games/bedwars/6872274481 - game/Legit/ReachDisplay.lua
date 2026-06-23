local ReachDisplay
local label

ReachDisplay = vape.Legit:CreateModule({
	Name = 'Reach Display',
	Function = function(callback)
		if callback then
			repeat
				label.Text = (store.attackReachUpdate > tick() and store.attackReach or '0.00')..' studs'
				task.wait(0.4)
			until not ReachDisplay.Enabled
		end
	end,
	Size = UDim2.fromOffset(100, 41)
})
ReachDisplay:CreateFont({
	Name = 'Font',
	Blacklist = 'Gotham',
	Function = function(val)
		label.FontFace = val
	end
})
ReachDisplay:CreateColorSlider({
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
label.Text = '0.00 studs'
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundColor3 = Color3.new()
label.Parent = ReachDisplay.Children
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = label