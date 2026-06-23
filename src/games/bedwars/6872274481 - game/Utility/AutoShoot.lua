local shooting, old = false

local function getCrossbows()
	local crossbows = {}
	for i, v in store.inventory.hotbar do
		if v.item and v.item.itemType:find('crossbow') and i ~= (store.inventory.hotbarSlot + 1) then table.insert(crossbows, i - 1) end
	end
	return crossbows
end

vape.Categories.Utility:CreateModule({
	Name = 'AutoShoot',
	Function = function(callback)
		if callback then
			old = bedwars.ProjectileController.createLocalProjectile
			bedwars.ProjectileController.createLocalProjectile = function(...)
				local source, data, proj = ...
				if source and (proj == 'arrow' or proj == 'fireball') and not shooting then
					task.spawn(function()
						local bows = getCrossbows()
						if #bows > 0 then
							shooting = true
							task.wait(0.15)
							local selected = store.inventory.hotbarSlot
							for _, v in getCrossbows() do
								if hotbarSwitch(v) then
									task.wait(0.05)
									mouse1click()
									task.wait(0.05)
								end
							end
							hotbarSwitch(selected)
							shooting = false
						end
					end)
				end
				return old(...)
			end
		else
			bedwars.ProjectileController.createLocalProjectile = old
		end
	end,
	Tooltip = 'Automatically crossbow macro\'s'
})
