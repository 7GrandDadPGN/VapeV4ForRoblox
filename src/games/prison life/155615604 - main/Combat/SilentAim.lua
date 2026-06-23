local mouseClicked
run(function()
	local SilentAim
	local Target
	local Mode
	local Range
	local HitChance
	local HeadshotChance
	local AutoFire = {Enabled = false}
	local AutoFireRate
	local AutoFireTaser
	local Wallbang
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local rayParams = RaycastParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	local fireoffset, rand, delayCheck = CFrame.identity, Random.new(), tick()
	local old

	local function getTarget(origin, limit, attackcheck)
		if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then return end
		local targetPart = (rand.NextNumber(rand, 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
		local ent = entitylib['Entity'..Mode.Value]({
			Range = Mode.Value == 'Position' and math.min(Range.Value, limit) or Range.Value,
			RangePosition = limit,
			AttackCheck = attackcheck,
			Wallcheck = Target.Walls.Enabled and true or nil,
			Wallbang = Wallbang.Enabled and entitylib.character.RootPart.Position or nil,
			Part = targetPart,
			Origin = origin,
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled
		})

		if ent then
			targetinfo.Targets[ent] = tick() + 1
		end

		return ent, ent and ent[targetPart], origin
	end

	local function Hook(...)
		local origin, direction = ...
		local gundata = debug.getupvalue(oldshoot or pl.Shoot, 10)
		local ent, targetPart, origin = getTarget(origin, gundata and gundata.Range or 1000, not gundata or gundata.Behavior ~= 'Taser')

		if not ent then return old(...) end

		local args = table.pack(...)
		args[2] = targetPart.Position
		aimTimer = os.clock() + 0.3
		aimVec = args[2]

		if Wallbang.Enabled then
			local ignore = {lplr.Character}
			for _, v in entitylib.List do
				table.insert(ignore, v.Character)
			end
			rayParams.FilterDescendantsInstances = ignore
			local ray = workspace:Raycast(args[2], (origin - args[2]), rayParams)

			if ray then
				local neworigin, hitbox = OriginScanner:Scan(entitylib.character.RootPart.Position, args[2], ray.Position + ray.Normal * 0.01, targetPart)

				if neworigin then
					for i, v in debug.getstack(3) do
						if v == origin then
							debug.setstack(3, i, neworigin)
						end
					end

					args[1] = neworigin
					if hitbox then
						return targetPart, hitbox
					end
				end
			end
		end

		return old(unpack(args, 1, args.n))
	end

	SilentAim = vape.Categories.Combat:CreateModule({
		Name = 'SilentAim',
		Function = function(callback)
			if CircleObject then
				CircleObject.Visible = callback and Mode.Value == 'Mouse'
			end

			if callback then
				old = hookfunction(pl.Bullet, function(...)
					return Hook(...)
				end)

				local autofiretimer = os.clock()
				repeat
					if CircleObject then
						CircleObject.Position = inputService:GetMouseLocation()
					end

					if AutoFire.Enabled and autofiretimer < os.clock() then
						autofiretimer = os.clock() + (1 / AutoFireRate.Value)

						local tool = lplr.Character:FindFirstChildWhichIsA('Tool')
						local gundata = debug.getupvalue(oldshoot or pl.Shoot, 10)
						local ammo = tool and tool:GetAttribute('Local_CurrentAmmo') or 0
						if gundata and ammo > 0 and not tool:GetAttribute('Local_IsShooting') then
							local limit = gundata.Range or 1000
							local taser = gundata and gundata.Behavior == 'Taser'
							local ent = entitylib['Entity'..Mode.Value]({
								Range = Mode.Value == 'Position' and math.min(Range.Value, limit) or Range.Value,
								RangePosition = limit,
								AttackCheck = not taser,
								Wallcheck = Target.Walls.Enabled and true or nil,
								Wallbang = Wallbang.Enabled and entitylib.isAlive and entitylib.character.RootPart.Position or nil,
								Part = 'Head',
								Origin = entitylib.isAlive and entitylib.character.Head.Position or Vector3.zero,
								Players = Target.Players.Enabled
							})

							if ent and entitylib.character.Humanoid.Health > 0 then
								if not ((taser or AutoFireTaser.Enabled) and (ent.Character:GetAttribute('Tased') or ent.Character:GetAttribute('Arrested'))) then
									autofiretimer = os.clock() + (ammo > 1 and gundata.FireRate or 1 / AutoFireRate.Value)
									local obj = {UserInputState = Enum.UserInputState.Begin, UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero}
									task.spawn(pl.Shoot, obj)
									obj.UserInputState = Enum.UserInputState.End
								end
							end
						end
					end

					task.wait()
				until not SilentAim.Enabled
			else
				if old then
					if restorefunction then
						restorefunction(pl.Bullet)
					else
						hookfunction(pl.Bullet, old)
					end
					old = nil
				end
			end
		end,
		ExtraText = function()
			return 'PrisonLife'
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	Target = SilentAim:CreateTargets({Players = true})
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
	AutoFire = SilentAim:CreateToggle({
		Name = 'AutoFire',
		Function = function(callback)
			AutoFireRate.Object.Visible = callback
			AutoFireTaser.Object.Visible = callback
		end
	})
	AutoFireRate = SilentAim:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Visible = false,
		Darker = true,
		Suffix = 'hz'
	})
	AutoFireTaser = SilentAim:CreateToggle({
		Name = 'Ignore Tased',
		Visible = false,
		Darker = true
	})
	Wallbang = SilentAim:CreateToggle({Name = 'Wallbang'})
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
end)