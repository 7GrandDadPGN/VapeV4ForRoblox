local Mode
local Value
local AutoDisable

LongJump = vape.Categories.Blatant:CreateModule({
	Name = 'LongJump',
	Function = function(callback)
		if callback then
			local enableTime = os.clock() + 0.1
			LongJump:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive then
					local hum = entitylib.character.Humanoid
					local root = entitylib.character.RootPart

					if hum.FloorMaterial ~= Enum.Material.Air then
						if enableTime < os.clock() and AutoDisable.Enabled then
							if LongJump.Enabled then
								LongJump:Toggle()
							end
						else
							hum:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end

					local dir = hum.MoveDirection * Value.Value
					if Mode.Value == 'Velocity' then
						root.AssemblyLinearVelocity = dir + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
					elseif Mode.Value == 'Impulse' then
						local diff = (dir - root.AssemblyLinearVelocity) * Vector3.new(1, 0, 1)
						if diff.Magnitude > (dir == Vector3.zero and 10 or 2) then
							root:ApplyImpulse(diff * root.AssemblyMass)
						end
					else
						root.CFrame += dir * dt
					end
				end
			end))
		end
	end,
	ExtraText = function()
		return Mode.Value
	end,
	Tooltip = 'Lets you jump farther'
})
Mode = LongJump:CreateDropdown({
	Name = 'Mode',
	List = {'Velocity', 'Impulse', 'CFrame'},
	Tooltip = 'Velocity - Uses smooth physics based movement\nImpulse - Same as velocity while using forces instead\nCFrame - Directly adjusts the position of the root'
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