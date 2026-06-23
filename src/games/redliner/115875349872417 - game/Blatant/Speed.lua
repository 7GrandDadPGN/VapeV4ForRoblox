local Speed
local Value
local AutoJump
local AutoJumpCustom
local AutoJumpValue

Speed = vape.Categories.Blatant:CreateModule({
	Name = 'Speed',
	Function = function(callback)
		if callback then
			if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
				Speed:Clean(runService.PreSimulation:Connect(function()
					if not Fly.Enabled and not LongJump.Enabled then
						local dir = (TargetStrafeVector or redline[redline.MoveController]:getMoveDirection()) * Value.Value
						local oldvel = redline[redline.MoveController][redline.VelocityName]

						if AutoJump.Enabled and entitylib.isAlive and entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and dir.Magnitude > 0.01 then
							oldvel = Vector3.new(0, AutoJumpCustom.Enabled and AutoJumpValue.Value or 40, 0)
						end

						redline[redline.MoveController][redline.VelocityName] = Vector3.new(dir.X, oldvel.Y, dir.Z)
					end
				end))
			end
		end
	end,
	ExtraText = function()
		return 'Redliner'
	end,
	Tooltip = 'Increases your movement with various methods.'
})
Value = Speed:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 150,
	Default = 100,
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