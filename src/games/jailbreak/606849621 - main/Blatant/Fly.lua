local Fly
local LongJump
run(function()
	local Value
	local UpKey
	local DownKey
	local VerticalValue
	local CustomProperties
	local PlatformStanding
	local Platform, YLevel, OldYLevel
	local up, down = 0, 0

	Fly = vape.Categories.Blatant:CreateModule({
		Name = 'Fly',
		Function = function(callback)
			frictionTable.Fly = callback and CustomProperties.Enabled or nil
			updateVelocity()
			if callback then
				Platform = Instance.new('Part')
				Platform.CanQuery = false
				Platform.Anchored = true
				Platform.Size = Vector3.new(100, 1, 100)
				Platform.Transparency = 1

				Fly:Clean(Platform)
				Fly:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						if PlatformStanding.Enabled then
							entitylib.character.Humanoid.PlatformStand = true
							entitylib.character.RootPart.AssemblyAngularVelocity = Vector3.zero
							entitylib.character.RootPart.CFrame = CFrame.lookAlong(entitylib.character.RootPart.CFrame.Position, gameCamera.CFrame.LookVector)
						end

						local hum = entitylib.character.Humanoid
						local root = entitylib.character.RootPart
						if hum.Sit then
							local packet = jb.VehicleController.GetLocalVehiclePacket()
							local wheel = packet and packet.EngineThrusters[1]

							if wheel then
								local suspension = (packet.Model:GetAttribute('GarageSuspensionHeight') or 0) + packet.Height
								lplr.Character:SetAttribute('DoNotAllowVehicleExit', table.find(UpKey.Keys, 'Space') and true or false)
								packet.Seat.CFrame += Vector3.new(0, (up + down) * VerticalValue.Value * dt, 0)
								Platform.Position = wheel.Engine.Position + Vector3.new(0, -suspension, 0)
								Platform.Parent = gameCamera
							end

							return
						else
							Platform.Parent = nil
						end

						root.AssemblyLinearVelocity = (hum.MoveDirection * Value.Value) + Vector3.new(0, 2.25 + ((up + down) * VerticalValue.Value), 0)
					else
						YLevel = nil
						OldYLevel = nil
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
			else
				YLevel, OldYLevel = nil, nil
				if entitylib.isAlive then
					if PlatformStanding.Enabled then
						entitylib.character.Humanoid.PlatformStand = false
					end

					lplr.Character:SetAttribute('DoNotAllowVehicleExit', nil)
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
	PlatformStanding = Fly:CreateToggle({
		Name = 'PlatformStand',
		Function = function(callback)
			if Fly.Enabled then
				entitylib.character.Humanoid.PlatformStand = callback
			end
		end,
		Tooltip = 'Forces the character to look infront of the camera'
	})
	CustomProperties = Fly:CreateToggle({
		Name = 'Custom Properties',
		Function = function()
			if Fly.Enabled then
				Fly:Toggle()
				Fly:Toggle()
			end
		end,
		Default = true
	})
end)