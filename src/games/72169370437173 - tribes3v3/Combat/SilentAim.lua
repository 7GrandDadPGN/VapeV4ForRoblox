local SilentAim
local Target
local Range
local HitChance
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local old

local function Hook(...)
	local tuning

	for _, obj in debug.getstack(3) do
		if type(obj) == 'table' and rawget(obj, 'tuning') then
			tuning = obj
			break
		end
	end

	if tuning then
		local entity = entitylib.EntityMouse({
			Range = Range.Value,
			Part = 'RootPart',
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled
		})

		if entity then
			local targetPart = entity.RootPart
			local origin = ... or gameCamera.CFrame.Position
			local projSpeed = tuning.tuning.speed or (tuning.tuning.speedMax or 200)

			if tuning.drawSound then
				projSpeed = select(2, tribes.Combat.DrawnShot(tuning.tuning, debug.getstack(3, 4)))
			end

			local calc = prediction.SolveTrajectory(origin, projSpeed, math.abs(tuning.tuning.gravity or 60), targetPart.Position, entity.RootPart.AssemblyLinearVelocity)
			if calc then
				targetinfo.Targets[entity] = os.clock() + 1
				return CFrame.lookAt(origin, calc).LookVector
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