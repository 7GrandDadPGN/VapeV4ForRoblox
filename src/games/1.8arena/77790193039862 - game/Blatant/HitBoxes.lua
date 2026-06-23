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
				for _, v in entitylib.List do
					if v.Targetable then
						if not Targets.Players.Enabled and v.Player then continue end
						if not Targets.NPCs.Enabled and v.NPC then continue end
						local part = v.Hitbox
						if not modified[part] then
							modified[part] = part.Size
						end

						part.Size = modified[part] + Vector3.new(Expand.Value, Expand.Value, Expand.Value)
					end
				end

				task.wait()
			until not HitBoxes.Enabled
		else
			for i, v in modified do
				i.Size = v
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Expands entities hitboxes'
})
Targets = HitBoxes:CreateTargets({Players = true})
Expand = HitBoxes:CreateSlider({
	Name = 'Expand amount',
	Min = 0,
	Max = 6,
	Decimal = 10,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})