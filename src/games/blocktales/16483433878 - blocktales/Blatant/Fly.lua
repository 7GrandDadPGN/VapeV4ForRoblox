local Fly
local LongJump
run(function()
	local Value
	local VerticalValue
	local up, down = 0, 0, 0, 0, 0, 0

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			if callback then
				Fly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						local state = entitylib.character.Humanoid:GetState()
						if state == Enum.HumanoidStateType.Climbing or bt.Variables.transitioning then return end

						local movevec = entitylib.character.Humanoid.MoveDirection * Value.Value
                    	root.AssemblyLinearVelocity = Vector3.new(movevec.X, 1 + ((up + down) * VerticalValue.Value), movevec.Z)
					end
				end))

				up, down = 0, 0
				for _, v in {'InputBegan', 'InputEnded'} do
					Fly:Clean(inputService[v]:Connect(function(input)
						if not inputService:GetFocusedTextBox() then
							if input.KeyCode == Enum.KeyCode.Space then
								up = v == 'InputBegan' and 1 or 0
							elseif input.KeyCode == Enum.KeyCode.LeftControl then
								down = v == 'InputBegan' and -1 or 0
							end
						end
					end))
				end

				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						Fly:Clean(jumpButton:GetPropertyChangedSignal('ImageRectOffset'):Connect(function()
							up = jumpButton.ImageRectOffset.X == 146 and 1 or 0
						end))
					end)
				end
			end
		end,
		ExtraText = function()
			return 'Velocity'
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