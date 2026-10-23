local AutoSkip

AutoSkip = vape.Categories.Inventory:CreateModule({
	Name = 'AutoSkip',
	Function = function(callback)
		if callback then
			repeat
				local bind = contextActionService:GetBoundActionInfo('TR_RevealKeys')
				if bind.priorityLevel == 3050 and not guiService.MenuIsOpen then
					vim:SendKeyEvent(true, Enum.KeyCode.ButtonB, false, nil)
					vim:SendKeyEvent(false, Enum.KeyCode.ButtonB, false, nil)
					vim:SendKeyEvent(true, Enum.KeyCode.ButtonA, false, nil)
					vim:SendKeyEvent(false, Enum.KeyCode.ButtonA, false, nil)
				end

				task.wait(0.05)
			until not AutoSkip.Enabled
		end
	end,
	Tooltip = 'Automatically skip through all crate popups'
})