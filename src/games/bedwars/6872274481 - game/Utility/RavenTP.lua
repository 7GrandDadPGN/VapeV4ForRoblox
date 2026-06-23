local RavenTP

RavenTP = vape.Categories.Utility:CreateModule({
	Name = 'RavenTP',
	Function = function(callback)
		if callback then
			RavenTP:Toggle()
			local plr = entitylib.EntityMouse({
				Range = 1000,
				Players = true,
				Part = 'RootPart'
			})

			if getItem('raven') and plr then
				bedwars.Client:Get(remotes.SpawnRaven):CallServerAsync():andThen(function(projectile)
					if projectile then
						local bodyforce = Instance.new('BodyForce')
						bodyforce.Force = Vector3.new(0, projectile.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
						bodyforce.Parent = projectile.PrimaryPart

						if plr then
							task.spawn(function()
								for _ = 1, 20 do
									if plr.RootPart and projectile then
										projectile:SetPrimaryPartCFrame(CFrame.lookAlong(plr.RootPart.Position, gameCamera.CFrame.LookVector))
									end
									task.wait(0.05)
								end
							end)
							task.wait(0.3)
							bedwars.RavenController:detonateRaven()
						end
					end
				end)
			end
		end
	end,
	Tooltip = 'Spawns and teleports a raven to a player\nnear your mouse.'
})