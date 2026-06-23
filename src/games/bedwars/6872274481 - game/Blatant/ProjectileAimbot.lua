local TargetPart
local Targets
local FOV
local OtherProjectiles
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Include
rayCheck.FilterDescendantsInstances = {workspace:FindFirstChild('Map')}
local old

local ProjectileAimbot = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAimbot',
	Function = function(callback)
		if callback then
			old = bedwars.ProjectileController.calculateImportantLaunchValues
			bedwars.ProjectileController.calculateImportantLaunchValues = function(...)
				local self, projmeta, worldmeta, origin, shootpos = ...
				local plr = entitylib.EntityMouse({
					Part = 'RootPart',
					Range = FOV.Value,
					Players = Targets.Players.Enabled,
					NPCs = Targets.NPCs.Enabled,
					Wallcheck = Targets.Walls.Enabled,
					Origin = entitylib.isAlive and (shootpos or entitylib.character.RootPart.Position) or Vector3.zero
				})

				if plr then
					local pos = shootpos or self:getLaunchPosition(origin)
					if not pos then
						return old(...)
					end

					if (not OtherProjectiles.Enabled) and not projmeta.projectile:find('arrow') then
						return old(...)
					end

					local meta = projmeta:getProjectileMeta()
					local lifetime = (worldmeta and meta.predictionLifetimeSec or meta.lifetimeSec or 3)
					local gravity = (meta.gravitationalAcceleration or 196.2) * projmeta.gravityMultiplier
					local projSpeed = (meta.launchVelocity or 100)
					local offsetpos = pos + (projmeta.projectile == 'owl_projectile' and Vector3.zero or projmeta.fromPositionOffset)
					local balloons = plr.Character:GetAttribute('InflatedBalloons')
					local playerGravity = workspace.Gravity

					if balloons and balloons > 0 then
						playerGravity = (workspace.Gravity * (1 - ((balloons >= 4 and 1.2 or balloons >= 3 and 1 or 0.975))))
					end

					if plr.Character.PrimaryPart:FindFirstChild('rbxassetid://8200754399') then
						playerGravity = 6
					end

					if plr.Player:GetAttribute('IsOwlTarget') then
						for _, owl in collectionService:GetTagged('Owl') do
							if owl:GetAttribute('Target') == plr.Player.UserId and owl:GetAttribute('Status') == 2 then
								playerGravity = 0
							end
						end
					end

					local newlook = CFrame.new(offsetpos, plr[TargetPart.Value].Position) * CFrame.new(projmeta.projectile == 'owl_projectile' and Vector3.zero or Vector3.new(bedwars.BowConstantsTable.RelX, bedwars.BowConstantsTable.RelY, bedwars.BowConstantsTable.RelZ))
					local calc = prediction.SolveTrajectory(newlook.p, projSpeed, gravity, plr[TargetPart.Value].Position, projmeta.projectile == 'telepearl' and Vector3.zero or plr[TargetPart.Value].Velocity, playerGravity, plr.HipHeight, plr.Jumping and 42.6 or nil, rayCheck)
					if calc then
						targetinfo.Targets[plr] = tick() + 1
						return {
							initialVelocity = CFrame.new(newlook.Position, calc).LookVector * projSpeed,
							positionFrom = offsetpos,
							deltaT = lifetime,
							gravitationalAcceleration = gravity,
							drawDurationSeconds = 5
						}
					end
				end

				return old(...)
			end
		else
			bedwars.ProjectileController.calculateImportantLaunchValues = old
		end
	end,
	Tooltip = 'Silently adjusts your aim towards the enemy'
})
Targets = ProjectileAimbot:CreateTargets({
	Players = true,
	Walls = true
})
TargetPart = ProjectileAimbot:CreateDropdown({
	Name = 'Part',
	List = {'RootPart', 'Head'}
})
FOV = ProjectileAimbot:CreateSlider({
	Name = 'FOV',
	Min = 1,
	Max = 1000,
	Default = 1000
})
OtherProjectiles = ProjectileAimbot:CreateToggle({
	Name = 'Other Projectiles',
	Default = true
})