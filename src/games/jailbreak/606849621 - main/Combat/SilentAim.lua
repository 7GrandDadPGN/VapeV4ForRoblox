local SilentAim
local Target
local Mode
local Range
local HitChance
local HeadshotChance
local Wallbang
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local rand = Random.new()
local old
local ProjectileRaycast = RaycastParams.new()
ProjectileRaycast.RespectCanCollide = true

local function getMousePosition()
	if inputService.TouchEnabled then
		return gameCamera.ViewportSize / 2
	end

	return inputService:GetMouseLocation()
end

local function getTarget(origin, limit, attackcheck)
	if rand.NextNumber(rand, 0, 100) > HitChance.Value then
		return
	end

	local targetPart = (rand.NextNumber(rand, 0, 100) < HeadshotChance.Value) and 'Head' or 'RootPart'
	local entity = entitylib['Entity'..Mode.Value]({
		Range = Mode.Value == 'Position' and math.min(Range.Value, limit) or Range.Value,
		RangePosition = limit,
		Wallcheck = Target.Walls.Enabled and true or nil,
		Wallbang = Wallbang.Enabled and entitylib.character.RootPart.Position or nil,
		Part = targetPart,
		Origin = origin.Position,
		Players = Target.Players.Enabled,
		NPCs = Target.NPCs.Enabled
	})

	if entity then
		targetinfo.Targets[entity] = tick() + 1
	end

	return entity, entity and entity[targetPart], origin
end

local function Hook(...)
	local item = ...

	if item.Local then
		OriginScanner:UpdateIgnore(item.BulletEmitter.IgnoreList)
		shootTimer = os.clock() + 0.1
		local entity, targetPart, origin = getTarget(item.Tip.CFrame, (item.Config.BulletSpeed or 1000) * item.BulletEmitter.LifeSpan)

		if entity then
			local oldTip
			if Wallbang.Enabled then
				local ray = workspace:Raycast(targetPart.Position, (origin.Position - targetPart.Position), OriginScanner.Ray)

				if ray then
					local neworigin, hitbox = OriginScanner:Scan(entitylib.character.RootPart.Position, targetPart.Position, ray.Position + ray.Normal * 0.01, targetPart)

					if neworigin then
						oldTip = item.Tip.CFrame
						origin = CFrame.lookAt(neworigin, targetPart.Position)
						item.Tip.CFrame = origin
					end
				end
			end

			ProjectileRaycast.FilterDescendantsInstances = {gameCamera, entity.Character, workspace.Vehicles}
			ProjectileRaycast.CollisionGroup = entity.RootPart.CollisionGroup

			local trajectory = oldBulletUpdate and targetPart.Position or prediction.SolveTrajectory(origin.Position, item.Config.BulletSpeed or 1000, math.abs(item.BulletEmitter.GravityVector.Y), targetPart.Position, entity.RootPart.AssemblyLinearVelocity, workspace.Gravity, entity.HipHeight, nil, ProjectileRaycast)
			if trajectory then
				targetinfo.Targets[entity] = tick() + 1
				item.TipDirection = CFrame.lookAt(origin.Position, trajectory).LookVector
				aimTimer = os.clock() + 0.3
				aimVec = targetPart.Position
			end

			if oldTip then
				local call = table.pack(old(...))
				item.Tip.CFrame = oldTip
				return unpack(call, 1, call.n)
			end
		end
	end

	return old(...)
end

SilentAim = vape.Categories.Combat:CreateModule({
	Name = 'SilentAim',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback and Mode.Value == 'Mouse'
		end

		if Wallbang.Enabled then
			debug.setconstant(jb.GunController.ShootCheckConditions, 1, callback and '_Tip' or 'Tip')
		end

		if callback then
			old = hookfunction(jb.GunController.ShootOther, function(...)
				return Hook(...)
			end)

			repeat
				if CircleObject then
					CircleObject.Position = getMousePosition()
				end

				task.wait()
			until not SilentAim.Enabled
		else
			if old then
				restorefunction(jb.GunController.ShootOther)
				old = nil
			end
		end
	end,
	Tooltip = 'Silently adjusts your aim towards the enemy'
})
Target = SilentAim:CreateTargets({
	Players = true
})
Mode = SilentAim:CreateDropdown({
	Name = 'Mode',
	List = {'Mouse', 'Position'},
	Function = function(val)
		if CircleObject then
			CircleObject.Visible = SilentAim.Enabled and val == 'Mouse'
		end
	end,
	Tooltip = 'Mouse - Checks for entities near the mouses position\nPosition - Checks for entities near the local character'
})
Range = SilentAim:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 1000,
	Default = 150,
	Function = function(val)
		if CircleObject then
			CircleObject.Radius = val
		end
	end,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
HitChance = SilentAim:CreateSlider({
	Name = 'Hit Chance',
	Min = 0,
	Max = 100,
	Default = 85,
	Suffix = '%'
})
HeadshotChance = SilentAim:CreateSlider({
	Name = 'Headshot Chance',
	Min = 0,
	Max = 100,
	Default = 65,
	Suffix = '%'
})
Wallbang = SilentAim:CreateToggle({
	Name = 'Wallbang',
	Function = function(callback)
		if SilentAim.Enabled then
			debug.setconstant(jb.GunController.ShootCheckConditions, 1, callback and '_Tip' or 'Tip')
		end
	end,
	Tooltip = 'Allow you to shoot people through walls when specific conditions are met.\n(If the entity has a valid hitbox position exposed or if the shoot position can be moved past walls (eg hugging walls))'
})
SilentAim:CreateToggle({
	Name = 'Range Circle',
	Function = function(callback)
		if callback then
			CircleObject = Drawing.new('Circle')
			CircleObject.Filled = CircleFilled.Enabled
			CircleObject.Color = Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value)
			CircleObject.Position = vape.gui.AbsoluteSize / 2
			CircleObject.Radius = Range.Value
			CircleObject.NumSides = 100
			CircleObject.Transparency = 1 - CircleTransparency.Value
			CircleObject.Visible = SilentAim.Enabled and Mode.Value == 'Mouse'
		else
			pcall(function()
				CircleObject.Visible = false
				CircleObject:Remove()
			end)
		end
		CircleColor.Object.Visible = callback
		CircleTransparency.Object.Visible = callback
		CircleFilled.Object.Visible = callback
	end
})
CircleColor = SilentAim:CreateColorSlider({
	Name = 'Circle Color',
	Function = function(hue, sat, val)
		if CircleObject then
			CircleObject.Color = Color3.fromHSV(hue, sat, val)
		end
	end,
	Darker = true,
	Visible = false
})
CircleTransparency = SilentAim:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Decimal = 10,
	Default = 0.5,
	Function = function(val)
		if CircleObject then
			CircleObject.Transparency = 1 - val
		end
	end,
	Darker = true,
	Visible = false
})
CircleFilled = SilentAim:CreateToggle({
	Name = 'Circle Filled',
	Function = function(callback)
		if CircleObject then
			CircleObject.Filled = callback
		end
	end,
	Darker = true,
	Visible = false
})