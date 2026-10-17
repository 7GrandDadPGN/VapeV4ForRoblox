local AutoUpgrade

AutoUpgrade = vape.Categories.Inventory:CreateModule({
	Name = 'AutoUpgrade',
	Function = function(callback)
		if callback then
			repeat
				if (not lplr:GetAttribute('MatchId') or lplr:GetAttribute('MatchId') == '') then
					local item = tribes.Economy.ReadyList()[1]
					if item then
						tribes.Economy.Upgrade(item)
					end
				end

				task.wait(0.05)
			until not AutoUpgrade.Enabled
		end
	end,
	Tooltip = 'Automatically upgrade all collectable gear.'
})