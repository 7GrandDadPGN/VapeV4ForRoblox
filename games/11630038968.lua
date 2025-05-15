local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local collectionService = cloneref(game:GetService('CollectionService'))
local runService = cloneref(game:GetService('RunService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction

local bd = {}
local store = {
	blocks = {},
	serverBlocks = {}
}

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function parsePositions(v, func)
	if v:IsA('Part') then
		local start = -(v.Size / 2) + Vector3.new(1.5, 1.5, 1.5)
		for x = 0, v.Size.X - 1, 3 do
			for y = 0, v.Size.Y - 1, 3 do
				for z = 0, v.Size.Z - 1, 3 do
					local vec = start + Vector3.new(x, y, z)
					vec = v.CFrame:PointToWorldSpace(vec)
					vec = Vector3.new(math.round(vec.X), math.round(vec.Y), math.round(vec.Z))
					func(vec)
				end
			end
		end
	end
end

run(function()
	local Knit = require(replicatedStorage.Modules.Knit.Client)
	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end

	bd = setmetatable({
		BedwarsShop = require(replicatedStorage.Constants.BedWarsShop),
		BedwarsUpgrades = require(replicatedStorage.Constants.BedWarsTeamUpgrades),
		Blink = require(replicatedStorage.Blink.Client),
		BreakTimes = require(replicatedStorage.Constants.Blocks),
		BowClient = require(replicatedStorage.Client.Components.All.Tools.BowClient),
		CombatConstants = require(replicatedStorage.Constants.Melee),
		Communication = require(replicatedStorage.Client.Communication),
		Knit = Knit,
		Entity = require(replicatedStorage.Modules.Entity),
		ServerData = require(replicatedStorage.Modules.ServerData),
	}, {
		__index = function(self, ind)
			rawset(self, ind, ind:find('Service') and Knit.GetService(ind) or Knit.GetController(ind))
			return rawget(self, ind)
		end
	})

	task.spawn(function()
		local map = workspace:WaitForChild('Map', 99999)
		if map and vape.Loaded ~= nil then
			vape:Clean(map.DescendantAdded:Connect(function(v)
				parsePositions(v, function(pos)
					store.blocks[pos] = v
				end)
			end))
			vape:Clean(map.DescendantRemoving:Connect(function(v)
				parsePositions(v, function(pos)
					if store.blocks[pos] == v then
						store.blocks[pos] = nil
						store.serverBlocks[pos] = nil
					end
				end)
			end))
			for _, v in map:GetDescendants() do
				parsePositions(v, function(pos)
					store.blocks[pos] = v
					store.serverBlocks[pos] = v
				end)
			end
		end
	end)

	vape:Clean(function()
		table.clear(store.blocks)
		table.clear(store)
	end)
end)

for _, v in {'Reach', 'SilentAim', 'Disabler', 'HitBoxes', 'MurderMystery', 'AutoRejoin'} do
	vape:Remove(v)
end
run(function()
	local AutoClicker
	local CPS
	
	AutoClicker = vape.Categories.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				repeat
					local tool = getTool()
					if tool and inputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
					task.wait(1 / CPS.GetRandomValue())
				until not AutoClicker.Enabled
			end
		end,
		Tooltip = 'Automatically clicks for you'
	})
	CPS = AutoClicker:CreateTwoSlider({
		Name = 'CPS',
		Min = 1,
		Max = 20,
		DefaultMin = 8,
		DefaultMax = 12
	})
end)
	
run(function()
	local old
	
	vape.Categories.Combat:CreateModule({
		Name = 'Reach',
		Function = function(callback)
			if callback then
				old = rawget(bd.CombatConstants, 'REACH_IN_STUDS')
				rawset(bd.CombatConstants, 'REACH_IN_STUDS', 18)
				rawset(bd.Entity.LocalEntity, 'Reach', 18)
			else
				rawset(bd.CombatConstants, 'REACH_IN_STUDS', old)
				rawset(bd.Entity.LocalEntity, 'Reach', old)
				old = nil
			end
		end,
		Tooltip = 'Extends attack reach'
	})
end)
	
run(function()
	local Velocity = {Enabled = false}
	local VelocityHorizontal = {Value = 100}
	local VelocityVertical = {Value = 100}
	local VelocityChance = {Value = 100}
	local VelocityTargeting = {Enabled = false}
	local applyKnockback
	local connection
	
	local function velocityFunction(velo, ...)
		if Random.new():NextNumber(0, 100) > VelocityChance.Value then return end
		local check = (not VelocityTargeting.Enabled) or entitylib.EntityPosition({
			Range = 50,
			Part = 'RootPart',
			Players = true
		})
		if check then
			local hort, vert = (VelocityHorizontal.Value / 100), (VelocityVertical.Value / 100)
			if hort == 0 and vert == 0 then return end
			velo = Vector3.new(velo.X * hort, velo.Y * vert, velo.Z * hort)
		end
		return applyKnockback(velo, ...)
	end
	
	Velocity = vape.Categories.Combat:CreateModule({
		Name = 'Velocity',
		Function = function(callback)
			if callback then
				connection = getconnections(bd.CombatService.KnockBackApplied._re.OnClientEvent)[1]
				if not connection then return end
				applyKnockback = hookfunction(connection.Function, function(...)
					return velocityFunction(...)
				end)
			else
				if applyKnockback then hookfunction(connection.Function, applyKnockback) end
				connection = nil
			end
		end,
		Tooltip = 'Reduces knockback taken'
	})
	VelocityHorizontal = Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	VelocityVertical = Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	VelocityChance = Velocity:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	VelocityTargeting = Velocity:CreateToggle({Name = 'Only when targeting'})
end)
	
run(function()
	local old
	
	vape.Categories.Blatant:CreateModule({
		Name = 'Criticals',
		Function = function(callback)
			if callback then 
				old = hookfunction(bd.Blink.item_action.attack_entity.fire, function(...)
					local data = ...
					if type(data) == 'table' then 
						rawset(data, 'is_crit', true)
					end
					return old(...)
				end)
			else
				hookfunction(bd.Blink.item_action.attack_entity.fire, old)
				old = nil
			end
		end,
		Tooltip = 'Always hit criticals'
	})
end)
	
run(function()
	local old
	
	vape.Categories.Blatant:CreateModule({
		Name = 'InvMove',
		Function = function(callback)
			if callback then
				old = hookfunction(bd.MovementController.AddSpeedOverride, function(...)
					if select(2, ...) == 'MenuOpen' then
						return
					end
					return old(...)
				end)
				bd.MovementController:RemoveSpeedOverride('MenuOpen')
			else
				hookfunction(bd.MovementController.AddSpeedOverride, old)
				old = nil
			end
		end,
		Tooltip = 'Prevents slowing down when using items.'
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
	local Swing
	local Block
	local AutoBlock
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local LegitAura
	local Particles, Boxes, AttackDelay, SwingDelay, ClickDelay = {}, {}, tick(), tick(), tick()
	local lMouse = cloneref(lplr:GetMouse())
	
	local function getAttackData()
		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(0) then return false end
		end
		if LegitAura.Enabled then
			if ClickDelay < tick() then return false end
		end
	
		return getTool()
	end
	
	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				if LegitAura.Enabled then
					Killaura:Clean(inputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							ClickDelay = tick() + 0.1
						end
					end))
				end
	
				repeat
					local tool = getAttackData()
					local attacked = {}
					if tool and tool:HasTag('Sword') then
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
	
							if AutoBlock.Enabled and not bd.Entity.LocalEntity.IsBlocking then
								firesignal(lMouse.Button2Down)
							end
	
							for _, v in plrs do
								local delta = (v.RootPart.Position - selfpos)
								local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
								if angle > (math.rad(AngleSlider.Value) / 2) then continue end
								table.insert(attacked, {
									Entity = v,
									Check = delta.Magnitude > AttackRange.Value and BoxSwingColor or BoxAttackColor
								})
								targetinfo.Targets[v] = tick() + 1
								if Block.Enabled then
									if bd.Entity.LocalEntity.IsBlocking then continue end
								end
	
								if not Swing.Enabled and SwingDelay < tick() then
									SwingDelay = tick() + 0.25
									entitylib.character.Humanoid.Animator:LoadAnimation(tool.Animations.Swing):Play()
	
									if vape.ThreadFix then
										setthreadidentity(2)
									end
									bd.ViewmodelController:PlayAnimation(tool.Name)
									if vape.ThreadFix then
										setthreadidentity(8)
									end
								end
	
								if delta.Magnitude > AttackRange.Value then continue end
								if AttackDelay < tick() then
									AttackDelay = tick() + (1 / CPS.GetRandomValue())
									local bdent = bd.Entity.FindByCharacter(v.Character)
									if bdent then
										bd.Blink.item_action.attack_entity.fire({
											target_entity_id = bdent.Id,
											is_crit = entitylib.character.RootPart.AssemblyLinearVelocity.Y < 0,
											weapon_name = tool.Name,
											extra = {
												rizz = 'No.',
												sigma = 'The...',
												those = workspace.Name == 'Ok'
											}
										})
									end
								end
							end
						else
							if AutoBlock.Enabled and bd.Entity.LocalEntity.IsBlocking then
								firesignal(lMouse.Button2Up)
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
	
					task.wait()
				until not Killaura.Enabled
			else
				if AutoBlock.Enabled and bd.Entity.LocalEntity.IsBlocking then
					firesignal(lMouse.Button2Up)
				end
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
	CPS = Killaura:CreateTwoSlider({
		Name = 'Attacks per Second',
		Min = 1,
		Max = 20,
		DefaultMin = 12,
		DefaultMax = 12
	})
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
		Default = 360
	})
	Max = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 10,
		Default = 10
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
	Swing = Killaura:CreateToggle({Name = 'No Swing'})
	Block = Killaura:CreateToggle({Name = 'No Block'})
	AutoBlock = Killaura:CreateToggle({Name = 'AutoBlock'})
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
		Default = 0.14,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	LegitAura = Killaura:CreateToggle({
		Name = 'Swing only',
		Function = function()
			if Killaura.Enabled then
				Killaura:Toggle()
				Killaura:Toggle()
			end
		end,
		Tooltip = 'Only attacks while swinging manually'
	})
end)
	
run(function()
	local old
	
	vape.Categories.Blatant:CreateModule({
		Name = 'NoFall',
		Function = function(callback)
			if callback then 
				old = hookfunction(bd.Blink.player_state.take_fall_damage.fire, function() end)
			else
				hookfunction(bd.Blink.player_state.take_fall_damage.fire, old)
				old = nil
			end
		end,
		Tooltip = 'Prevents taking fall damage.'
	})
end)
	
run(function()
	local old
	
	vape.Categories.Blatant:CreateModule({
		Name = 'NoSlowdown',
		Function = function(callback)
			local func = debug.getproto(bd.MovementController.KnitStart, 5)
			if callback then
				old = debug.getconstants(debug.getproto(bd.MovementController.KnitStart, 5))
				for i, v in old do 
					debug.setconstant(func, i, v == 'IsSneaking' and v or 'IsSpectating')
				end
			else
				for i, v in old do 
					debug.setconstant(func, i, v)
				end
				table.clear(old)
			end
		end,
		Tooltip = 'Prevents slowing down when using items.'
	})
end)
	
run(function()
	local TargetPart
	local FOV
	local old
	local rayCheck = RaycastParams.new()
	rayCheck.FilterType = Enum.RaycastFilterType.Exclude
	
	local function aimFunction(...)
		local plr = entitylib.EntityMouse({
	        Range = FOV.Value,
	        Part = 'RootPart',
	        Players = true
	    })
	
	    if plr then
	        rayCheck.FilterDescendantsInstances = {plr.Character, gameCamera}
	        rayCheck.CollisionGroup = plr[TargetPart.Value].CollisionGroup
	        local offsetpos = entitylib.character.Head.CFrame
	        local calc = prediction.SolveTrajectory(offsetpos.Position, 180, 60, plr[TargetPart.Value].Position, plr[TargetPart.Value].Velocity, workspace.Gravity, plr.HipHeight, nil, rayCheck)
	
	        if calc then
	            targetinfo.Targets[plr] = tick() + 1
	            return offsetpos.Position + CFrame.new(offsetpos.Position, calc).LookVector * 100
	        end
	    end
	
		return old(...)
	end
	
	local ProjectileAimbot = vape.Categories.Blatant:CreateModule({
		Name = 'ProjectileAimbot',
		Function = function(callback)
			if callback then
				old = hookfunction(debug.getupvalue(bd.BowClient.Start, 11), function(...)
					return aimFunction(...)
				end)
			else
	            hookfunction(debug.getupvalue(bd.BowClient.Start, 11), old)
				old = nil
			end
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
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
end)
	
run(function()
	local AutoPlay
	local Delay
	
	AutoPlay = vape.Categories.Utility:CreateModule({
		Name = 'AutoPlay',
		Function = function(callback)
			if callback then
				AutoPlay:Clean(bd.Blink.game_state.team_won.on(function()
					if bd.ServerData.Submode ~= 'Playground' then
						bd.MatchController:EnterQueue(bd.ServerData.Submode)
					end
				end))
			end
		end,
		Tooltip = 'Automatically queues after the match ends.'
	})
end)
	
run(function()
	local Scaffold
	local Expand
	local Tower
	local Downwards
	local Diagonal
	local LimitItem
	local adjacent, lastpos = {}, Vector3.zero
	
	for x = -3, 3, 3 do
		for y = -3, 3, 3 do
			for z = -3, 3, 3 do
				local vec = Vector3.new(x, y, z)
				if vec.Y ~= 0 and (vec.X ~= 0 or vec.Z ~= 0) then
					continue
				end
	
				if vec ~= Vector3.zero then
					table.insert(adjacent, vec)
				end
			end
		end
	end
	
	local function getBlocksInPoints(s, e)
		local list = {}
		for x = s.X, e.X, 3 do
			for y = s.Y, e.Y, 3 do
				for z = s.Z, e.Z, 3 do
					local vec = Vector3.new(x, y, z)
					if store.blocks[vec] then
						table.insert(list, vec)
					end
				end
			end
		end
		return list
	end
	
	local function roundPos(vec)
		return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
	end
	
	local function nearCorner(poscheck, pos)
		local startpos = poscheck - Vector3.new(3, 3, 3)
		local endpos = poscheck + Vector3.new(3, 3, 3)
		local check = poscheck + (pos - poscheck).Unit * 100
		if math.abs(check.Y - startpos.Y) > 3 then
			return Vector3.new(poscheck.X, math.clamp(check.Y, startpos.Y, endpos.Y), poscheck.Z)
		end
		return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
	end
	
	local function blockProximity(pos)
		local mag, returned = 60
		local tab = getBlocksInPoints(pos - Vector3.new(21, 21, 21), pos + Vector3.new(21, 21, 21))
		for _, v in tab do
			local blockpos = nearCorner(v, pos)
			local newmag = (pos - blockpos).Magnitude
			if newmag < mag then
				mag, returned = newmag, blockpos
			end
		end
		table.clear(tab)
		return returned
	end
	
	local function checkAdjacent(pos)
		for _, v in adjacent do
			if store.blocks[pos + v] then return true end
		end
		return false
	end
	
	local function getBlock()
		local tool = getTool()
		if tool and tool:HasTag('Blocks') then
			local btype = tool.Name == 'Blocks' and 'Clay' or tool.Name:sub(1, -6)
			return btype, btype == 'Clay' and 'Blocks' or ("%*Block"):format(btype)
		end
	
		if LimitItem.Enabled then return end
		for _, tool in lplr.Backpack:GetChildren() do
			if tool:IsA('Tool') and tool:HasTag('Blocks') then
				local btype = tool.Name == 'Blocks' and 'Clay' or tool.Name:sub(1, -6)
				return btype, btype == 'Clay' and 'Blocks' or ("%*Block"):format(btype)
			end
		end
	end
	
	Scaffold = vape.Categories.Utility:CreateModule({
		Name = 'Scaffold',
		Function = function(callback)
			if callback then
				repeat
					if entitylib.isAlive then
						local btype, bname = getBlock()
	
						if btype then
							local root = entitylib.character.RootPart
							if Tower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and (not inputService:GetFocusedTextBox()) then
								root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
							end
	
							for i = Expand.Value, 1, -1 do
								local currentpos = roundPos(root.Position - Vector3.new(0, entitylib.character.HipHeight + (Downwards.Enabled and inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + entitylib.character.Humanoid.MoveDirection * (i * 3))
								if Diagonal.Enabled then
									if math.abs(math.round(math.deg(math.atan2(-entitylib.character.Humanoid.MoveDirection.X, -entitylib.character.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
										local dt = (lastpos - currentpos)
										if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
											currentpos = lastpos
										end
									end
								end
	
								local block = store.blocks[currentpos]
								if not block then
									blockpos = checkAdjacent(currentpos) and currentpos or blockProximity(currentpos)
									if blockpos then
										local fake = replicatedStorage.Assets.Blocks[btype]:Clone()
										fake.Name = 'TempBlock'
										fake.Position = blockpos
										fake:AddTag('TempBlock')
										fake:AddTag('Block')
										fake.Parent = workspace.Map
										bd.EffectsController:PlaySound(blockpos)
										bd.Entity.LocalEntity:RemoveTool(bname, 1)
	
										task.spawn(function()
											local suc, block = bd.Blink.item_action.place_block.invoke({
												position = blockpos,
												block_type = btype,
												extra = {
													rizz = 'No.',
													sigma = 'The...',
													those = workspace.Name == 'Ok'
												}
											})
											fake:Destroy()
											if not (suc or block) then
												bd.Entity.LocalEntity:AddTool(bname, 1)
											end
										end)
									end
								end
								lastpos = currentpos
							end
						end
					end
					task.wait(0.03)
				until not Scaffold.Enabled
			end
		end,
		Tooltip = 'Helps you make bridges/scaffold walk.'
	})
	Expand = Scaffold:CreateSlider({
		Name = 'Expand',
		Min = 1,
		Max = 6
	})
	Tower = Scaffold:CreateToggle({
		Name = 'Tower',
		Default = true
	})
	Downwards = Scaffold:CreateToggle({
		Name = 'Downwards',
		Default = true
	})
	Diagonal = Scaffold:CreateToggle({
		Name = 'Diagonal',
		Default = true
	})
	LimitItem = Scaffold:CreateToggle({Name = 'Limit to items'})
end)
	
run(function()
	local AutoBuy
	local Sword
	local Armor
	local Upgrades
	local NPCs = {}
	local UpgradeToggles = {}
	local Functions = {}
	local Callbacks = {Functions}
	local npctick = tick()
	
	local function canBuy(item, currencytable, amount)
		return (currencytable[item.currency or 'Iron'] or 0) >= (item.cost * (amount or 1))
	end
	
	local function buyItem(item, itemTier, itemCategory, currencytable)
		notif('AutoBuy', 'Bought '..item.name, 3)
		task.spawn(function()
			bd.Blink.player_state.bedwars_buy_item.invoke({
				item = itemCategory or item.name,
				tier = itemTier
			})
		end)
		currencytable[item.currency or 'Iron'] -= item.cost
	end
	
	local function buyTier(category, currencytable)
		local nextItem, itemTier
		for i, v in category.tiers do
			if currencytable[v.name] then
				nextItem, nextTier = category.tiers[i + 1], i + 1
				break
			end
		end
	
		if nextItem and canBuy(nextItem, currencytable) then
			buyItem(nextItem, nextTier, category.name, currencytable)
		end
	end
	
	local function buyUpgrade(upgrade, currencytable)
		local upgradeItem = bd.BedwarsUpgrades[upgrade]
		local localTeam = bd.Entity.LocalEntity.Team or {Name = ''}
		local teamUpgrades = bd.Communication.team_upgrades.value[localTeam.Name] or {}
		local currentTier = (teamUpgrades[upgrade] or 0) + 1
		local bought = false
	
		for i = currentTier, #upgradeItem.tiers do
			local tier = upgradeItem.tiers[i]
	
			if canBuy({currency = 'Diamond', cost = tier.cost}, currencytable) then
				notif('AutoBuy', 'Bought '..upgrade..' '..i, 3)
				task.spawn(function()
					bd.Blink.player_state.bedwars_buy_upgrade.invoke(upgrade)
				end)
				currencytable.Diamond -= tier.cost
				bought = true
			else
				break
			end
		end
	
		return bought
	end
	
	local function getShopNPC()
		local shop, items, upgrades, newid = nil, false, false, nil
		if entitylib.isAlive then
			local localPosition = entitylib.character.RootPart.Position
			for ent, upgrade in NPCs do
				if (ent.Position - localPosition).Magnitude <= 10 then
					shop = true
					items = items or not upgrade
					upgrades = upgrade or upgrades
				end
			end
		end
		return shop, items, upgrades
	end
	
	AutoBuy = vape.Categories.Inventory:CreateModule({
		Name = 'AutoBuy',
		Function = function(callback)
			if callback then
				AutoBuy:Clean(collectionService:GetInstanceAddedSignal('menu_opener'):Connect(function(obj)
					NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
				end))
	
				for _, obj in collectionService:GetTagged('menu_opener') do
					NPCs[obj.Parent] = obj:GetAttribute('menu') == 'TeamUpgrades'
				end
	
				repeat
					local npc, shop, upgrades, newid = getShopNPC()
	
					if npc and npctick <= tick() then
						local currencytable = table.clone(bd.Entity.LocalEntity.Inventory)
						for _, tab in Callbacks do
							for _, callback in tab do
								callback(currencytable, shop, upgrades)
							end
						end
						npctick = tick() + 0.4
					end
	
					task.wait(0.1)
				until not AutoBuy.Enabled
			else
				table.clear(NPCs)
			end
		end,
		Tooltip = 'Automatically buys items when you go near the shop'
	})
	Sword = AutoBuy:CreateToggle({
		Name = 'Buy Sword',
		Function = function(callback)
			npctick = tick()
			Functions[2] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[2].items[1], currencytable)
			end or nil
		end,
		Default = true
	})
	Armor = AutoBuy:CreateToggle({
		Name = 'Buy Armor',
		Function = function(callback)
			npctick = tick()
			Functions[1] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[2].items[2], currencytable)
			end or nil
		end,
		Default = true
	})
	Pickaxe = AutoBuy:CreateToggle({
		Name = 'Buy Pickaxe',
		Function = function(callback)
			npctick = tick()
			Functions[1] = callback and function(currencytable, shop)
				if not shop then return end
				buyTier(bd.BedwarsShop[3].items[1], currencytable)
			end or nil
		end
	})
	Upgrades = AutoBuy:CreateToggle({
		Name = 'Buy Upgrades',
		Function = function(callback)
			for _, v in UpgradeToggles do
				v.Object.Visible = callback
			end
		end,
		Default = true
	})
	local count = 0
	for i, v in bd.BedwarsUpgrades do
		local toggleCount = count
		table.insert(UpgradeToggles, AutoBuy:CreateToggle({
			Name = 'Buy '..i,
			Function = function(callback)
				npctick = tick()
				Functions[5 + toggleCount + (i == 'ArmorProtection' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
					if not upgrades then return end
					return buyUpgrade(i, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (i == 'ArmorProtection' or i == 'SwordDamage')
		}))
		count += 1
	end
	--[[for i, v in bedwars.TeamUpgradeMeta do
		local toggleCount = count
		table.insert(UpgradeToggles, AutoBuy:CreateToggle({
			Name = 'Buy '..(v.name == 'Armor' and 'Protection' or v.name),
			Function = function(callback)
				npctick = tick()
				Functions[5 + toggleCount + (v.name == 'Armor' and 20 or 0)] = callback and function(currencytable, shop, upgrades)
					if not upgrades then return end
					if v.disabledInQueue and table.find(v.disabledInQueue, store.queueType) then return end
					return buyUpgrade(i, currencytable)
				end or nil
			end,
			Darker = true,
			Default = (i == 'ARMOR' or i == 'DAMAGE')
		}))
		count += 1
	end]]
end)
	
run(function()
	local Breaker
	local Value
	local OnlyPlayer
	
	local function getBlocksInPoints(s, e)
		local list = {}
		for x = s.X, e.X, 3 do
			for y = s.Y, e.Y, 3 do
				for z = s.Z, e.Z, 3 do
					local vec = Vector3.new(x, y, z)
					if store.blocks[vec] then
						list[vec] = store.blocks[vec]
					end
				end
			end
		end
		return list
	end
	
	local function getPickaxe()
		for name in bd.Entity.LocalEntity.Inventory do
			if name:find('Pickaxe') then
				return name
			end
		end
	end
	
	Breaker = vape.Categories.Minigames:CreateModule({
		Name = 'Breaker',
		Function = function(callback)
			if callback then
				local breakBlock
				local breakTime = 0
				local lastBreak
	
				repeat
					breakBlock = nil
	
					if entitylib.isAlive then
						local pickaxe = getPickaxe()
	
						if pickaxe then
							local pos = (entitylib.character.RootPart.Position // 3) * 3
							local rvec = Vector3.new(3, 3, 3) * Range.Value
	
							for blockpos, block in getBlocksInPoints(pos - rvec, pos + rvec) do
								if block and block.Name == 'Block' and (block.Parent.Name == 'Bed' and lplr.Team and block.Parent:GetAttribute('Team') ~= lplr.Team.Name) then
									breakBlock = block
									break
								end
							end
	
							if breakBlock ~= lastBreak then
								if breakBlock then
									breakTime = os.clock() + bd.BreakTimes[breakBlock:GetAttribute('block_type') or 'Clay']
									bd.Blink.item_action.start_break_block.fire({
										position = breakBlock.Position,
										pickaxe_name = pickaxe,
										timestamp = workspace:GetServerTimeNow()
									})
								else
									bd.Blink.item_action.stop_break_block.fire(false)
								end
								lastBreak = breakBlock
							elseif breakBlock and breakTime < os.clock() then
								bd.Blink.item_action.stop_break_block.fire(true)
								breakTime = math.huge
							end
						end
					end
					task.wait(1 / 60)
				until not Breaker.Enabled
			end
		end,
		Tooltip = 'Breaks enemy blocks around you'
	})
	Range = Breaker:CreateSlider({
		Name = 'Break range',
		Min = 1,
		Max = 5,
		Default = 5,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
end)
	