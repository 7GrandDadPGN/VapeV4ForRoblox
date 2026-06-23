local AntiHazard
local old

AntiHazard = vape.Categories.Blatant:CreateModule({
	Name = 'AntiHazard',
	Function = function(callback)
		if callback then
			old = hookfunction(bt.Network.FireServer, function(...)
				local event = ...
				if event == 'TakeDamage' then
					return
				end

				return old(...)
			end)
		else
			if old then
				hookfunction(bt.Network.FireServer, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Prevent you from taking damage in the overworld section.'
})