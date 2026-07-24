local AutoBuy
local shops = {}
local requirements = {
	armor = {
		['Leather Armor'] = 'pickaxe_iron'
	},
	pickaxe = {
		['pickaxe_gold'] = 'Golden Armor',
		['pickaxe_diamond'] = 'Diamond Armor'
	}
}

local function buyCategory(ladder, default)
	local tierItems = {}
	for _, item in bw.ShopConfig.Items do
		if item.ladder == ladder then
			table.insert(tierItems, item)
		end
	end

	table.sort(tierItems, function(a, b)
		return (a.tier or -1) < (b.tier or -1)
	end)

	local nextTier = default and tierItems[1] or nil
	for _, item in tierItems do
		if bw.Inventory.items[item.id] then
			nextTier = tierItems[table.find(tierItems, item) + 1]
			break
		end
	end

	if nextTier then
		for index, item in {'Block', 'Gold', 'Diamond'} do
			if (nextTier.cost and nextTier.cost[item] or 0) > (bw.Inventory[index == 1 and 'blocks' or item:lower()] or 0) then
				return false
			end
		end

		if requirements[ladder] and requirements[ladder][nextTier.id] and not bw.Inventory.items[requirements[ladder][nextTier.id]] then
			return false
		end

		bw.RemoteIndex.Shop_Purchase:InvokeServer({itemId = nextTier.id})
		return true
	end

	return false
end

AutoBuy = vape.Categories.Inventory:CreateModule({
	Name = 'AutoBuy',
	Function = function(callback)
		if callback then
			shops = collection('BedWarsX_ShopNPC')

			repeat
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for _, shop in shops do
						if (shop.Position - localPosition).Magnitude < 20 then
							if buyCategory('armor', true) then break end
							if buyCategory('pickaxe') then break end
							if buyCategory('sword') then break end
							break
						end
					end
				end

				task.wait(0.2)
			until not AutoBuy.Enabled
		end
	end,
	Tooltip = 'lol'
})