local AutoPickup
local items = {}
local pickupList = {Guard = {}, Prisoner = {}, Criminal = {}}

local function AddPickup(pickup)
	if pickup:IsA('Model') and pickup.Name ~= 'Model' and pickup:GetAttribute('ToolName') then
		table.insert(items, {
			pickup,
			pickup.Name == 'TouchGiver'
		})
	end
end

AutoPickup = vape.Categories.Inventory:CreateModule({
	Name = 'AutoPickup',
	Function = function(callback)
		if callback then
			for _, pickup in workspace:GetChildren() do
				task.spawn(AddPickup, pickup)
			end

			for _, pickup in workspace:QueryDescendants('Model > .TouchGiver') do
				task.spawn(AddPickup, pickup)
			end

			AutoPickup:Clean(workspace.ChildAdded:Connect(AddPickup))
			AutoPickup:Clean(workspace.ChildRemoved:Connect(function(pickup)
				for index, data in items do
					if data[1] == pickup then
						table.remove(items, index)
						break
					end
				end
			end))

			repeat
				if entitylib.isAlive then
					local localpos = entitylib.character.RootPart.Position
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')

					if backpack then
						for _, pickup in items do
							if pickup[1].PrimaryPart and (pickup[1].PrimaryPart.Position - localpos).Magnitude < 12 then
								local tool = pickup[1]:GetAttribute('ToolName')
								if pickup[2] then
									local found = false
									for _, entry in pickupList[lplr.Team == teams.Guards and 'Guard' or (lplr.Team == teams.Criminals and 'Criminal' or 'Prisoner')] do
										if not backpack:FindFirstChild(entry) then
											found = tool ~= entry
											break
										end
									end

									if found then
										continue
									end
								end

								if not backpack:FindFirstChild(tool) then
									replicatedStorage.Remotes.GiverPressed:FireServer(pickup[1])
								end
							end
						end
					end
				end

				task.wait(0.05)
			until not AutoPickup.Enabled
		else
			table.clear(items)
		end
	end,
	Tooltip = 'Automatically grab item pickups'
})

for _, team in {'Prisoner', 'Guard', 'Criminal'} do
	AutoPickup:CreateTextList({
		Name = team..' Pickups',
		Default = {team == 'Criminal' and '1/AK-47' or '1/MP5', '2/Remington 870'},
		Placeholder = 'priority/item',
		Function = function(list)
			table.clear(pickupList[team])

			for _, entry in list do
				local data = entry:split('/')
				local index = tonumber(data[1])
				pickupList[team][index or 999] = data[2]
			end
		end
	})
end