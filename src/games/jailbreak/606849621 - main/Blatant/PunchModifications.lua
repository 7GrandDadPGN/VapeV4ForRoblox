local PunchModifications
local AutoPunch
local NoCooldown
local old

PunchModifications = vape.Categories.Blatant:CreateModule({
	Name = 'PunchModifications',
	Function = function(callback)
		if callback then
			local punch
			for _, obj in jb.ActionButtonService.active do
				if obj.name == 'punch' then
					punch = obj
					break
				end
			end

			if punch then
				if NoCooldown.Enabled then
					old = debug.getupvalue(punch.onPressed, 1).attemptPunch
					debug.setconstant(old, 3, 0.1)
				end

				repeat
					if AutoPunch.Enabled and punch._pressed then
						task.spawn(punch.onPressed)
					end

					task.wait(0.05)
				until not PunchModifications.Enabled
			end
		else
			if old then
				debug.setconstant(old, 3, 0.5)
				old = nil
			end
		end
	end,
	Tooltip = 'Modify certain behavior related to punching.'
})
AutoPunch = PunchModifications:CreateToggle({
	Name = 'Automatic',
	Tooltip = 'Automatically punch while the punch action is pressed.',
	Default = true
})
NoCooldown = PunchModifications:CreateToggle({
	Name = 'No Cooldown',
	Function = function()
		if PunchModifications.Enabled then
			PunchModifications:Toggle()
			PunchModifications:Toggle()
		end
	end,
	Tooltip = 'Lower the punch cooldown to 0.1s (less = server ratelimit)'
})