local Health
local Size
local Stroke
local Offset
local FontOption
local label

Health = vape.Categories.Render:CreateModule({
	Name = 'Health',
	Function = function(callback)
		if callback then
			label = Instance.new('TextLabel')
			label.Size = UDim2.fromOffset(100, 20)
			label.Position = UDim2.new(0.5, 6, 0.5, Offset.Value)
			label.AnchorPoint = Vector2.new(0.5, 0)
			label.BackgroundTransparency = 1
			label.Text = '100 ❤️'
			label.TextSize = Size.Value
			label.TextStrokeTransparency = Stroke.Value
			label.FontFace = FontOption.Value
			label.Parent = vape.gui
			Health:Clean(label)

			repeat
				label.Text = entitylib.isAlive and math.round(entitylib.character.Humanoid.Health)..' ❤️' or ''
				label.TextColor3 = entitylib.isAlive and Color3.fromHSV((entitylib.character.Humanoid.Health / entitylib.character.Humanoid.MaxHealth) / 2.8, 0.86, 1) or Color3.new()
				task.wait()
			until not Health.Enabled
		else
			label = nil
		end
	end,
	Tooltip = 'Displays your health in the center of your screen.'
})
FontOption = Health:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial',
	Function = function(value)
		if label then
			label.FontFace =value
		end
	end
})
Size = Health:CreateSlider({
	Name = 'Size',
	Min = 1,
	Max = 30,
	Default = 18,
	Function = function(value)
		if label then
			label.TextSize = value
		end
	end
})
Stroke = Health:CreateSlider({
	Name = 'Stroke Transparency',
	Function = function(value)
		if label then
			label.TextStrokeTransparency = value
		end
	end,
	Default = 1,
	Min = 0,
	Max = 1,
	Decimal = 10
})
Offset = Health:CreateSlider({
	Name = 'Y Offset',
	Min = 0,
	Max = 100,
	Default = 30,
	Function = function(value)
		if label then
			label.Position = UDim2.new(0.5, 6, 0.5, value)
		end
	end
})