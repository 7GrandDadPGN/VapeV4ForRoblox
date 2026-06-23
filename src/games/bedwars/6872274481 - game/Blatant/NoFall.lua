local NoFall
local Mode
local rayParams = RaycastParams.new()
local groundHit
task.spawn(function()
	groundHit = bedwars.Client:Get(remotes.GroundHit).instance
end)

NoFall = vape.Categories.Blatant:CreateModule({
	Name = 'NoFall',
	Function = function(callback)
		if callback then
			local tracked = 0
			if Mode.Value == 'Gravity' then
				local extraGravity = 0
				NoFall:Clean(runService.PreSimulation:Connect(function(dt)
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						if root.AssemblyLinearVelocity.Y < -85 then
							rayParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
							rayParams.CollisionGroup = root.CollisionGroup

							local rootSize = root.Size.Y / 2 + entitylib.character.HipHeight
							local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, (tracked * 0.1) - rootSize, 0), rayParams)
							if not ray then
								root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -86, root.AssemblyLinearVelocity.Z)
								root.CFrame += Vector3.new(0, extraGravity * dt, 0)
								extraGravity += -workspace.Gravity * dt
							end
						else
							extraGravity = 0
						end
					end
				end))
			else
				repeat
					if entitylib.isAlive then
						local root = entitylib.character.RootPart
						tracked = entitylib.character.Humanoid.FloorMaterial == Enum.Material.Air and math.min(tracked, root.AssemblyLinearVelocity.Y) or 0

						if tracked < -85 then
							if Mode.Value == 'Packet' then
								groundHit:FireServer(nil, Vector3.new(0, tracked, 0), workspace:GetServerTimeNow())
							else
								rayParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
								rayParams.CollisionGroup = root.CollisionGroup

								local rootSize = root.Size.Y / 2 + entitylib.character.HipHeight
								if Mode.Value == 'Teleport' then
									local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, -1000, 0), rayParams)
									if ray then
										root.CFrame -= Vector3.new(0, root.Position.Y - (ray.Position.Y + rootSize), 0)
									end
								else
									local ray = workspace:Blockcast(root.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, (tracked * 0.1) - rootSize, 0), rayParams)
									if ray then
										tracked = 0
										root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -80, root.AssemblyLinearVelocity.Z)
									end
								end
							end
						end
					end

					task.wait(0.03)
				until not NoFall.Enabled
			end
		end
	end,
	Tooltip = 'Prevents taking fall damage.'
})
Mode = NoFall:CreateDropdown({
	Name = 'Mode',
	List = {'Packet', 'Gravity', 'Teleport', 'Bounce'},
	Function = function()
		if NoFall.Enabled then
			NoFall:Toggle()
			NoFall:Toggle()
		end
	end
})