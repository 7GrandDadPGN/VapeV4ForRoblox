local AutoHeal

AutoHeal = vape.Categories.Inventory:CreateModule({
	Name = 'AutoHeal',
	Function = function(callback)
		if callback then
			repeat
				local entity = entitylib.isAlive and entitylib.character
				local donut = InvTracker.Inventories[lplr].Donut

				if donut and entity and entity.Humanoid.Health <= 70 then
					jb:FireServer('Donut')
				end

				task.wait(0.05)
			until not AutoHeal.Enabled
		end
	end,
	Tooltip = 'Automatically heal damage with consumables.'
})