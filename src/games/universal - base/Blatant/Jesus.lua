local Jesus
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include

Jesus = vape.Categories.Blatant:CreateModule({
	Name = 'Jesus',
	Function = function(callback)
		if callback then
			local terrain = workspace:FindFirstChildWhichIsA('Terrain')
			params.FilterDescendantsInstances = {terrain}
			local Platform = Instance.new('Part')
			Platform.CanQuery = false
			Platform.Anchored = true
			Platform.Size = Vector3.one
			Platform.Transparency = 1
			Platform.Parent = gameCamera

			Jesus:Clean(Platform)
			Jesus:Clean(runService.PreSimulation:Connect(function()
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local ray = workspace:Raycast(root.Position, Vector3.new(0, -((root.Size.Y / 2) + entitylib.character.HipHeight + math.abs(root.AssemblyLinearVelocity.Y * 0.032)), 0), params)

					if ray and ray.Material == Enum.Material.Water then
						Platform.CFrame = CFrame.new(ray.Position)
					else
						Platform.CFrame = CFrame.new(10000, 10000, 10000)
					end
				end
			end))
		end
	end,
	Tooltip = 'Allow you to stand on terrain water'
})