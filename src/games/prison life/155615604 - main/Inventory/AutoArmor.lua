local AutoArmor
local pickups = {}

AutoArmor = vape.Categories.Inventory:CreateModule({
	Name = 'AutoArmor',
	Function = function(callback)
		if callback then
			pickups = workspace.Prison_ITEMS.clothes:GetChildren()

			AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildAdded:Connect(function(pickup)
				table.insert(pickups, pickup)
			end))

			AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildRemoved:Connect(function(pickup)
				local index = table.find(pickups, pickup)
				if index then
					table.remove(pickups, index)
				end
			end))

			repeat
				if entitylib.isAlive and entitylib.character.Humanoid.MaxHealth <= 100 then
					local localpos = entitylib.character.RootPart.Position

					for _, pickup in pickups do
						if (pickup:GetPivot().Position - localpos).Magnitude < 10 and gamepasses[pickup:GetAttribute('RequiredGamepass')] and AutoArmor.Enabled then
							if pickup.Name == 'Light Vest' and gamepasses[lplr.Team == teams.Criminals and 'Mafia' or 'Riot Police'] then
								continue
							end

							replicatedStorage.Remotes.InteractWithItem:InvokeServer(pickup:FindFirstChildWhichIsA('BasePart'))
						end
					end
				end

				task.wait(0.05)
			until not AutoArmor.Enabled
		else
			table.clear(pickups)
		end
	end,
	Tooltip = 'Automatically equip armor from the wall.'
})