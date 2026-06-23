local AutoBuy
local Sword
local Armor
local Pickaxe
local Upgrades
local UpgradeObjects = {}
local Functions = {}

local function buyCheck(currencytable)
	for _, v in Functions do
		v(currencytable)
	end
end

local function buyUpgrade(name, upgrade, currencytable)
	local currentitem
	for shopIndex, shopItem in upgrade.Items do
		if shopItem.ItemType == name then
			currentitem = shopIndex
		end
	end

	if not currentitem then return end

	for i = currentitem + 1, #upgrade.Items do
		local nextitem = upgrade.Items[i]
		if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
			skywars.Remotes[remotes.purchaseItemUpgrade]:fire('Blacksmith', upgrade.ItemIndex)
			currencytable[nextitem.CurrencyType] -= nextitem.Price
		end
	end
end

local function buyTeamUpgrade(upgrade, currencytable)
	local currentitem = skywars.Store:getState().TeamUpgrades[upgrade.Name] or 0
	for i = currentitem + 1, #upgrade.Tiers do
		local nextitem = upgrade.Tiers[i]
		if nextitem and currencytable[nextitem.CurrencyType] >= nextitem.Price then
			skywars.Remotes[remotes.purchaseTeamUpgrade]:fire('Merchant', upgrade.ItemIndex)
			currencytable[nextitem.CurrencyType] -= nextitem.Price
		end
	end
end

AutoBuy = vape.Categories.Inventory:CreateModule({
	Name = 'AutoBuy',
	Function = function(callback)
		if callback then
			AutoBuy:Clean(vapeEvents.CurrencyChange.Event:Connect(buyCheck))
			buyCheck(table.clone(skywars.Store:getState().GameCurrency.Quantities))
		end
	end,
	Tooltip = 'Automatically buys items when you go near the shop'
})
Sword = AutoBuy:CreateToggle({
	Name = 'Buy Sword',
	Function = function(callback)
		Functions[2] = callback and function(currencytable, shop, upgrades)
			buyUpgrade(store.tools.sword and store.tools.sword.Name, skywars.Shop.Blacksmith.ItemUpgrades[2], currencytable)
		end or nil
	end,
	Default = true
})
Armor = AutoBuy:CreateToggle({
	Name = 'Buy Armor',
	Function = function(callback)
		Functions[1] = callback and function(currencytable, shop, upgrades)
			if lplr.Character then
				for _, v in lplr.Character:GetChildren() do
					if v:GetAttribute('Armour') and v.Name:find('Chestplate') then
						buyUpgrade(v.Name, skywars.Shop.Blacksmith.ItemUpgrades[1], currencytable)
						break
					end
				end
			end
		end or nil
	end,
	Default = true
})
Pickaxe = AutoBuy:CreateToggle({
	Name = 'Buy Pickaxe',
	Function = function(callback)
		Functions[3] = callback and function(currencytable, shop, upgrades)
			buyUpgrade(store.tools.pickaxe and store.tools.pickaxe.Name, skywars.Shop.Blacksmith.ItemUpgrades[3], currencytable)
		end or nil
	end,
	Default = true
})
Upgrades = AutoBuy:CreateToggle({
	Name = 'Buy Upgrades',
	Function = function(callback)
		for i, v in UpgradeObjects do
			v.Object.Visible = callback
		end
	end,
	Default = true
})
for i, v in skywars.Shop.Merchant.TeamUpgrades do
	table.insert(UpgradeObjects, AutoBuy:CreateToggle({
		Name = 'Buy '..v.Name,
		Function = function(callback)
			Functions[4 + i] = callback and function(currencytable, shop, upgrades)
				buyTeamUpgrade(v, currencytable)
			end or nil
		end,
		Darker = true,
		Default = (v.Name == 'Generator' or v.Name == 'Vampyrism')
	}))
end