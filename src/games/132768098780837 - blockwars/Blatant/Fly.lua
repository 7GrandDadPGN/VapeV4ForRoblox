local Fly
run(function()
	local Value
	local Keys
	local Platform = Instance.new('Part')
	Platform.CanQuery = false
	Platform.Anchored = true
	Platform.Size = Vector3.new(4, 1, 4)
	Platform.Transparency = 1
	Platform.Parent = nil

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			if Platform then
				Platform.Parent = callback and gameCamera or nil
			end

			if callback then
				if not AnticheatBypass.Enabled then
					AnticheatBypass:Toggle()
				end

				Fly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						applySpeed(Value.Value, dt)
						Platform.CFrame = down ~= 0 and CFrame.identity or entitylib.character.RootPart.CFrame + Vector3.new(0, -(entitylib.character.HipHeight + 0.5), 0)
					end
				end))

				up, down = 0, 0
				for _, v in {'InputBegan', 'InputEnded'} do
					Fly:Clean(inputService[v]:Connect(function(input)
						if not inputService:GetFocusedTextBox() then
							local divided = Keys.Value:split('/')
							if input.KeyCode == Enum.KeyCode[divided[1]] then
								up = v == 'InputBegan' and 1 or 0
							elseif input.KeyCode == Enum.KeyCode[divided[2]] then
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
			return 'BlockWars'
		end,
		Tooltip = 'Makes you go zoom.'
	})
	Keys = Fly:CreateDropdown({
		Name = 'Keys',
		List = {'Space/LeftControl', 'Space/LeftShift', 'E/Q', 'Space/Q', 'ButtonA/ButtonL2'},
		Tooltip = 'The key combination for going up & down'
	})
	Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 30,
		Default = 30,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)