local AntiTaze
local old

AntiTaze = vape.Categories.Blatant:CreateModule({
	Name = 'AntiTaze',
	Function = function(callback)
		if callback then
			old = hookfunction(jb.StunFunction, function() end)
		else
			if old then
				restorefunction(jb.StunFunction)
				old = nil
			end
		end
	end,
	Tooltip = 'Prevent yourself from getting tazed.'
})