local mouseClicked
run(function()
	local SilentAim
	local Target
	local Mode
	local Method
	local RayMethod
	local IgnoredScripts
	local Range
	local HitChance
	local HeadshotChance
	local AutoFire
	local AutoFireShootDelay
	local AutoFireMode
	local AutoFirePosition
	local Wallbang
	local FunctionHook
	local OthHook
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local Projectile
	local ProjectileSpeed
	local ProjectileGravity
	local RaycastWhitelist = RaycastParams.new()
	RaycastWhitelist.FilterType = Enum.RaycastFilterType.Include
	local ProjectileRaycast = RaycastParams.new()
	ProjectileRaycast.RespectCanCollide = true
	local oldnamecall, oldhook, hookmethod
	local rand = Random.new()
	local clickDelay = os.clock()
	local didOth
	local fireOffset

	local function getMousePosition()
		if inputService.TouchEnabled then
			return gameCamera.ViewportSize / 2
		end

		return inputService:GetMouseLocation()
	end

	local function getTarget(origin, obj)
		if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then
			return
		end

		local targetPart = (rand.NextNumber(rand, 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
		local entity = entitylib['Entity'..Mode.Value]({
			Range = Range.Value,
			Wallcheck = Target.Walls.Enabled and (obj or true) or nil,
			Part = targetPart,
			Origin = origin,
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled
		})

		if entity then
			targetinfo.Targets[entity] = tick() + 1

			if Projectile.Enabled then
				ProjectileRaycast.FilterDescendantsInstances = {gameCamera, entity.Character}
				ProjectileRaycast.CollisionGroup = entity[targetPart].CollisionGroup
			end
		end

		return entity, entity and entity[targetPart], origin
	end

	local Hooks = {
		FindPartOnRayWithIgnoreList = {
			Hook = workspace.FindPartOnRayWithIgnoreList,
			Function = function(args)
				local entity, targetPart, origin = getTarget(args[1].Origin, {args[2]})
				if not entity then
					return
				end

				if Wallbang.Enabled then
					return {
						targetPart,
						targetPart.Position,
						targetPart.GetClosestPointOnSurface(targetPart, origin),
						targetPart.Material
					}
				end

				args[1] = Ray.new(origin, CFrame.lookAt(origin, targetPart.Position).LookVector * args[1].Direction.Magnitude)
			end
		},
		Raycast = {
			Hook = workspace.Raycast,
			Function = function(args)
				if RayMethod.Value ~= 'All' and args[3] and args[3].FilterType ~= Enum.RaycastFilterType[RayMethod.Value] then
					return
				end

				local entity, targetPart, origin = getTarget(args[1])
				if not entity then
					return
				end

				args[2] = CFrame.lookAt(origin, targetPart.Position).LookVector * args[2].Magnitude
				if Wallbang.Enabled then
					RaycastWhitelist.FilterDescendantsInstances = {targetPart}
					args[3] = RaycastWhitelist
				end
			end
		},
		ScreenPointToRay = {
			Hook = Instance.new('Camera').ScreenPointToRay,
			Function = function(args)
				local entity, targetPart, origin = getTarget(gameCamera.CFrame.Position)
				if not entity then
					return
				end

				local direction = CFrame.lookAt(origin, targetPart.Position)
				if Projectile.Enabled then
					local calc = prediction.SolveTrajectory(origin, ProjectileSpeed.Value, ProjectileGravity.Value, targetPart.Position, targetPart.Velocity, workspace.Gravity, entity.HipHeight, nil, ProjectileRaycast)
					if not calc then
						return
					end

					direction = CFrame.lookAt(origin, calc)
				end

				return {
					Ray.new(origin + (args[3] and direction.LookVector * args[3] or Vector3.zero), direction.LookVector)
				}
			end
		},
		Ray = {
			Hook = Ray.new,
			Function = function(args)
				local entity, targetPart, origin = getTarget(args[1])
				if not entity then
					return
				end

				if Projectile.Enabled then
					local calc = prediction.SolveTrajectory(origin, ProjectileSpeed.Value, ProjectileGravity.Value, targetPart.Position, targetPart.Velocity, workspace.Gravity, entity.HipHeight, nil, ProjectileRaycast)
					if not calc then
						return
					end

					args[2] = CFrame.lookAt(origin, calc).LookVector * args[2].Magnitude
				else
					args[2] = CFrame.lookAt(origin, targetPart.Position).LookVector * args[2].Magnitude
				end
			end,
			NoNamecall = true
		}
	}

	local function namecallHook(...)
		if getnamecallmethod() ~= Method.Value then
			return oldnamecall(...)
		end

		if checkcaller() then
			return oldnamecall(...)
		end

		local caller = getcallingscript()
		if caller then
			if table.find(IgnoredScripts.ListEnabled, tostring(caller)) then
				return oldnamecall(...)
			end
		end

		local self, args = ..., {select(2, ...)}
		local data = hookmethod.Function(args)
		if data then
			return unpack(data)
		end

		return oldnamecall(self, unpack(args))
	end

	for _, method in {'FindPartOnRayWithWhitelist', 'FindPartOnRay'} do
		Hooks[method] = table.clone(Hooks.FindPartOnRayWithIgnoreList)
		Hooks[method].Hook = workspace[method]
	end

	Hooks.ViewportPointToRay = table.clone(Hooks.ScreenPointToRay)
	Hooks.ViewportPointToRay.Hook = Instance.new('Camera').ViewportPointToRay

	SilentAim = vape.Categories.Combat:CreateModule({
		Name = 'SilentAim',
		Function = function(callback)
			if CircleObject then
				CircleObject.Visible = callback and Mode.Value == 'Mouse'
			end

			if callback then
				hookmethod = Hooks[Method.Value]
				didOth = OthHook.Enabled

				if FunctionHook.Enabled or hookmethod.NoNamecall then
					oldhook = (OthHook.Enabled and oth.hook or hookfunction)(hookmethod.Hook, function(...)
						if checkcaller() then
							return oldhook(...)
						end

						local caller = getcallingscript()
						if caller then
							if table.find(IgnoredScripts.ListEnabled, tostring(caller)) then
								return oldnamecall(...)
							end
						end

						if hookmethod.NoNamecall then
							local args = {...}
							local data = hookmethod.Function(args)
							if data then
								return unpack(data)
							end

							return oldhook(unpack(args))
						else
							local self, args = ..., {select(2, ...)}
							local data = hookmethod.Function(args)
							if data then
								return unpack(data)
							end

							return oldhook(self, unpack(args))
						end
					end)
				end

				if not hookmethod.NoNamecall then
					oldnamecall = OthHook.Enabled and oth.hook(getrawmetatable(game).__namecall, namecallHook) or hookmetamethod(game, '__namecall', namecallHook)
				end
			else
				if oldhook then
					(didOth and oth.unhook or restorefunction)(hookmethod.Hook)
					oldhook = nil
				end

				if oldnamecall then
					(didOth and oth.unhook or restorefunction)(getrawmetatable(game).__namecall)
					oldnamecall = nil
				end
			end

			repeat
				if CircleObject then
					CircleObject.Position = getMousePosition()
				end

				if AutoFire.Enabled then
					local origin = AutoFireMode.Value == 'Camera' and gameCamera.CFrame or entitylib.isAlive and entitylib.character.RootPart.CFrame or CFrame.identity
					local entity = entitylib['Entity'..Mode.Value]({
						Range = Range.Value,
						Wallcheck = Target.Walls.Enabled or nil,
						Part = 'Head',
						Origin = (origin * fireOffset).Position,
						Players = Target.Players.Enabled,
						NPCs = Target.NPCs.Enabled
					})

					if mouse1click and (isrbxactive or iswindowactive)() then
						if entity and canClick() then
							if clickDelay < os.clock() then
								if mouseClicked then
									mouse1release()
									clickDelay = os.clock() + AutoFireShootDelay.Value
								else
									mouse1press()
								end

								mouseClicked = not mouseClicked
							end
						else
							if mouseClicked then
								mouse1release()
							end

							mouseClicked = false
						end
					end
				end

				task.wait()
			until not SilentAim.Enabled
		end,
		ExtraText = function()
			return Method.Value:gsub('FindPartOnRay', '')
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
	Method = SilentAim:CreateDropdown({
		Name = 'Method',
		List = {'FindPartOnRay', 'FindPartOnRayWithIgnoreList', 'FindPartOnRayWithWhitelist', 'ScreenPointToRay', 'ViewportPointToRay', 'Raycast', 'Ray'},
		Function = function(val)
			if SilentAim.Enabled then
				SilentAim:Toggle()
				SilentAim:Toggle()
			end

			RayMethod.Object.Visible = val == 'Raycast'
		end,
		Tooltip = 'FindPartOnRay* - Deprecated methods of raycasting used in old games\nRaycast - The modern raycast method\n*PointToRay - Method to generate a ray from a screen position\nRay - Used in old games'
	})
	RayMethod = SilentAim:CreateDropdown({
		Name = 'Raycast Type',
		List = {'All', 'Exclude', 'Include'},
		Darker = true,
		Visible = false
	})
	IgnoredScripts = SilentAim:CreateTextList({
		Name = 'Ignored Scripts',
		Default = {'CameraModule'}
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
		Default = 100,
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
			AutoFireShootDelay.Object.Visible = callback
			AutoFireMode.Object.Visible = callback
			AutoFirePosition.Object.Visible = callback
		end
	})
	AutoFireShootDelay = SilentAim:CreateSlider({
		Name = 'Next Shot Delay',
		Min = 0,
		Max = 1,
		Decimal = 100,
		Visible = false,
		Darker = true,
		Suffix = function(val)
			return val == 1 and 'second' or 'seconds'
		end
	})
	AutoFireMode = SilentAim:CreateDropdown({
		Name = 'Origin',
		List = {'RootPart', 'Camera'},
		Visible = false,
		Darker = true,
		Tooltip = 'Determines the position to check for before shooting'
	})
	AutoFirePosition = SilentAim:CreateTextBox({
		Name = 'Offset',
		Function = function()
			local success, cf = pcall(function()
				return CFrame.new(unpack(AutoFirePosition.Value:split(',')))
			end)

			if success then
				fireOffset = cf
			end
		end,
		Default = '0, 0, 0',
		Visible = false,
		Darker = true
	})
	Wallbang = SilentAim:CreateToggle({Name = 'Wallbang'})
	FunctionHook = SilentAim:CreateToggle({
		Name = 'Function hook',
		Function = function()
			if SilentAim.Enabled then
				SilentAim:Toggle()
				SilentAim:Toggle()
			end
		end,
		Tooltip = 'Hook the function used for index calling (used on some games)'
	})
	OthHook = SilentAim:CreateToggle({
		Name = 'Oth hook',
		Function = function()
			if SilentAim.Enabled then
				SilentAim:Toggle()
				SilentAim:Toggle()
			end
		end,
		Tooltip = 'Hook the function using a less detected method (useful on some games)'
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
	Projectile = SilentAim:CreateToggle({
		Name = 'Projectile',
		Function = function(callback)
			ProjectileSpeed.Object.Visible = callback
			ProjectileGravity.Object.Visible = callback
		end
	})
	ProjectileSpeed = SilentAim:CreateSlider({
		Name = 'Speed',
		Min = 1,
		Max = 1000,
		Default = 1000,
		Darker = true,
		Visible = false,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	ProjectileGravity = SilentAim:CreateSlider({
		Name = 'Gravity',
		Min = 0,
		Max = 192.6,
		Default = 192.6,
		Darker = true,
		Visible = false
	})
end)