local Reach
local Targets
local Mode
local Value
local Chance
local Overlay = OverlapParams.new()
Overlay.FilterType = Enum.RaycastFilterType.Include
local modified = {}

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
			repeat
				local tool = getTool()
				tool = tool and tool:FindFirstChildWhichIsA('TouchTransmitter', true)
				if tool then
					if Mode.Value == 'TouchInterest' then
						local entites = {}
						for _, v in entitylib.List do
							if v.Targetable then
								if not Targets.Players.Enabled and v.Player then continue end
								if not Targets.NPCs.Enabled and v.NPC then continue end
								table.insert(entites, v.Character)
							end
						end

						Overlay.FilterDescendantsInstances = entites
						local parts = workspace:GetPartBoundsInBox(tool.Parent.CFrame * CFrame.new(0, 0, Value.Value / 2), tool.Parent.Size + Vector3.new(0, 0, Value.Value), Overlay)

						for _, v in parts do
							if Random.new().NextNumber(Random.new(), 0, 100) > Chance.Value then
								task.wait(0.2)
								break
							end

							firetouchinterest(tool.Parent, v, 1)
							firetouchinterest(tool.Parent, v, 0)
						end
					else
						if not modified[tool.Parent] then
							modified[tool.Parent] = tool.Parent.Size
						end

						tool.Parent.Size = modified[tool.Parent] + Vector3.new(0, 0, Value.Value)
						tool.Parent.Massless = true
					end
				end

				task.wait()
			until not Reach.Enabled
		else
			for i, v in modified do
				i.Size = v
				i.Massless = false
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Extends tool attack reach'
})
Targets = Reach:CreateTargets({Players = true})
Mode = Reach:CreateDropdown({
	Name = 'Mode',
	List = {'TouchInterest', 'Resize'},
	Function = function(val)
		Chance.Object.Visible = val == 'TouchInterest'
	end,
	Tooltip = 'TouchInterest - Reports fake collision events to the server\nResize - Physically modifies the tools size'
})
Value = Reach:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 2,
	Decimal = 10,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Chance = Reach:CreateSlider({
	Name = 'Chance',
	Min = 0,
	Max = 100,
	Default = 100,
	Suffix = '%'
})