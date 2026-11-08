local AntiEject

AntiEject = vape.Categories.Blatant:CreateModule({
	Name = 'AntiEject',
	Function = function(callback)
		if callback then
			local old, seat
			AntiEject:Clean(runService.Heartbeat:Connect(function()
				if entitylib.isAlive and entitylib.character.Humanoid.Sit and lplr.Team ~= teams.Police then
					task.defer(function()
						local packet = jb.VehicleController.GetLocalVehiclePacket()
						seat = packet and (not packet.Passenger) and packet.Seat or nil

						if seat and seat.AssemblyLinearVelocity.Magnitude < 100 then
							old = seat.AssemblyLinearVelocity
							seat.AssemblyLinearVelocity += Vector3.new(0, -200, 0)
						else
							old = nil
						end
					end)
				end
			end))

			AntiEject:Clean(runService.RenderStepped:Connect(function()
				if seat and old then
					seat.AssemblyLinearVelocity = old
				end
			end))
		end
	end,
	Tooltip = 'Prevent police from forcing you out of your vehicle.'
})