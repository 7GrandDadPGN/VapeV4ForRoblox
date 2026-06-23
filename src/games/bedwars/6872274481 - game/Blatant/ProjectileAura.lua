local ProjectileAura
local Targets
local Range
local List
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Include
local projectileRemote = {InvokeServer = function() end}
local FireDelays = {}
task.spawn(function()
	projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
end)

local function getAmmo(check)
	for _, item in store.inventory.inventory.items do
		if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
			return item.itemType
		end
	end
end

local function getProjectiles()
	local items = {}
	for _, item in store.inventory.inventory.items do
		local proj = bedwars.ItemMeta[item.itemType].projectileSource
		local ammo = proj and getAmmo(proj)
		if ammo and table.find(List.ListEnabled, ammo) then
			table.insert(items, {
				item,
				ammo,
				proj.projectileType(ammo),
				proj
			})
		end
	end
	return items
end

ProjectileAura = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAura',
	Function = function(callback)
		if callback then
			repeat
				if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.5 then
					local ent = entitylib.EntityPosition({
						Part = 'RootPart',
						Range = Range.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled
					})

					if ent then
						local pos = entitylib.character.RootPart.Position
						for _, data in getProjectiles() do
							local item, ammo, projectile, itemMeta = unpack(data)
							if (FireDelays[item.itemType] or 0) < tick() then
								rayCheck.FilterDescendantsInstances = {workspace.Map}
								local meta = bedwars.ProjectileMeta[projectile]
								local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
								local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, ent.Jumping and 42.6 or nil, rayCheck)
								if calc then
									targetinfo.Targets[ent] = tick() + 1
									local switched = switchItem(item.tool)

									task.spawn(function()
										local dir, id = CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
										local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
										bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
										local res = projectileRemote:InvokeServer(item.tool, ammo, projectile, shootPosition, pos, dir * projSpeed, id, {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
										if not res then
											FireDelays[item.itemType] = tick()
										else
											local shoot = itemMeta.launchSound
											shoot = shoot and shoot[math.random(1, #shoot)] or nil
											if shoot then
												bedwars.SoundManager:playSound(shoot)
											end
										end
									end)

									FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec
									if switched then
										task.wait(0.05)
									end
								end
							end
						end
					end
				end
				task.wait(0.1)
			until not ProjectileAura.Enabled
		end
	end,
	Tooltip = 'Shoots people around you'
})
Targets = ProjectileAura:CreateTargets({
	Players = true,
	Walls = true
})
List = ProjectileAura:CreateTextList({
	Name = 'Projectiles',
	Default = {'arrow', 'snowball'}
})
Range = ProjectileAura:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 50,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})