local SilentAim
local Target
local Mode
local Range
local HitChance
local HeadshotChance
local AutoFire
local Wallbang
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local ProjectileRaycast = RaycastParams.new()
ProjectileRaycast.RespectCanCollide = true
local rand, old = Random.new()

local function getTarget(origin, obj)
	if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then return end
	--local targetPart = (Random.new().NextNumber(Random.new(), 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
	local targetPart = 'RootPart'
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
	return ent, ent and ent[targetPart]
end

local function raycastLoop(origin, pos)
	local returned
	local real = origin
	for i = 1, 20 do
		local ray = workspace:Raycast(origin, (pos - origin), frontlines.ShootRay)
		if ray and not ray.Instance:HasTag('SOLDIER') then
			returned = ray.Position - ray.Normal * 0.1
			origin = returned
		else
			break
		end
	end
	return returned
end

SilentAim = vape.Categories.Combat:CreateModule({
	Name = 'SilentAim',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback and Mode.Value == 'Mouse'
		end

		if callback then
			old = hookfunction(frontlines.ShootFunction, function(shootid, fire, pos, dir, ...)
				if not frontlines.Main then return end

				local cstate = frontlines.Main.globals.cli_state
				if cstate.state == frontlines.Main.cli_state_t.COMBAT and (shootid % frontlines.Main.globals.cli_id_alloc.m) == cstate.id then
					local ent, targetPart = getTarget(pos)
					if ent then
						local velo = dir.Magnitude
						local targetpos = targetPart.Root_M.Spine1_M.WorldCFrame.Position
						ProjectileRaycast.FilterDescendantsInstances = {gameCamera, ent.Character}
						ProjectileRaycast.CollisionGroup = targetPart.CollisionGroup

						if Wallbang.Enabled then
							local wall = raycastLoop(pos, targetpos)
							if wall and (pos - wall).Magnitude < 8 then
								pos = wall
							end
						end

						local calc = prediction.SolveTrajectory(pos, velo, workspace.Gravity, targetpos, Vector3.zero, workspace.Gravity, ent.HipHeight, nil, ProjectileRaycast)
						if calc then
							dir = -CFrame.new(pos, calc).ZVector * velo
						end
					end
				end

				return old(shootid, fire, pos, dir, ...)
			end)

			local oldent
			repeat
				if CircleObject then
					CircleObject.Position = inputService:GetMouseLocation()
				end

				if AutoFire.Enabled then
					local ent = entitylib['Entity'..Mode.Value]({
						Range = Range.Value,
						Wallcheck = Target.Walls.Enabled or nil,
						Part = 'RootPart',
						Origin = entitylib.isAlive and frontlines.Main.globals.fpv_sol_instances.camera_bone.WorldPosition or Vector3.zero,
						Players = Target.Players.Enabled,
						NPCs = Target.NPCs.Enabled
					})

					local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
					ent = gun and gun.type ~= 2 and ent or nil
					if ent ~= oldent or ent then
						frontlines.Main.globals.ctrl_states.trigger = ent and true or false
						if ent then
							frontlines.Main.globals.ctrl_ts.trigger = time()
						end
						oldent = ent
					end
				end

				task.wait()
			until not SilentAim.Enabled
		else
			if old then
				hookfunction(frontlines.ShootFunction, old)
				old = nil
			end
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
	end
})
Range = SilentAim:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 1000,
	Default = 150,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end,
	Function = function(val)
		if CircleObject then
			CircleObject.Radius = val
		end
	end
})
HitChance = SilentAim:CreateSlider({
	Name = 'Hit Chance',
	Min = 0,
	Max = 100,
	Default = 85,
	Suffix = '%'
})
AutoFire = SilentAim:CreateToggle({Name = 'AutoFire'})
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