local GameTheme
local Mode
local Modes = {
	Winter = function()
		local part = Instance.new('Part')
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CastShadow = false
		part.Size = Vector3.one * 200
		part.Transparency = 1
		part.Parent = workspace
		local particleemitter = Instance.new('ParticleEmitter')
		particleemitter.Acceleration = Vector3.new(0, -4, 0)
		particleemitter.EmissionDirection = Enum.NormalId.Bottom
		particleemitter.LightEmission = 1
		particleemitter.LightInfluence = 1
		particleemitter.Rate = 400
		particleemitter.RotSpeed = NumberRange.new(6, 12)
		particleemitter.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.75, 0.3),
			NumberSequenceKeypoint.new(1, 0.75, 0.3)
		})
		particleemitter.Parent = part

		local oldSettings = {lightingService.Ambient, lightingService.EnvironmentDiffuseScale, lightingService.EnvironmentSpecularScale, lightingService.FogEnd}
		lightingService.Ambient = Color3.fromRGB(0, 242, 255)
		lightingService.EnvironmentDiffuseScale = 0
		lightingService.EnvironmentSpecularScale = 0
		lightingService.FogEnd = 900

		GameTheme:Clean(part)
		GameTheme:Clean(runService.RenderStepped:Connect(function()
			if entitylib.isAlive then
				part.CFrame = CFrame.new(entitylib.character.RootPart.Position)
			end
		end))

		GameTheme:Clean(function()
			lightingService.Ambient = oldSettings[1]
			lightingService.EnvironmentDiffuseScale = oldSettings[2]
			lightingService.EnvironmentSpecularScale = oldSettings[3]
			lightingService.FogEnd = oldSettings[4]
		end)
	end
}

GameTheme = vape.Legit:CreateModule({
	Name = 'GameTheme',
	Function = function(callback)
		if callback then
			Modes[Mode.Value]()
		end
	end,
	Tooltip = 'funny'
})
Mode = GameTheme:CreateDropdown({
	Name = 'Mode',
	List = {'Winter'},
	Function = function()
		if GameTheme.Enabled then
			GameTheme:Toggle()
			GameTheme:Toggle()
		end
	end
})