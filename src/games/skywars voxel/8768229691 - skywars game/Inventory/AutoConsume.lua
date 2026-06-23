local AutoConsume

local function consumeCheck()
	if (lplr:GetAttribute('Shield') or 0) <= 0 and getItem('Shield') then
		skywars.Remotes[remotes.updateActiveItem]:fire('Shield')
		skywars.Remotes[remotes.usePowerUp]:fire()
		skywars.Remotes[remotes.updateActiveItem]:fire(store.hand.Name)
	end
end

AutoConsume = vape.Categories.Inventory:CreateModule({
	Name = 'AutoConsume',
	Function = function(callback)
		if callback then
			AutoConsume:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(consumeCheck))
			AutoConsume:Clean(lplr:GetAttributeChangedSignal('Shield'):Connect(consumeCheck))
			consumeCheck()
		end
	end,
	Tooltip = 'Automatically uses shield potions.'
})