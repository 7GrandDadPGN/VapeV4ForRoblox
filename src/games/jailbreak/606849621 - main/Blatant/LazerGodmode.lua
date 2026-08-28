local modified = {}
local overlapCheck = OverlapParams.new()

LazerGodmode = vape.Categories.Blatant:CreateModule({
	Name = 'LazerGodmode',
	Function = function(callback)
		if callback then
			LazerGodmode:Clean(runService.PreSimulation:Connect(function()
				if entitylib.isAlive then
					overlapCheck.FilterDescendantsInstances = {gameCamera, lplr.Character}

					local parts = workspace:GetPartBoundsInRadius(entitylib.character.RootPart.Position, 10, overlapCheck)
					for _, part in parts do
						modified[part] = true
						part.CanTouch = false
					end

					for part in modified do
						if not table.find(parts, part) then
							modified[part] = nil
							part.CanTouch = true
						end
					end
				end
			end))
		else
			for inst in modified do
				inst.CanTouch = true
			end

			table.clear(modified)
		end
	end,
	Tooltip = 'Allow you to ignore specific damage sources'
})