local Speed
local Value

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		if callback then
			Speed:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive and not Fly.Enabled and not LongJump.Enabled then
					local root = entitylib.character.RootPart
					local state = entitylib.character.Humanoid:GetState()
					if state == Enum.HumanoidStateType.Climbing or bt.Variables.transitioning then return end

					local movevec = entitylib.character.Humanoid.MoveDirection * Value.Value
					root.AssemblyLinearVelocity = Vector3.new(movevec.X, root.AssemblyLinearVelocity.Y, movevec.Z)
				end
			end))
		end
	end,
	ExtraText = function()
		return 'Velocity'
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