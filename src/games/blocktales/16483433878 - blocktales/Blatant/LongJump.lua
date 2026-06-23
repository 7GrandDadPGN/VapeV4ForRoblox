local Value
local AutoDisable

LongJump = vape.Categories.Blatant:CreateModule({
	Name = 'LongJump',
	Function = function(callback)
		if callback then
			local exempt = tick() + 0.1
			LongJump:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive then
					if entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						if exempt < tick() and AutoDisable.Enabled then
							if LongJump.Enabled then
								LongJump:Toggle()
							end
						else
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end

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
	Tooltip = 'Lets you jump farther'
})
Value = LongJump:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 150,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoDisable = LongJump:CreateToggle({
	Name = 'Auto Disable',
	Default = true
})