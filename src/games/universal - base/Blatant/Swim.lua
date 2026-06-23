local Swim
local terrain = cloneref(workspace:FindFirstChildWhichIsA('Terrain'))
local lastpos = Region3.new(Vector3.zero, Vector3.zero)

Swim = vape.Categories.Blatant:CreateModule({
	Name = 'Swim',
	Function = function(callback)
		if callback then
			Swim:Clean(runService.PreSimulation:Connect(function(dt)
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local moving = entitylib.character.Humanoid.MoveDirection ~= Vector3.zero
					local rootvelo = root.Velocity
					local space = inputService:IsKeyDown(Enum.KeyCode.Space)

					if terrain then
						local factor = (moving or space) and Vector3.new(6, 6, 6) or Vector3.new(2, 1, 2)
						local pos = root.Position - Vector3.new(0, 1, 0)
						local newpos = Region3.new(pos - factor, pos + factor):ExpandToGrid(4)
						terrain:ReplaceMaterial(lastpos, 4, Enum.Material.Water, Enum.Material.Air)
						terrain:FillRegion(newpos, 4, Enum.Material.Water)
						lastpos = newpos
					end
				end
			end))
		else
			if terrain and lastpos then
				terrain:ReplaceMaterial(lastpos, 4, Enum.Material.Water, Enum.Material.Air)
			end
		end
	end,
	Tooltip = 'Lets you swim midair'
})