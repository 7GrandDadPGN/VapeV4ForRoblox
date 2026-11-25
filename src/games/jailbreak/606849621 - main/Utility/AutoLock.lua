local AutoLock

AutoLock = vape.Categories.Utility:CreateModule({
	Name = 'AutoLock',
	Function = function(callback)
		if callback then
			repeat
				local packet = jb.VehicleController.GetLocalVehiclePacket()
				if packet and packet.Model and packet.Model:GetAttribute('Locked') ~= true then
					jb.VehicleController.toggleLocalLocked()
				end

				task.wait(0.2)
			until not AutoLock.Enabled
		end
	end,
	Tooltip = 'Automatically lock your vehicle.'
})