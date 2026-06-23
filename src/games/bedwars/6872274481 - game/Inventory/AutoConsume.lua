local AutoConsume
local Health
local SpeedPotion
local Apple
local ShieldPotion

local function consumeCheck(attribute)
	if entitylib.isAlive then
		if SpeedPotion.Enabled and (not attribute or attribute == 'StatusEffect_speed') then
			local speedpotion = getItem('speed_potion')
			if speedpotion and (not lplr.Character:GetAttribute('StatusEffect_speed')) then
				for _ = 1, 4 do
					if bedwars.Client:Get(remotes.ConsumeItem):CallServer({item = speedpotion.tool}) then break end
				end
			end
		end

		if Apple.Enabled and (not attribute or attribute:find('Health')) then
			if (lplr.Character:GetAttribute('Health') / lplr.Character:GetAttribute('MaxHealth')) <= (Health.Value / 100) then
				local apple = getItem('orange') or (not lplr.Character:GetAttribute('StatusEffect_golden_apple') and getItem('golden_apple')) or getItem('apple')
				
				if apple then
					bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
						item = apple.tool
					})
				end
			end
		end

		if ShieldPotion.Enabled and (not attribute or attribute:find('Shield')) then
			if (lplr.Character:GetAttribute('Shield_POTION') or 0) == 0 then
				local shield = getItem('big_shield') or getItem('mini_shield')

				if shield then
					bedwars.Client:Get(remotes.ConsumeItem):CallServerAsync({
						item = shield.tool
					})
				end
			end
		end
	end
end

AutoConsume = vape.Categories.Inventory:CreateModule({
	Name = 'AutoConsume',
	Function = function(callback)
		if callback then
			AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
			AutoConsume:Clean(vapeEvents.AttributeChanged.Event:Connect(function(attribute)
				if attribute:find('Shield') or attribute:find('Health') or attribute == 'StatusEffect_speed' then
					consumeCheck(attribute)
				end
			end))
			consumeCheck()
		end
	end,
	Tooltip = 'Automatically heals for you when health or shield is under threshold.'
})
Health = AutoConsume:CreateSlider({
	Name = 'Health Percent',
	Min = 1,
	Max = 99,
	Default = 70,
	Suffix = '%'
})
SpeedPotion = AutoConsume:CreateToggle({
	Name = 'Speed Potions',
	Default = true
})
Apple = AutoConsume:CreateToggle({
	Name = 'Apple',
	Default = true
})
ShieldPotion = AutoConsume:CreateToggle({
	Name = 'Shield Potions',
	Default = true
})