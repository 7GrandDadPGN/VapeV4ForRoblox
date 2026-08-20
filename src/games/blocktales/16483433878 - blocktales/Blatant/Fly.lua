local Fly
local LongJump
run(function()
	local UpKey
	local DownKey
	local Value
	local VerticalValue
	local up, down = 0, 0

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
				Fly:Clean(UpKey.Triggered:Connect(function(isDown)
					up = isDown and 1 or 0
				end))

				Fly:Clean(DownKey.Triggered:Connect(function(isDown)
					down = isDown and -1 or 0
				end))

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
	UpKey = Fly:CreateBind({
		Name = 'Up Key',
		Default = {'Space'},
		Hold = true,
		Tooltip = 'Keybind to fly upwards'
	})
	DownKey = Fly:CreateBind({
		Name = 'Down Key',
		Default = {'LeftControl'},
		Hold = true,
		Tooltip = 'Keybind to fly downwards'
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