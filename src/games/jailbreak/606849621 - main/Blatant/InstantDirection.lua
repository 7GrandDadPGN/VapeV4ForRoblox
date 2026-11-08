local InstantDirection

InstantDirection = vape.Categories.Blatant:CreateModule({
	Name = 'InstantDirection',
	Function = function(callback)
		if callback then
			InstantDirection:Clean(runService.PreSimulation:Connect(function()
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
				else
					YLevel = nil
					OldYLevel = nil
				end
			end))
		end
	end,
	Tooltip = 'Allow you to instantly turn towards where you are moving with vehicles.'
})