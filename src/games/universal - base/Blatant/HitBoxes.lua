local HitBoxes
local Targets
local TargetPart
local Expand
local modified = {}

HitBoxes = vape.Categories.Blatant:CreateModule({
	Name = 'HitBoxes',
	Function = function(callback)
		if callback then
			repeat
				for _, entity in entitylib.List do
					if entity.Targetable then
						if not Targets.Players.Enabled and entity.Player then continue end
						if not Targets.NPCs.Enabled and entity.NPC then continue end
						local part = entity[TargetPart.Value]
						if not modified[part] then
							modified[part] = part.Size
						end

						part.Size = modified[part] + Vector3.new(Expand.Value, Expand.Value, Expand.Value)
					end
				end

				task.wait()
			until not HitBoxes.Enabled
		else
			for part, value in modified do
				part.Size = value
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Expands entities hitboxes'
})
Targets = HitBoxes:CreateTargets({
	Players = true
})
TargetPart = HitBoxes:CreateDropdown({
	Name = 'Part',
	List = {'RootPart', 'Head'}
})
Expand = HitBoxes:CreateSlider({
	Name = 'Expand amount',
	Min = 0,
	Max = 2,
	Decimal = 10,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})