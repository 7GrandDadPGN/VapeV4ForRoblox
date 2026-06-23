local AutoCloudGrind

AutoCloudGrind = vape.Categories.Minigames:CreateModule({
	Name = 'AutoCloudGrind',
	Function = function(callback)
		if callback then
			repeat
				if bt.Variables.arena and bt.Variables.arena:GetAttribute('State') == 'Picking' then
					local doRun = true
					for _, v in bt.Variables.arena.Goon:GetChildren() do
						local drop = v.Value and v.Value:GetAttribute('Item_Drop')

						if drop and drop:find('FX ') and not bt.Variables.data.CardCollection[drop] then
							doRun = false
						end
					end

					if doRun then
						bt.Network.FireServer('CommitToMove', 'Run Away', nil, nil)
						task.wait(3)
					else
						workspace.Sounds.Money:Play()
						workspace.Sounds.Money.Ended:Wait()
					end
				end

				task.wait(0.05)
			until not AutoCloudGrind.Enabled
		end
	end,
	Tooltip = 'Automatically grind for SFX Cards from Cloudie (floor 51)'
})