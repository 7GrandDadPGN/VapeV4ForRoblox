local Fly
local LongJump
run(function()
	local Value
	local VerticalValue
	local up, down = 0, 0

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			if callback then
				if redline[redline.MoveController] and typeof(redline[redline.MoveController][redline.VelocityName]) == 'Vector3' then
					Fly:Clean(runService.PreSimulation:Connect(function(dt)
						local dir = ((TargetStrafeVector or redline[redline.MoveController]:getMoveDirection()) * Value.Value) + Vector3.new(0, 3.5 + (up + down) * VerticalValue.Value, 0)
						redline[redline.MoveController][redline.VelocityName] = dir
					end))
				end

				up, down = 0, 0
				for _, v in {'InputBegan', 'InputEnded'} do
					Fly:Clean(inputService[v]:Connect(function(input)
						if not inputService:GetFocusedTextBox() then
							if input.KeyCode == Enum.KeyCode.Space then
								up = v == 'InputBegan' and 1 or 0
							elseif input.KeyCode == Enum.KeyCode.LeftAlt then
								down = v == 'InputBegan' and -1 or 0
							end
						end
					end))
				end
			end
		end,
		ExtraText = function()
			return 'Redliner'
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	VerticalValue = Fly:CreateSlider({
		Name = 'Vertical Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)