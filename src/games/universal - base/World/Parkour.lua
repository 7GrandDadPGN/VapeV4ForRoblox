local Parkour

Parkour = vape.Categories.World:CreateModule({
	Name = 'Parkour',
	Function = function(callback)
		if callback then 
			local oldfloor
			Parkour:Clean(runService.RenderStepped:Connect(function()
				if entitylib.isAlive then 
					local material = entitylib.character.Humanoid.FloorMaterial
					if material == Enum.Material.Air and oldfloor ~= Enum.Material.Air then 
						entitylib.character.Humanoid.Jump = true
					end
					oldfloor = material
				end
			end))
		end
	end,
	Tooltip = 'Automatically jumps after reaching the edge'
})