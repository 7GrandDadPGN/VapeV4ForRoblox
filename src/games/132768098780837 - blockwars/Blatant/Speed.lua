local Speed
local Value
local AutoJump
local AutoJumpCustom
local AutoJumpValue

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		if callback then
			if not AnticheatBypass.Enabled then
				AnticheatBypass:Toggle()
			end

			Speed:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive and not Fly.Enabled then
					local state = entitylib.character.Humanoid:GetState()
					if state == Enum.HumanoidStateType.Climbing then return end
					applySpeed(Value.Value, dt)

					if AutoJump.Enabled and entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and movevec ~= Vector3.zero then
						if AutoJumpCustom.Enabled then
							local velocity = entitylib.character.RootPart.Velocity * Vector3.new(1, 0, 1)
							entitylib.character.RootPart.Velocity = Vector3.new(velocity.X, AutoJumpValue.Value, velocity.Z)
						else
							entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end
			end))
		end
	end,
	ExtraText = function()
		return 'BlockWars'
	end,
	Tooltip = 'Increases your movement with various methods.'
})
Value = Speed:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 30,
	Default = 30,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoJump = Speed:CreateToggle({
	Name = 'AutoJump',
	Function = function(callback)
		AutoJumpCustom.Object.Visible = callback
	end
})
AutoJumpCustom = Speed:CreateToggle({
	Name = 'Custom Jump',
	Function = function(callback)
		AutoJumpValue.Object.Visible = callback
	end,
	Tooltip = 'Allows you to adjust the jump power',
	Darker = true,
	Visible = false
})
AutoJumpValue = Speed:CreateSlider({
	Name = 'Jump Power',
	Min = 1,
	Max = 50,
	Default = 30,
	Darker = true,
	Visible = false
})