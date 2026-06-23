local AntiRiotShield

AntiRiotShield = vape.Categories.Blatant:CreateModule({
	Name = 'AntiRiotShield',
	Function = function(callback)
		if callback then
			repeat
				for _, ent in entitylib.List do
					local shield = ent.Character:FindFirstChild('RiotShieldPart')
					if shield then
						shield.CanQuery = false
					end
				end

				task.wait(0.05)
			until not AntiRiotShield.Enabled
		else
			for _, ent in entitylib.List do
				local shield = ent.Character:FindFirstChild('RiotShieldPart')
				if shield then
					shield.CanQuery = true
				end
			end
		end
	end,
	Tooltip = 'Allow you to shoot through riot shields.'
})