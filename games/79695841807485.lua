local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction

local ad = {}

run(function()
	local function searchForScripts(map)
		local scripts = {}
		local constants = {}

		for _, v in replicatedStorage:GetDescendants() do
			if v:IsA('ModuleScript') then
				pcall(function()
					constants[v] = debug.getconstants(getscriptclosure(v))
				end)
			end
		end

		for name, entry in map do
			for scr, list in constants do
				local found = 0

				for _, v in list do
					for _, comp in entry do
						if comp == v then
							found += 1
							break
						end
					end
				end

				if found == #entry then
					scripts[name] = scr
				end
			end
		end

		for name in map do
			if not scripts[name] then
				vape:CreateNotification('Vape', 'Unable to find script: '..name, 10, 'alert')
				return false
			end
		end

		return scripts
	end

	if starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
		repeat task.wait() until not starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) or vape.Loaded == nil
		if vape.Loaded == nil then return end
	end

	for _, v in getconnections(game:GetService('LogService').MessageOut) do
		if v.Function then
			v:Disable()
		end
	end

	local scripts = searchForScripts({
		BulletHandler = {'BulletUpdate', 'HitEffects'},
		CharacterController = {'BloodVignette', 'HealthBar'},
		CharacterReplicatorManager = {'CharacterReplicatorAngleUpdate'},
		Network = {'CreateRemoteEvent', 'CreateRemoteFunction', 'OnInvoke', 'ExceptPlayer', 'AllPlayers'},
		Memory = {'LocalPlayerMemory', 'GlobalPlayerMemory'}
	})

	ad = {
		CharacterController = require(scripts.CharacterController),
		Network = require(scripts.Network),
		Memory = require(scripts.Memory).GetLocalMemory(),
		ReplicationPlayers = debug.getupvalue(require(scripts.CharacterReplicatorManager).GetReplicator, 1),
		FireBullet = require(scripts.BulletHandler)
	}
end)
if vape.Loaded == nil then return end

run(function()
	local function waitForChildOfType(obj, name, timeout, prop)
		local checktick = tick() + timeout
		local returned
		repeat
			returned = prop and obj[name] or obj:FindFirstChildOfClass(name)
			if returned or checktick < tick() then break end
			task.wait()
		until false
		return returned
	end

	entitylib.addEntity = function(char, plr, obj)
		if not char or not obj then return end
		entitylib.EntityThreads[char] = task.spawn(function()
			local hum = {
				Health = 100,
				MaxHealth = 100,
				HipHeight = 0,
				RigType = Enum.HumanoidRigType.R6,
				GetState = function()
					return Enum.HumanoidStateType.Running
				end,
				ChangeState = function() end,
				GetPropertyChangedSignal = function()
					return {
						Connect = function()
							return {Disconnect = function() end}
						end
					}
				end,
				MoveDirection = Vector3.zero
			}
			local humrootpart = char:WaitForChild('HumanoidRootPart', 10)
			local head = char:WaitForChild('Head', 10) or humrootpart

			if hum and humrootpart then
				local entity = {
					Connections = {},
					Character = char,
					Health = char:GetAttribute('Health') or 100,
					Head = head,
					Humanoid = hum,
					HumanoidRootPart = humrootpart,
					HipHeight = 2,
					MaxHealth = char:GetAttribute('MaxHealth') or 0,
					NPC = plr == nil,
					Player = plr,
					RootPart = humrootpart,
					Object = obj,
					SpawnTime = tick() + 2
				}

				if plr == lplr then
					entitylib.character = entity
					entitylib.isAlive = true
					entitylib.Events.LocalAdded:Fire(entity)
				else
					entity.Targetable = entitylib.targetCheck(entity)

					for _, v in entitylib.getUpdateConnections(entity) do
						table.insert(entity.Connections, v:Connect(function() end))
					end

					table.insert(entity.Connections, char:GetAttributeChangedSignal('Health'):Connect(function()
						entity.Health = char:GetAttribute('Health') or 100
						entity.MaxHealth = char:GetAttribute('MaxHealth') or 0
						entitylib.Events.EntityUpdated:Fire(entity)
					end))

					table.insert(entity.Connections, obj.Destroying:Connect(function()
						entitylib.removeEntity(char, plr == lplr)
					end))

					table.insert(entitylib.List, entity)
					entitylib.Events.EntityAdded:Fire(entity)
				end
			end
			entitylib.EntityThreads[char] = nil
		end)
	end

	entitylib.isVulnerable = function(ent)
		return ent.Health > 0 and not ent.Character:HasTag('Protected')
	end

	entitylib.refreshEntity = function(char, plr)
		entitylib.removeEntity(char)
		local ent = ad.ReplicationPlayers[plr]
		if ent then
			entitylib.addEntity(ent.Character, plr, ent)
		end
	end

	entitylib.start = function()
		if entitylib.Running then
			entitylib.stop()
		end

		table.insert(entitylib.Connections, ad.Network:Connect('PlayerSpawned', function(plr)
			task.defer(function()
				local ent = ad.ReplicationPlayers[plr]
				if ent then
					entitylib.addEntity(ent.Character, ent.Player, ent)
				end
			end)
		end))
		for _, ent in ad.ReplicationPlayers do
			entitylib.addEntity(ent.Character, ent.Player, ent)
		end

		table.insert(entitylib.Connections, ad.Memory:GetMemoryChangedSignal('Character'):Connect(function()
			task.defer(function()
				if ad.Memory.Character then
					entitylib.addEntity(ad.Memory.Character, lplr, ad.Memory)
				else
					entitylib.removeEntity(ad.Memory.Character, lplr)
				end
			end)
		end))
		if ad.Memory.Character then
			entitylib.addEntity(ad.Memory.Character, lplr, ad.Memory)
		end

		entitylib.Running = true
	end
end)
entitylib.start()

for _, v in {'TriggerBot', 'Invisible', 'Swim', 'TargetStrafe', 'AntiRagdoll', 'Freecam', 'Parkour', 'SafeWalk', 'AntiFall', 'HitBoxes', 'Killaura', 'MurderMystery', 'AnimationPlayer', 'Blink', 'Disabler'} do
	vape:Remove(v)
end
run(function()
	
		local SilentAim
		local Target
		local Mode
		local Method
		local MethodRay
		local IgnoredScripts
		local Range
		local HitChance
		local HeadshotChance
		local AutoFire
		local AutoFireShootDelay
		local AutoFireMode
		local AutoFirePosition
		local Wallbang
		local CircleColor
		local CircleTransparency
		local CircleFilled
		local CircleObject
		local Projectile
		local ProjectileSpeed
		local ProjectileGravity
		local RaycastWhitelist = RaycastParams.new()
		RaycastWhitelist.FilterType = Enum.RaycastFilterType.Include
		local fireoffset, rand, delayCheck = CFrame.identity, Random.new(), tick()
		local old
	
		local function getTarget(origin, obj)
			if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then return end
	
			local targetPart = (rand.NextNumber(rand, 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
			local ent = entitylib['Entity'..Mode.Value]({
				Range = Range.Value,
				Wallcheck = Target.Walls.Enabled and (obj or true) or nil,
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
	
		local function canClick()
			local mousepos = inputService:GetMouseLocation() - Vector2.new(0, 36)
			for _, v in lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
				local obj = v:FindFirstAncestorOfClass('ScreenGui')
				if v.Active and v.Visible and obj and obj.Enabled then
					return false
				end
			end
			for _, v in coreGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
				local obj = v:FindFirstAncestorOfClass('ScreenGui')
				if v.Active and v.Visible and obj and obj.Enabled then
					return false
				end
			end
			return (not vape.gui.ScaledGui.ClickGui.Visible) and (not inputService:GetFocusedTextBox())
		end
	
		local function hook(...)
			local origin, dir, pos, wep, ignored, localcheck = ...
			local args = {...}
	
			if typeof(origin) == 'Vector3' and typeof(dir) == 'Vector3' and typeof(ignored) == 'table' and localcheck then
				local ent, targetPart = getTarget(origin)
	
				if targetPart then
					local calc = prediction.SolveTrajectory(origin, wep.Source.MuzzleVelocity, 192, targetPart.Position, targetPart.Velocity, workspace.Gravity, 0)
					if not calc then
						return old(...)
					end
	
					args[2] = CFrame.lookAt(origin, calc).LookVector * dir.Magnitude
					if Wallbang.Enabled then
						table.insert(ignored, workspace.Map)
					end
				end
			end
	
			return old(unpack(args, 1, select('#', ...)))
		end
	
		SilentAim = vape.Categories.Combat:CreateModule({
			Name = 'SilentAim',
			Function = function(callback)
				if CircleObject then
					CircleObject.Visible = callback and Mode.Value == 'Mouse'
				end
				if callback then
					old = hookfunction(ad.FireBullet, function(...)
						return hook(...)
					end)
	
					repeat
						if CircleObject then
							CircleObject.Position = inputService:GetMouseLocation()
						end
						if AutoFire.Enabled then
							local origin = gameCamera.CFrame
							local ent = entitylib['Entity'..Mode.Value]({
								Range = Range.Value,
								Wallcheck = Target.Walls.Enabled or nil,
								Part = 'Head',
								Origin = origin.Position,
								Players = Target.Players.Enabled,
								NPCs = Target.NPCs.Enabled
							})
	
							if mouse1click and (isrbxactive or iswindowactive)() then
								if ent and canClick() then
									if delayCheck < tick() then
										if mouseClicked then
											mouse1release()
											delayCheck = tick() + 0.01
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
				else
					if old then
						hookfunction(ad.FireBullet, old)
					end
					old = nil
				end
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
			Name = 'AutoFire'
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
	
run(function()
	local Killaura
	local Targets
	local CPS
	local SwingRange
	local AttackRange
	local AngleSlider
	local Max
	local Mouse
	local Lunge
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Face
	local Overlay = OverlapParams.new()
	Overlay.FilterType = Enum.RaycastFilterType.Include
	local Particles, Boxes, AttackDelay = {}, {}, tick()
	
	local function getAttackData()
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end
	
		local tool = ad.Memory.EquippedObject
		return tool and tool.ObjectClassName == 'Melee' and tool
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				repeat
					local tool = getAttackData()
					local attacked = {}
					if tool then
						local plrs = entitylib.AllPosition({
							Range = SwingRange.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = Max.Value
						})
	
						if #plrs > 0 then
							local selfpos = entitylib.character.RootPart.Position
							local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
	
							for _, v in plrs do
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end
	
								table.insert(attacked, {
									Entity = v,
									Check = delta.Magnitude > AttackRange.Value and BoxSwingColor or BoxAttackColor
								})
								targetinfo.Targets[v] = tick() + 1
	
								if AttackDelay < tick() then
									AttackDelay = tick() + 0.05
									ad.Network:FireServer('MeleeHit', v.Character, v.RootPart, tool.Instance, true, v.RootPart.Position)
	                                if vape.ThreadFix then
	                                    setthreadidentity(8)
	                                end
								end
							end
						end
					end
	
					for i, v in Boxes do
						v.Adornee = attacked[i] and attacked[i].Entity.RootPart or nil
						if v.Adornee then
							v.Color3 = Color3.fromHSV(attacked[i].Check.Hue, attacked[i].Check.Sat, attacked[i].Check.Value)
							v.Transparency = 1 - attacked[i].Check.Opacity
						end
					end
	
					for i, v in Particles do
						v.Position = attacked[i] and attacked[i].Entity.RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
						v.Parent = attacked[i] and gameCamera or nil
					end
	
					if Face.Enabled and attacked[1] then
						local vec = attacked[1].Entity.RootPart.Position * Vector3.new(1, 0, 1)
						entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y, vec.Z))
					end
	
					task.wait()
				until not Killaura.Enabled
			else
				for _, v in Boxes do
					v.Adornee = nil
				end
				for _, v in Particles do
					v.Parent = nil
				end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	Targets = Killaura:CreateTargets({Players = true})
	SwingRange = Killaura:CreateSlider({
		Name = 'Swing range',
		Min = 1,
		Max = 16,
		Default = 16,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AttackRange = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 16,
		Default = 16,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AngleSlider = Killaura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 90
	})
	Max = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 10,
		Default = 10
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
	Lunge = Killaura:CreateToggle({Name = 'Sword lunge only'})
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
			BoxSwingColor.Object.Visible = callback
			BoxAttackColor.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local box = Instance.new('BoxHandleAdornment')
					box.Adornee = nil
					box.AlwaysOnTop = true
					box.Size = Vector3.new(3, 5, 3)
					box.CFrame = CFrame.new(0, -0.5, 0)
					box.ZIndex = 0
					box.Parent = vape.gui
					Boxes[i] = box
				end
			else
				for _, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
	})
	BoxSwingColor = Killaura:CreateColorSlider({
		Name = 'Target Color',
		Darker = true,
		DefaultHue = 0.6,
		DefaultOpacity = 0.5,
		Visible = false
	})
	BoxAttackColor = Killaura:CreateColorSlider({
		Name = 'Attack Color',
		Darker = true,
		DefaultOpacity = 0.5,
		Visible = false
	})
	Killaura:CreateToggle({
		Name = 'Target particles',
		Function = function(callback)
			ParticleTexture.Object.Visible = callback
			ParticleColor1.Object.Visible = callback
			ParticleColor2.Object.Visible = callback
			ParticleSize.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local part = Instance.new('Part')
					part.Size = Vector3.new(2, 4, 2)
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.CanQuery = false
					part.Parent = Killaura.Enabled and gameCamera or nil
					local particles = Instance.new('ParticleEmitter')
					particles.Brightness = 1.5
					particles.Size = NumberSequence.new(ParticleSize.Value)
					particles.Shape = Enum.ParticleEmitterShape.Sphere
					particles.Texture = ParticleTexture.Value
					particles.Transparency = NumberSequence.new(0)
					particles.Lifetime = NumberRange.new(0.4)
					particles.Speed = NumberRange.new(16)
					particles.Rate = 128
					particles.Drag = 16
					particles.ShapePartial = 1
					particles.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
					})
					particles.Parent = part
					Particles[i] = part
				end
			else
				for _, v in Particles do
					v:Destroy()
				end
				table.clear(Particles)
			end
		end
	})
	ParticleTexture = Killaura:CreateTextBox({
		Name = 'Texture',
		Default = 'rbxassetid://14736249347',
		Function = function()
			for _, v in Particles do
				v.ParticleEmitter.Texture = ParticleTexture.Value
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor1 = Killaura:CreateColorSlider({
		Name = 'Color Begin',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor2 = Killaura:CreateColorSlider({
		Name = 'Color End',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleSize = Killaura:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	Face = Killaura:CreateToggle({Name = 'Face target'})
end)
	
run(function()
	local NoFall
	local old
	
	local function charAdded()
	    old = hookfunction(ad.CharacterController.Airborne._connections[1].Function, function() end)
	end
	
	NoFall = vape.Categories.Blatant:CreateModule({
	    Name = 'NoFall',
	    Function = function(callback)
	        if callback then
	            NoFall:Clean(entitylib.Events.LocalAdded:Connect(charAdded))
	            NoFall:Clean(entitylib.Events.LocalRemoved:Connect(function()
	                old = nil
	            end))
	            if entitylib.isAlive then
	                charAdded()
	            end
	        else
	            if old then
	                hookfunction(ad.CharacterController.Airborne._connections[1].Function, old)
	            end
	            old = nil
	        end
	    end,
	    Tooltip = 'Prevents taking fall damage.'
	})
end)
	