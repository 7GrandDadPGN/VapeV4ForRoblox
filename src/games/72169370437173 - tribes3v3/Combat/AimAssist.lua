local AimAssist
local Targets
local Sort
local AimSpeed
local Distance
local AngleSlider
local StrafeIncrease
local Vertical
local ClickAim
local moveConst = Vector2.new(1, 0.77) * math.rad(0.5)

local function wrapAngle(num)
	return (num + math.pi % math.tau) - math.pi
end

AimAssist = vape.Categories.Combat:CreateModule({
	Name = 'AimAssist',
	Function = function(callback)
		if callback then
			AimAssist:Clean(runService.Heartbeat:Connect(function(dt)
				local lastSwing = entitylib.isAlive and rawget(tribes.State, 'handler')
				lastSwing = lastSwing and rawget(lastSwing, 'lastSwing') or nil

				if lastSwing and ((not ClickAim.Enabled) or (os.clock() - (lastSwing or 0)) < 0.5) then
					local entity = entitylib.EntityPosition({
						Range = Distance.Value,
						Part = 'RootPart',
						Wallcheck = Targets.Walls.Enabled,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled
					})

					if entity and inputService.MouseBehavior == Enum.MouseBehavior.LockCenter and not (guiService.MenuIsOpen or vape.gui.ScaledGui.ClickGui.Visible) then
						local delta = (entity.RootPart.Position - entitylib.character.RootPart.Position)
						local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
						local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
						if angle >= (math.rad(AngleSlider.Value) / 2) then return end
						targetinfo.Targets[entity] = os.clock() + 1

						local facing = gameCamera.CFrame.LookVector
						local lerped = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.Position, entity.RootPart.Position), (AimSpeed.Value + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 0)) * dt).LookVector
						local diffYaw = wrapAngle(math.atan2(facing.X, facing.Z) - math.atan2(lerped.X, lerped.Z))
						local diffPitch = math.asin(facing.Y) - math.asin(lerped.Y)
						local angle = Vector2.new(diffYaw, diffPitch) // (moveConst * UserSettings():GetService('UserGameSettings').MouseSensitivity)
						vim:SendMouseMoveDeltaEvent(angle.X, Vertical.Enabled and angle.Y or 0, nil)
					end
				end
			end))
		end
	end,
	Tooltip = 'Smoothly aims to closest valid target with sword'
})
Targets = AimAssist:CreateTargets({
	Players = true,
	NPCs = true,
	Walls = true
})
AimSpeed = AimAssist:CreateSlider({
	Name = 'Aim Speed',
	Min = 1,
	Max = 20,
	Default = 6
})
Distance = AimAssist:CreateSlider({
	Name = 'Distance',
	Min = 1,
	Max = 30,
	Default = 30,
	Suffx = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AngleSlider = AimAssist:CreateSlider({
	Name = 'Max angle',
	Min = 1,
	Max = 360,
	Default = 70
})
ClickAim = AimAssist:CreateToggle({
	Name = 'Click Aim',
	Default = true
})
Vertical = AimAssist:CreateToggle({
	Name = 'Vertical Aim'
})
StrafeIncrease = AimAssist:CreateToggle({
	Name = 'Strafe increase'
})