local AutoPickup
local items = {}
local PickupList = {}

local function AddPickup(pickup)
	if pickup:IsA('Model') and pickup.Name ~= 'Model' and pickup:GetAttribute('ToolName') then
		table.insert(items, {
			pickup,
			pickup.Name == 'TouchGiver'
		})
	end
end

local function hasTool(name, backpack)
	local tool = lplr.Character:FindFirstChildWhichIsA('Tool')
	return backpack:FindFirstChild(name) or tool and tool.Name == name and tool
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
								if hasTool(tool, backpack) then
									continue
								end

								if pickup[2] and not table.find(PickupList[lplr.Team == teams.Guards and 'Guard' or (lplr.Team == teams.Criminals and 'Criminal' or 'Prisoner')].ListEnabled, tool) then
									continue
								end

								replicatedStorage.Remotes.GiverPressed:FireServer(pickup[1])
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
	PickupList[team] = AutoPickup:CreateTextList({
		Name = team,
		Default = {team == 'Criminal' and 'AK-47' or 'MP5', 'Remington 870'},
		Placeholder = 'item'
	})
end