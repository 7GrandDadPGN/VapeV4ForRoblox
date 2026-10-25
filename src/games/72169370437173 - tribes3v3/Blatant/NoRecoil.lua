local old, oldshake, oldslow

vape.Categories.Blatant:CreateModule({
	Name = 'NoRecoil',
	Function = function(callback)
		if callback then
			old = hookfunction(tribes.Util.Recoil, function() end)
			oldshake = hookfunction(tribes.Util.Shake, function() end)
			oldslow = hookfunction(tribes.Util.RecoilSlow, function() end)
		else
			if old then
				restorefunction(tribes.Util.Recoil)
				old = nil
			end

			if oldshake then
				restorefunction(tribes.Util.Shake)
				oldshake = nil
			end

			if oldslow then
				restorefunction(tribes.Util.RecoilSlow)
				oldslow = nil
			end
		end
	end,
	Tooltip = 'Remove camera shake & recoil from many aspects of the game.'
})