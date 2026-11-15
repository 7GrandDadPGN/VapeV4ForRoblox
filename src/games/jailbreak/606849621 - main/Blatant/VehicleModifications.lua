local VehicleModifications
local InstantDirection
local ModifySpeed
local Value
local Boat
local old
local oldboat

VehicleModifications = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleModifications',
	Function = function(callback)
		if callback then
			if InstantDirection.Enabled then
				VehicleModifications:Clean(runService.PreSimulation:Connect(function()
					if entitylib.isAlive then
						local hum = entitylib.character.Humanoid
						local moveDir = hum.MoveDirection

						if hum.Sit and moveDir.Magnitude > 0 then
							local packet = jb.VehicleController.GetLocalVehiclePacket()

							if packet and not packet.Passenger then
								local horizontal = packet.Seat.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
								local speed = math.max(horizontal.Magnitude, 1)
								if (gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)):Angle(moveDir) > math.rad(140) then
									speed = math.min(speed, 80)
								end

								packet.Seat.CFrame = CFrame.lookAlong(packet.Seat.Position, Vector3.new(moveDir.X, math.clamp(packet.Seat.CFrame.LookVector.Y, -0.1, 0.5), moveDir.Z))
								packet.Seat.AssemblyLinearVelocity = (moveDir * speed) + Vector3.new(0, packet.Seat.AssemblyLinearVelocity.Y, 0)
							end
						end
					end
				end))
			end

			if ModifySpeed.Enabled then
				old = hookfunction(jb.AlexChassis.Update, function(...)
					local self = ...
					self.GarageEngineSpeed = Value.Value
					return old(...)
				end)

				if Boat.Enabled then
					oldboat = hookfunction(jb.Boat.UpdatePhysics, function(...)
						local self = ...
						self.SpringAccelp *= math.max(Value.Value / 10, 1)
						return oldboat(...)
					end)
				end
			end
		else
			if old then
				restorefunction(jb.AlexChassis.Update)
				old = nil
			end

			if oldboat then
				restorefunction(jb.Boat.UpdatePhysics)
				oldboat = nil
			end
		end
	end,
	Tooltip = 'Apply various driving enhancements.'
})
InstantDirection = VehicleModifications:CreateToggle({
	Name = 'Instant Direction',
	Function = function(callback)
		if VehicleModifications.Enabled then
			VehicleModifications:Toggle()
			VehicleModifications:Toggle()
		end
	end,
	Tooltip = 'Allow you to instantly turn towards the camera with vehicles.'
})
ModifySpeed = VehicleModifications:CreateToggle({
	Name = 'Modify Speed',
	Function = function(callback)
		if VehicleModifications.Enabled then
			VehicleModifications:Toggle()
			VehicleModifications:Toggle()
		end

		Value.Object.Visible = callback
		Boat.Object.Visible = callback
	end,
	Tooltip = 'Adjust the local engine level of the vehicle.'
})
Value = VehicleModifications:CreateSlider({
	Name = 'Speed',
	Min = 0,
	Max = 30,
	Default = 30,
	Visible = false,
	Darker = true
})
Boat = VehicleModifications:CreateToggle({
	Name = 'Modify Boats',
	Default = true,
	Function = function()
		if VehicleModifications.Enabled then
			VehicleModifications:Toggle()
			VehicleModifications:Toggle()
		end
	end,
	Tooltip = 'Allow you to adjust the speed of boats',
	Visible = false,
	Darker = true
})
