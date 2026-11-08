local AntiPop

AntiPop = vape.Categories.Blatant:CreateModule({
	Name = 'AntiPop',
	Function = function(callback)
		if callback then
			AntiPop:Clean(runService.PostSimulation:Connect(function()
				if entitylib.isAlive and entitylib.character.Humanoid.Sit then
					local packet = jb.VehicleController.GetLocalVehiclePacket()
					if packet and not packet.Passenger then
						packet.Model:SetAttribute('VehicleTiresLastPop', nil)
					end
				end
			end))
		end
	end,
	Tooltip = 'Allow you to keep driving even while the vehicle is damaged.'
})