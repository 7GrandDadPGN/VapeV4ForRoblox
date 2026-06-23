local HitColor
local Color
local done = {}

HitColor = vape.Legit:CreateModule({
	Name = 'Hit Color',
	Function = function(callback)
		if callback then 
			repeat
				for i, v in entitylib.List do 
					local highlight = v.Character and v.Character:FindFirstChild('_DamageHighlight_')
					if highlight then 
						if not table.find(done, highlight) then 
							table.insert(done, highlight) 
						end
						highlight.FillColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
						highlight.FillTransparency = Color.Opacity
					end
				end
				task.wait(0.1)
			until not HitColor.Enabled
		else
			for i, v in done do 
				v.FillColor = Color3.new(1, 0, 0)
				v.FillTransparency = 0.4
			end
			table.clear(done)
		end
	end,
	Tooltip = 'Customize the hit highlight options'
})
Color = HitColor:CreateColorSlider({
	Name = 'Color',
	DefaultOpacity = 0.4
})