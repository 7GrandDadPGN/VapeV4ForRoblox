local Speed
local Value
local CustomProperties

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		frictionTable.Speed = callback and CustomProperties.Enabled or nil
		updateVelocity()
		if callback then
			Speed:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive and not Fly.Enabled and not LongJump.Enabled then
					local hum = entitylib.character.Humanoid
					local state = entitylib.character.Humanoid:GetState()
					if state == Enum.HumanoidStateType.Climbing then return end
					if hum.Sit then return end

					local root = entitylib.character.RootPart
					root.AssemblyLinearVelocity = (hum.MoveDirection * Value.Value) + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
				end
			end))
		end
	end,
	Tooltip = 'Increases your movement with various methods.'
})
Value = Speed:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 150,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
CustomProperties = Speed:CreateToggle({
	Name = 'Custom Properties',
	Function = function()
		if Speed.Enabled then
			Speed:Toggle()
			Speed:Toggle()
		end
	end,
	Default = true
})