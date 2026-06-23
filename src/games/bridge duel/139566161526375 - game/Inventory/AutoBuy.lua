local AutoBuy
local Sword
local Armor
local Upgrades
local NPCs = {}
local UpgradeToggles = {}
local Functions = {}
local Callbacks = {Functions}
local npctick = tick()

local function canBuy(item, currencytable, amount)
	return (currencytable[item.currency or 'Iron'] or 0) >= (item.cost * (amount or 1))
end

local function buyItem(item, itemTier, itemCategory, currencytable)
	notif('AutoBuy', 'Bought '..item.name, 3)
	task.spawn(function()
		bd.Blink.player_state.bedwars_buy_item.invoke({
			item = itemCategory or item.name,
			tier = itemTier
		})
	end)
	currencytable[item.currency or 'Iron'] -= item.cost
end

local function buyTier(category, currencytable)
	local nextItem, itemTier
	for i, v in category.tiers do
		if currencytable[v.name] then
			nextItem, nextTier = category.tiers[i + 1], i + 1
			break
		end
	end

	if nextItem and canBuy(nextItem, currencytable) then
		buyItem(nextItem, nextTier, category.name, currencytable)
	end
end

local function buyUpgrade(upgrade, currencytable)
	local upgradeItem = bd.BedwarsUpgrades[upgrade]
	local localTeam = bd.Entity.LocalEntity.Team or {Name = ''}
	local teamUpgrades = bd.Communication.team_upgrades.value[localTeam.Name] or {}
	local currentTier = (teamUpgrades[upgrade] or 0) + 1
	local bought = false

	for i = currentTier, #upgradeItem.tiers do
		local tier = upgradeItem.tiers[i]

		if canBuy({currency = 'Diamond', cost = tier.cost}, currencytable) then
			notif('AutoBuy', 'Bought '..upgrade..' '..i, 3)
			task.spawn(function()
				bd.Blink.player_state.bedwars_buy_upgrade.invoke(upgrade)
			end)
			currencytable.Diamond -= tier.cost
			bought = true
		else
			break
		end
	end

	return bought
end

local function getShopNPC()
	local shop, items, upgrades, newid = nil, false, false, nil
	if entitylib.isAlive then
		local localPosition = entitylib.character.RootPart.Position
		for ent, upgrade in NPCs do
			if (ent.Position - localPosition).Magnitude <= 10 then
				shop = true
				items = items or not upgrade
				upgrades = upgrade or upgrades
			end
		end
	end
	return shop, items, upgrades
end

AutoBuy = vape.Categories.Inventory:CreateModule({
	Name = 'AutoBuy',
	Function = function(callback)
		if callback then
			AutoBuy:Clean(collectionService:GetInstanceAddedSignal('menu_opener'):Connect(function(obj)
				NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
			end))

			for _, obj in collectionService:GetTagged('menu_opener') do
				NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
			end

			repeat
				local npc, shop, upgrades, newid = getShopNPC()

				if npc and npctick <= tick() then
					local currencytable = table.clone(bd.Entity.LocalEntity.Inventory)
					for _, tab in Callbacks do
						for _, callback in tab do
							callback(currencytable, shop, upgrades)
						end
					end
					npctick = tick() + 0.4
				end

				task.wait(0.1)
			until not AutoBuy.Enabled
		else
			table.clear(NPCs)
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
			buyTier(bd.BedwarsShop[2].items[1], currencytable)
		end or nil
	end,
	Default = true
})
Armor = AutoBuy:CreateToggle({
	Name = 'Buy Armor',
	Function = function(callback)
		npctick = tick()
		Functions[1] = callback and function(currencytable, shop)
			if not shop then return end
			buyTier(bd.BedwarsShop[2].items[2], currencytable)
		end or nil
	end,
	Default = true
})
Pickaxe = AutoBuy:CreateToggle({
	Name = 'Buy Pickaxe',
	Function = function(callback)
		npctick = tick()
		Functions[1] = callback and function(currencytable, shop)
			if not shop then return end
			buyTier(bd.BedwarsShop[3].items[1], currencytable)
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
for i, v in bd.BedwarsUpgrades do
	local toggleCount = count
	table.insert(UpgradeToggles, AutoBuy:CreateToggle({
		Name = 'Buy '..i,
		Function = function(callback)
			npctick = tick()
			Functions[5 + toggleCount + (i == 'ArmorProtection' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
				if not upgrades then return end
				return buyUpgrade(i, currencytable)
			end or nil
		end,
		Darker = true,
		Default = (i == 'ArmorProtection' or i == 'SwordDamage')
	}))
	count += 1
end
--[[for i, v in bedwars.TeamUpgradeMeta do
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
end]]