local ShopTierBypass
local tiered, nexttier = {}, {}

ShopTierBypass = vape.Categories.Utility:CreateModule({
	Name = 'ShopTierBypass',
	Function = function(callback)
		if callback then
			repeat task.wait() until store.shopLoaded or not ShopTierBypass.Enabled
			if ShopTierBypass.Enabled then
				for _, v in bedwars.Shop.ShopItems do
					tiered[v] = v.tiered
					nexttier[v] = v.nextTier
					v.nextTier = nil
					v.tiered = nil
				end
			end
		else
			for i, v in tiered do
				i.tiered = v
			end
			for i, v in nexttier do
				i.nextTier = v
			end
			table.clear(nexttier)
			table.clear(tiered)
		end
	end,
	Tooltip = 'Lets you buy things like armor early.'
})