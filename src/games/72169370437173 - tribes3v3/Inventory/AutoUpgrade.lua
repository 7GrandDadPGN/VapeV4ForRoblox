local AutoUpgrade

AutoUpgrade = vape.Categories.Inventory:CreateModule({
	Name = 'AutoUpgrade',
	Function = function(callback)
		if callback then
			repeat
				local gui = lplr.PlayerGui:FindFirstChild('TR_Menus')
				gui = gui and gui:FindFirstChild('Collection', true) or nil--.TR_Menus.Canvas.Collection

				if gui and gui:IsA('Frame') then
					local holder = gui:FindFirstChild('Grid', true)

					if holder and holder:IsA('ScrollingFrame') then
						for _, button in holder:GetChildren() do
							if button:IsA('TextButton') then
								local upgrade = button:FindFirstChild('Upgrade', true)

								if upgrade and upgrade:IsA('TextButton') and upgrade.Visible then
									firesignal(upgrade.Activated)
									break
								end
							end
						end
					end
				end
				--[[if (not isMatch) and (not lplr:GetAttribute('MatchId') or lplr:GetAttribute('MatchId') == '') then
					local item = tribes.Economy.ReadyList()[1]
					if item then
						tribes.Economy.Upgrade(item, 'collection')
					end
				end]]

				task.wait(0.05)
			until not AutoUpgrade.Enabled
		end
	end,
	Tooltip = 'Automatically upgrade all collectable gear.'
})