vape.Legit:CreateModule({
	Name = 'Clean Kit',
	Function = function(callback)
		if callback then
			bedwars.WindWalkerController.spawnOrb = function() end
			local zephyreffect = lplr.PlayerGui:FindFirstChild('WindWalkerEffect', true)
			if zephyreffect then 
				zephyreffect.Visible = false 
			end
		end
	end,
	Tooltip = 'Removes zephyr status indicator'
})