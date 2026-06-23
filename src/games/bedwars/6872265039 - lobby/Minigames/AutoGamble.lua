local AutoGamble

AutoGamble = vape.Categories.Minigames:CreateModule({
	Name = 'AutoGamble',
	Function = function(callback)
		if callback then
			AutoGamble:Clean(bedwars.Client:GetNamespace('RewardCrate'):Get('CrateOpened'):Connect(function(data)
				if data.openingPlayer == lplr then
					local tab = bedwars.CrateItemMeta[data.reward.itemType] or {displayName = data.reward.itemType or 'unknown'}
					notif('AutoGamble', 'Won '..tab.displayName, 5)
				end
			end))

			repeat
				if not bedwars.CrateAltarController.activeCrates[1] then
					for _, v in bedwars.Store:getState().Consumable.inventory do
						if v.consumable:find('crate') then
							bedwars.CrateAltarController:pickCrate(v.consumable, 1)
							task.wait(1.2)
							if bedwars.CrateAltarController.activeCrates[1] and bedwars.CrateAltarController.activeCrates[1][2] then
								bedwars.Client:GetNamespace('RewardCrate'):Get('OpenRewardCrate'):SendToServer({
									crateId = bedwars.CrateAltarController.activeCrates[1][2].attributes.crateId
								})
							end
							break
						end
					end
				end
				task.wait(1)
			until not AutoGamble.Enabled
		end
	end,
	Tooltip = 'Automatically opens lucky crates, piston inspired!'
})