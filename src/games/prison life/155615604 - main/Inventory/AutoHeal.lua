local AutoHeal
local healItems = {
	Breakfast = true,
	Lunch = true,
	Dinner = true
}

AutoHeal = vape.Categories.Inventory:CreateModule({
	Name = 'AutoHeal',
	Function = function(callback)
		if callback then
			repeat
				local entity = entitylib.isAlive and entitylib.character
				if entity and entity.Humanoid.Health <= 85 then
					local healTool
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')
					if backpack then
						for _, tool in backpack:GetChildren() do
							if healItems[tool.Name] then
								healTool = tool
							end
						end

						if healTool and (os.clock() - (healTool:GetAttribute('Client_LastConsumedAt') or 0)) >= 3 then
							local lastEquip = entity.Character:FindFirstChildWhichIsA('Tool')
							entity.Humanoid:EquipTool(healTool)
							healTool:SetAttribute('Quantity', healTool:GetAttribute('Quantity') - 1)
							healTool:SetAttribute('Client_LastConsumedAt', os.clock())
							notif('AutoHeal', 'Quantity: '..healTool:GetAttribute('Quantity'), 3)
							replicatedStorage.Remotes.EatFood:FireServer()

							if lastEquip then
								entity.Humanoid:EquipTool(lastEquip)
							else
								entity.Humanoid:UnequipTools()
							end
						end
					end
				end

				task.wait(0.05)
			until not AutoHeal.Enabled
		end
	end,
	Tooltip = 'Automatically heal damage with consumables.'
})