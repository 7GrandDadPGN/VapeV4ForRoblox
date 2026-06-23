local Gravity
local Value

Gravity = vape.Categories.World:CreateModule({
	Name = 'Gravity',
	Function = function(callback)
		if callback then
			if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
				Gravity:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive and entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air then
						redline[redline.MoveController][redline.VelocityName] += Vector3.new(0, dt * (workspace.Gravity - Value.Value), 0)
					end
				end))
			end
		end
	end,
	Tooltip = 'Changes the rate you fall'
})
Value = Gravity:CreateSlider({
	Name = 'Gravity',
	Min = 0,
	Max = 192,
	Default = 192
})