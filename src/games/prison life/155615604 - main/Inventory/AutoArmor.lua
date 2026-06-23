local AutoArmor
local pickups = {}

AutoArmor = vape.Categories.Inventory:CreateModule({
	Name = 'AutoArmor',
	Function = function(callback)
		if callback then
			pickups = workspace.Prison_ITEMS.clothes:GetChildren()

			AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildAdded:Connect(function(obj)
				table.insert(pickups, obj)
			end))

			AutoArmor:Clean(workspace.Prison_ITEMS.clothes.ChildRemoved:Connect(function(obj)
				local index = table.find(pickups, obj)
				if index then
					table.remove(pickups, index)
				end
			end))

			repeat
				if entitylib.isAlive and entitylib.character.Humanoid.MaxHealth <= 100 then
					local localpos = entitylib.character.RootPart.Position

					for _, v in pickups do
						if (v:GetPivot().Position - localpos).Magnitude < 10 and gamepasses[v:GetAttribute('RequiredGamepass')] and AutoArmor.Enabled then
							if v.Name == 'Light Vest' and gamepasses[lplr.Team == teams.Criminals and 'Mafia' or 'Riot Police'] then
								continue
							end

							replicatedStorage.Remotes.InteractWithItem:InvokeServer(v:FindFirstChildWhichIsA('BasePart'))
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