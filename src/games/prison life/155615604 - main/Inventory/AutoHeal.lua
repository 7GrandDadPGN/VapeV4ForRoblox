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
				local ent = entitylib.isAlive and entitylib.character
				if ent and ent.Humanoid.Health <= 85 then
					local healTool
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')
					if backpack then
						for _, v in backpack:GetChildren() do
							if healItems[v.Name] then
								healTool = v
							end
						end

						if healTool and (os.clock() - (healTool:GetAttribute('Client_LastConsumedAt') or 0)) >= 3 then
							local equipped = ent.Character:FindFirstChildWhichIsA('Tool')
							if equipped then
								equipped.Parent = backpack
							end

							healTool.Parent = ent.Character
							healTool:SetAttribute('Quantity', healTool:GetAttribute('Quantity') - 1)
							healTool:SetAttribute('Client_LastConsumedAt', os.clock())
							notif('AutoHeal', 'Quantity: '..healTool:GetAttribute('Quantity'), 3)
							replicatedStorage.Remotes.EatFood:FireServer()
							healTool.Parent = backpack

							if equipped then
								equipped.Parent = ent.Character
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