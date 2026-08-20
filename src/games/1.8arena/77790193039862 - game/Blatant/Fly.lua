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
						local movedir = calculateMoveVector() * Value.Value
						local velocity = debug.getupvalue(arena.TickFunction, 6)

						debug.setupvalue(arena.TickFunction, 6, Vector3.new(movedir.X, 1 + ((up + down) * VerticalValue.Value), movedir.Z))
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