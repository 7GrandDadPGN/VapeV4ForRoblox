local old, oldshake, oldslow

vape.Categories.Blatant:CreateModule({
	Name = 'NoRecoil',
	Function = function(callback)
		if callback then
			old = hookfunction(rawget(tribes.Util, 'Recoil'), newcclosure(function(...)
				hideStack()
				if not argCheck({{'number'}, {'number', 'nil'}, {'number', 'nil'}}, ...) then
					return old(...)
				end
			end))

			oldshake = hookfunction(rawget(tribes.Util, 'Shake'), newcclosure(function(...)
				hideStack()
				if not argCheck({{'number'}, {'number', 'nil'}, {'number', 'nil'}, {'number', 'nil'}}, ...) then
					return oldshake(...)
				end
			end))

			oldslow = hookfunction(rawget(tribes.Util, 'RecoilSlow'), newcclosure(function(...)
				hideStack()
				if not argCheck({{'number'}, {'number', 'nil'}, {'number', 'nil'}, {'number', 'nil'}}, ...) then
					return old(...)
				end
			end))
		else
			if old then
				restorefunction(rawget(tribes.Util, 'Recoil'))
				old = nil
			end

			if oldshake then
				restorefunction(rawget(tribes.Util, 'Shake'))
				oldshake = nil
			end

			if oldslow then
				restorefunction(rawget(tribes.Util, 'RecoilSlow'))
				oldslow = nil
			end
		end
	end,
	Tooltip = 'Remove camera shake & recoil from many aspects of the game.'
})