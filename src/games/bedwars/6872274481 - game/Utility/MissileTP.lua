local MissileTP

MissileTP = vape.Categories.Utility:CreateModule({
	Name = 'MissileTP',
	Function = function(callback)
		if callback then
			MissileTP:Toggle()
			local plr = entitylib.EntityMouse({
				Range = 1000,
				Players = true,
				Part = 'RootPart'
			})

			if getItem('guided_missile') and plr then
				local projectile = bedwars.RuntimeLib.await(bedwars.GuidedProjectileController.fireGuidedProjectile:CallServerAsync('guided_missile'))
				if projectile then
					local projectilemodel = projectile.model
					if not projectilemodel.PrimaryPart then
						projectilemodel:GetPropertyChangedSignal('PrimaryPart'):Wait()
					end

					local bodyforce = Instance.new('BodyForce')
					bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
					bodyforce.Name = 'AntiGravity'
					bodyforce.Parent = projectilemodel.PrimaryPart

					repeat
						projectile.model:SetPrimaryPartCFrame(CFrame.lookAlong(plr.RootPart.CFrame.p, gameCamera.CFrame.LookVector))
						task.wait(0.1)
					until not projectile.model or not projectile.model.Parent
				else
					notif('MissileTP', 'Missile on cooldown.', 3)
				end
			end
		end
	end,
	Tooltip = 'Spawns and teleports a missile to a player\nnear your mouse.'
})