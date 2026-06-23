local AutoBuy
local Sword
local Armor
local Upgrades
local TierCheck
local BedwarsCheck
local GUI
local SmartCheck
local Custom = {}
local CustomPost = {}
local UpgradeToggles = {}
local Functions, id = {}
local Callbacks = {Custom, Functions, CustomPost}
local npctick = tick()

local swords = {
	'wood_sword',
	'stone_sword',
	'iron_sword',
	'diamond_sword',
	'emerald_sword'
}

local armors = {
	'none',
	'leather_chestplate',
	'iron_chestplate',
	'diamond_chestplate',
	'emerald_chestplate'
}

local axes = {
	'none',
	'wood_axe',
	'stone_axe',
	'iron_axe',
	'diamond_axe'
}

local pickaxes = {
	'none',
	'wood_pickaxe',
	'stone_pickaxe',
	'iron_pickaxe',
	'diamond_pickaxe'
}

local function getShopNPC()
	local shop, items, upgrades, newid = nil, false, false, nil
	if entitylib.isAlive then
		local localPosition = entitylib.character.RootPart.Position
		for _, v in store.shop do
			if (v.RootPart.Position - localPosition).Magnitude <= 20 then
				shop = v.Upgrades or v.Shop or nil
				upgrades = upgrades or v.Upgrades
				items = items or v.Shop
				newid = v.Shop and v.Id or newid
			end
		end
	end
	return shop, items, upgrades, newid
end

local function canBuy(item, currencytable, amount)
	amount = amount or 1
	if not currencytable[item.currency] then
		local currency = getItem(item.currency)
		currencytable[item.currency] = currency and currency.amount or 0
	end
	if item.ignoredByKit and table.find(item.ignoredByKit, store.equippedKit or '') then return false end
	if item.lockedByForge or item.disabled then return false end
	if item.require and item.require.teamUpgrade then
		if (bedwars.Store:getState().Bedwars.teamUpgrades[item.require.teamUpgrade.upgradeId] or -1) < item.require.teamUpgrade.lowestTierIndex then
			return false
		end
	end
	return currencytable[item.currency] >= (item.price * amount)
end

local function buyItem(item, currencytable)
	if not id then return end
	notif('AutoBuy', 'Bought '..bedwars.ItemMeta[item.itemType].displayName, 3)
	bedwars.Client:Get('BedwarsPurchaseItem'):CallServerAsync({
		shopItem = item,
		shopId = id
	}):andThen(function(suc)
		if suc then
			bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
			bedwars.Store:dispatch({
				type = 'BedwarsAddItemPurchased',
				itemType = item.itemType
			})
			bedwars.BedwarsShopController.alreadyPurchasedMap[item.itemType] = true
		end
	end)
	currencytable[item.currency] -= item.price
end

local function buyUpgrade(upgradeType, currencytable)
	if not Upgrades.Enabled then return end
	local upgrade = bedwars.TeamUpgradeMeta[upgradeType]
	local currentUpgrades = bedwars.Store:getState().Bedwars.teamUpgrades[lplr:GetAttribute('Team')] or {}
	local currentTier = (currentUpgrades[upgradeType] or 0) + 1
	local bought = false

	for i = currentTier, #upgrade.tiers do
		local tier = upgrade.tiers[i]
		if tier.availableOnlyInQueue and not table.find(tier.availableOnlyInQueue, store.queueType) then continue end

		if canBuy({currency = 'diamond', price = tier.cost}, currencytable) then
			notif('AutoBuy', 'Bought '..(upgrade.name == 'Armor' and 'Protection' or upgrade.name)..' '..i, 3)
			bedwars.Client:Get('RequestPurchaseTeamUpgrade'):CallServerAsync(upgradeType)
			currencytable.diamond -= tier.cost
			bought = true
		else
			break
		end
	end

	return bought
end

local function buyTool(tool, tools, currencytable)
	local bought, buyable = false
	tool = tool and table.find(tools, tool.itemType) and table.find(tools, tool.itemType) + 1 or math.huge

	for i = tool, #tools do
		local v = bedwars.Shop.getShopItem(tools[i], lplr)
		if canBuy(v, currencytable) then
			if SmartCheck.Enabled and bedwars.ItemMeta[tools[i]].breakBlock and i > 2 then
				if Armor.Enabled then
					local currentarmor = store.inventory.inventory.armor[2]
					currentarmor = currentarmor and currentarmor ~= 'empty' and currentarmor.itemType or 'none'
					if (table.find(armors, currentarmor) or 3) < 3 then break end
				end
				if Sword.Enabled then
					if store.tools.sword and (table.find(swords, store.tools.sword.itemType) or 2) < 2 then break end
				end
			end
			bought = true
			buyable = v
		end
		if TierCheck.Enabled and v.nextTier then break end
	end

	if buyable then
		buyItem(buyable, currencytable)
	end

	return bought
end

AutoBuy = vape.Categories.Inventory:CreateModule({
	Name = 'AutoBuy',
	Function = function(callback)
		if callback then
			repeat task.wait() until store.queueType ~= 'bedwars_test'
			if BedwarsCheck.Enabled and not store.queueType:find('bedwars') then return end

			local lastupgrades
			AutoBuy:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(function()
				if (npctick - tick()) > 1 then npctick = tick() end
			end))

			repeat
				local npc, shop, upgrades, newid = getShopNPC()
				id = newid
				if GUI.Enabled then
					if not (bedwars.AppController:isAppOpen('BedwarsItemShopApp') or bedwars.AppController:isAppOpen('TeamUpgradeApp')) then
						npc = nil
					end
				end

				if npc and lastupgrades ~= upgrades then
					if (npctick - tick()) > 1 then npctick = tick() end
					lastupgrades = upgrades
				end

				if npc and npctick <= tick() and store.matchState ~= 2 and store.shopLoaded then
					local currencytable = {}
					local waitcheck
					for _, tab in Callbacks do
						for _, callback in tab do
							if callback(currencytable, shop, upgrades) then
								waitcheck = true
							end
						end
					end
					npctick = tick() + (waitcheck and 0.4 or math.huge)
				end

				task.wait(0.1)
			until not AutoBuy.Enabled
		else
			npctick = tick()
		end
	end,
	Tooltip = 'Automatically buys items when you go near the shop'
})
Sword = AutoBuy:CreateToggle({
	Name = 'Buy Sword',
	Function = function(callback)
		npctick = tick()
		Functions[2] = callback and function(currencytable, shop)
			if not shop then return end

			if store.equippedKit == 'dasher' then
				swords = {
					[1] = 'wood_dao',
					[2] = 'stone_dao',
					[3] = 'iron_dao',
					[4] = 'diamond_dao',
					[5] = 'emerald_dao'
				}
			elseif store.equippedKit == 'ice_queen' then
				swords[5] = 'ice_sword'
			elseif store.equippedKit == 'ember' then
				swords[5] = 'infernal_saber'
			elseif store.equippedKit == 'lumen' then
				swords[5] = 'light_sword'
			end

			return buyTool(store.tools.sword, swords, currencytable)
		end or nil
	end
})
Armor = AutoBuy:CreateToggle({
	Name = 'Buy Armor',
	Function = function(callback)
		npctick = tick()
		Functions[1] = callback and function(currencytable, shop)
			if not shop then return end
			local currentarmor = store.inventory.inventory.armor[2] ~= 'empty' and store.inventory.inventory.armor[2] or getBestArmor(1)
			currentarmor = currentarmor and currentarmor.itemType or 'none'
			return buyTool({itemType = currentarmor}, armors, currencytable)
		end or nil
	end,
	Default = true
})
AutoBuy:CreateToggle({
	Name = 'Buy Axe',
	Function = function(callback)
		npctick = tick()
		Functions[3] = callback and function(currencytable, shop)
			if not shop then return end
			return buyTool(store.tools.wood or {itemType = 'none'}, axes, currencytable)
		end or nil
	end
})
AutoBuy:CreateToggle({
	Name = 'Buy Pickaxe',
	Function = function(callback)
		npctick = tick()
		Functions[4] = callback and function(currencytable, shop)
			if not shop then return end
			return buyTool(store.tools.stone, pickaxes, currencytable)
		end or nil
	end
})
Upgrades = AutoBuy:CreateToggle({
	Name = 'Buy Upgrades',
	Function = function(callback)
		for _, v in UpgradeToggles do
			v.Object.Visible = callback
		end
	end,
	Default = true
})
local count = 0
for i, v in bedwars.TeamUpgradeMeta do
	local toggleCount = count
	table.insert(UpgradeToggles, AutoBuy:CreateToggle({
		Name = 'Buy '..(v.name == 'Armor' and 'Protection' or v.name),
		Function = function(callback)
			npctick = tick()
			Functions[5 + toggleCount + (v.name == 'Armor' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
				if not upgrades then return end
				if v.disabledInQueue and table.find(v.disabledInQueue, store.queueType) then return end
				return buyUpgrade(i, currencytable)
			end or nil
		end,
		Darker = true,
		Default = (i == 'ARMOR' or i == 'DAMAGE')
	}))
	count += 1
end
TierCheck = AutoBuy:CreateToggle({Name = 'Tier Check'})
BedwarsCheck = AutoBuy:CreateToggle({
	Name = 'Only Bedwars',
	Function = function()
		if AutoBuy.Enabled then
			AutoBuy:Toggle()
			AutoBuy:Toggle()
		end
	end,
	Default = true
})
GUI = AutoBuy:CreateToggle({Name = 'GUI check'})
SmartCheck = AutoBuy:CreateToggle({
	Name = 'Smart check',
	Default = true,
	Tooltip = 'Buys iron armor before iron axe'
})
AutoBuy:CreateTextList({
	Name = 'Item',
	Placeholder = 'priority/item/amount/after',
	Function = function(list)
		table.clear(Custom)
		table.clear(CustomPost)
		for _, entry in list do
			local tab = entry:split('/')
			local ind = tonumber(tab[1])
			if ind then
				(tab[4] and CustomPost or Custom)[ind] = function(currencytable, shop)
					if not shop then return end

					local v = bedwars.Shop.getShopItem(tab[2], lplr)
					if v then
						local item = getItem(tab[2] == 'wool_white' and bedwars.Shop.getTeamWool(lplr:GetAttribute('Team')) or tab[2])
						item = (item and tonumber(tab[3]) - item.amount or tonumber(tab[3])) // v.amount
						if item > 0 and canBuy(v, currencytable, item) then
							for _ = 1, item do
								buyItem(v, currencytable)
							end
							return true
						end
					end
				end
			end
		end
	end
})