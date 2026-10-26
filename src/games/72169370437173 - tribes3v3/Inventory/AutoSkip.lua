local AutoSkip

AutoSkip = vape.Categories.Inventory:CreateModule({
	Name = 'AutoSkip',
	Function = function(callback)
		if callback then
			dumpInput()
			repeat
				local bind = contextActionService:GetBoundActionInfo('TR_RevealKeys')
				if bind.priorityLevel == 3050 then
					local reveal = lplr.PlayerGui:FindFirstChild('TR_Reveal')
					local button1 = reveal and reveal:FindFirstChild('Skip', true) or nil
					local button2 = reveal and reveal:FindFirstChild('Continue', true) or nil

					if button1 and button1:IsA('TextButton') and button2 and button2:IsA('TextButton') and realInput then
						firesignal(button1.Activated, realInput, 0)
						firesignal(button2.Activated, realInput, 0)
					end
				end

				task.wait(0.05)
			until not AutoSkip.Enabled
		end
	end,
	Tooltip = 'Automatically skip through all crate popups'
})