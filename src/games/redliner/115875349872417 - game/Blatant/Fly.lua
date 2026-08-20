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
					addVelocity(Vector3.new(0, 3.5 + (up + down) * VerticalValue.Value, 0))
				end))

				up, down = 0, 0
				Fly:Clean(UpKey.Triggered:Connect(function(isDown)
					up = isDown and 1 or 0
				end))

				Fly:Clean(DownKey.Triggered:Connect(function(isDown)
					down = isDown and -1 or 0
				end))
			end
		end,
		ExtraText = function()
			return 'Redliner'
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
		Default = {'LeftAlt'},
		Hold = true,
		Tooltip = 'Keybind to fly downwards'
	})
	--[[Value = Fly:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 150,
		Default = 50,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})]]
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