local AutoUpgrade

AutoUpgrade = vape.Categories.Inventory:CreateModule({
	Name = 'AutoUpgrade',
	Function = function(callback)
		if callback then
			dumpInput()

			repeat
				local gui = lplr.PlayerGui:FindFirstChild('TR_Menus')
				gui = gui and gui:FindFirstChild('Collection', true) or nil

				if gui and gui:IsA('Frame') then
					local holder = gui:FindFirstChild('Grid', true)

					if holder and holder:IsA('ScrollingFrame') then
						for _, button in holder:GetChildren() do
							if button:IsA('TextButton') then
								local upgrade = button:FindFirstChild('Upgrade', true)

								if upgrade and upgrade:IsA('TextButton') and upgrade.Visible and realInput then
									firesignal(upgrade.Activated, realInput, 0)
									break
								end
							end
						end
					end
				end

				task.wait(0.05)
			until not AutoUpgrade.Enabled
		end
	end,
	Tooltip = 'Automatically upgrade all collectable gear.'
})