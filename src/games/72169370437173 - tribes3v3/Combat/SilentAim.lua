local SilentAim
local Target
local Part
local Range
local HitChance
local Prediction
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local ProjectileRaycast = RaycastParams.new()
ProjectileRaycast.RespectCanCollide = true
local Toggles = {}
local old

local function Hook(...)
	local handler

	for _, obj in debug.getstack(3) do
		if type(obj) == 'table' and rawget(obj, 'tuning') then
			handler = obj
			break
		end
	end

	if handler then
		if type(tribes.Handlers) == 'table' then
			for index, obj in next, tribes.Handlers do
				if getmetatable(handler) == obj and not Toggles[index].Enabled then
					return old(...)
				end
			end
		end

		local entity = entitylib.EntityMouse({
			Range = Range.Value,
			Part = Part.Value,
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled,
			Wallcheck = Target.Walls.Enabled and true or nil
		})

		if entity then
			local targetPart = entity[Part.Value]
			local origin = ... or gameCamera.CFrame.Position
			local projSpeed = handler.tuning.speed or (handler.tuning.speedMax or 200)
			local gravity = handler.tuning.gravity or (handler.spreadNow and 0 or 60)
			ProjectileRaycast.FilterDescendantsInstances = {gameCamera, entity.Character}
			ProjectileRaycast.CollisionGroup = targetPart.CollisionGroup

			if handler.drawStart then
				projSpeed = select(2, tribes.Combat.DrawnShot(handler.tuning, debug.getstack(3, 4)))
			end

			if handler.tuning.throw then
				projSpeed = handler.tuning.throw.speed or 120
				gravity = handler.tuning.throw.gravity or 0
			end

			local calc = prediction.SolveTrajectory(origin, projSpeed, math.abs(gravity), targetPart.Position, Prediction.Enabled and VelocityTracker:Get(entity.RootPart) or targetPart.AssemblyLinearVelocity, workspace.Gravity, entity.HipHeight, nil, ProjectileRaycast)
			if calc then
				local lookDir = CFrame.lookAt(origin, calc).LookVector
				targetinfo.Targets[entity] = os.clock() + 1

				if handler.maxCharges then
					return (lookDir - Vector3.new(0, ((handler.kind == 'Bomb') and 0.16) or (((handler.kind == 'Sling') and 0.05) or (((handler.kind ~= 'Javelin') and 0.01) or 0.04)), 0)).Unit
				end

				if handler.tuning.throw then
					local aimPoint = debug.getstack(3, 5)
					local someMag = (aimPoint - origin).Magnitude

					if gravity > 0 and someMag > 1 then
						return (lookDir * someMag - Vector3.new(0, 0.5 * gravity * (someMag / projSpeed) * (someMag / projSpeed), 0)).Unit
					end
				end

				if handler.spreadNow and handler.kind ~= 'Blunderbuss' then
					local spread
					if handler.kind == 'Crossbow' then
						spread = 0
					elseif handler:Aimed() then
						spread = handler.tuning.spreadAim or 0
					else
						spread = handler.tuning.spreadHip or 0
					end

					local spreadDir = tribes.Combat.SpreadDir(lookDir, spread, handler:Seed(tribes.State.shotId + 1), 0)
					return (CFrame.lookAt(Vector3.zero, lookDir) * CFrame.lookAt(Vector3.zero, lookDir):ToObjectSpace(CFrame.lookAt(Vector3.zero, spreadDir)):Inverse()).LookVector
				end

				return lookDir
			end
		end
	end

	return old(...)
end

SilentAim = vape.Categories.Combat:CreateModule({
	Name = 'SilentAim',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback
		end

		if callback then
			old = hookfunction(tribes.Util.AimDirection, function(...)
				return Hook(...)
			end)

			repeat
				if CircleObject then
					CircleObject.Position = inputService:GetMouseLocation()
				end

				task.wait()
			until not SilentAim.Enabled
		else
			if old then
				if restorefunction then
					restorefunction(tribes.Util.AimDirection)
				else
					hookfunction(tribes.Util.AimDirection, old)
				end
				old = nil
			end
		end
	end,
	ExtraText = function()
		return 'Tribes'
	end,
	Tooltip = 'Silently adjusts your aim towards the enemy'
})
Target = SilentAim:CreateTargets({
	Players = true,
	NPCs = true
})
Part = SilentAim:CreateDropdown({
	Name = 'Part',
	List = {'RootPart', 'Head'},
	Tooltip = 'RootPart - Default\nHead - More damage, but harder to hit.'
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
Prediction = SilentAim:CreateToggle({
	Name = 'Velocity prediction'
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
			CircleObject.Visible = SilentAim.Enabled
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

if type(tribes.Handlers) == 'table' then
	for index in next, tribes.Handlers do
		if type(index) == 'string' then
			Toggles[index] = SilentAim:CreateToggle({
				Name = index,
				Default = true,
				Darker = true
			})
		end
	end
end