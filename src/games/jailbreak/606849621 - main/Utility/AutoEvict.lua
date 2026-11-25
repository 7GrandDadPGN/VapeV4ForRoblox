local AutoEvict
local Whitelist

AutoEvict = vape.Categories.Utility:CreateModule({
	Name = 'AutoEvict',
	Function = function(callback)
		if callback then
			repeat
				local packet = jb.VehicleController.GetLocalVehiclePacket()
				if packet and packet.Model then
					for _, part in packet.Model:GetChildren() do
						if part.Name == 'Passenger' then
							local pname = part:FindFirstChild('PlayerName')

							if pname.Value ~= '' and not table.find(Whitelist.ListEnabled, pname.Value) then
								jb.VehicleController.attemptPassengerEject(pname.Value)
							end
						end
					end
				end

				task.wait(0.2)
			until not AutoEvict.Enabled
		end
	end,
	Tooltip = 'Automatically eject non-whitelisted players out of your vehicle.'
})
Whitelist = AutoEvict:CreateTextList({
	Name = 'Whitelist',
	Player = true
})