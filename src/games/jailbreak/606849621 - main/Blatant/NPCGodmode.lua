local NPCGodmode
local old

NPCGodmode = vape.Categories.Blatant:CreateModule({
	Name = 'NPCGodmode',
	Function = function(callback)
		if callback then
			old = hookfunction(jb.GunController._attemptShoot, function(...)
				local self = ...
				if self.SimulateLocal then
					return
				end

				return old(...)
			end)
		else
			if old then
				restorefunction(jb.GunController._attemptShoot)
				old = nil
			end
		end
	end,
	Tooltip = 'Prevent NPC bullets from hitting you.'
})