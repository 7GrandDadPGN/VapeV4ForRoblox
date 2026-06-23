local AutoPickup
local Lists = {}
local items = {}
local sortedpickups = {Guard = {}, Prisoner = {}, Criminal = {}}

local function AddPickup(obj)
	if obj:IsA('Model') and obj.Name ~= 'Model' and obj:GetAttribute('ToolName') then
		table.insert(items, {obj, obj.Name == 'TouchGiver'})
	end
end

AutoPickup = vape.Categories.Inventory:CreateModule({
	Name = 'AutoPickup',
	Function = function(callback)
		if callback then
			for _, obj in workspace:GetChildren() do
				task.spawn(AddPickup, obj)
			end

			for _, obj in workspace:QueryDescendants('Model > .TouchGiver') do
				task.spawn(AddPickup, obj)
			end

			AutoPickup:Clean(workspace.ChildAdded:Connect(AddPickup))
			AutoPickup:Clean(workspace.ChildRemoved:Connect(function(obj)
				for index, entry in items do
					if entry[1] == obj then
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
						for _, v in items do
							if v[1].PrimaryPart and (v[1].PrimaryPart.Position - localpos).Magnitude < 12 then
								local toolname = v[1]:GetAttribute('ToolName')
								if v[2] then
									local found = false
									for _, entry in sortedpickups[lplr.Team == teams.Guards and 'Guard' or (lplr.Team == teams.Criminals and 'Criminal' or 'Prisoner')] do
										if not backpack:FindFirstChild(entry) then
											found = toolname ~= entry
											break
										end
									end

									if found then
										continue
									end
								end

								if not backpack:FindFirstChild(toolname) then
									replicatedStorage.Remotes.GiverPressed:FireServer(v[1])
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

for _, v in {'Prisoner', 'Guard', 'Criminal'} do
	AutoPickup:CreateTextList({
		Name = v..' Pickups',
		Default = {v == 'Criminal' and '1/AK-47' or '1/MP5', '2/Remington 870'},
		Placeholder = 'priority/item',
		Function = function(list)
			table.clear(sortedpickups[v])
			for _, entry in list do
				local tab = entry:split('/')
				local ind = tonumber(tab[1])
				sortedpickups[v][ind or 999] = tab[2]
			end
		end
	})
end