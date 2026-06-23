local AimAssist
local Targets
local Sort
local AimSpeed
local Distance
local AngleSlider
local StrafeIncrease
local KillauraTarget
local ClickAim

AimAssist = vape.Categories.Combat:CreateModule({
	Name = 'AimAssist',
	Function = function(callback)
		if callback then
			AimAssist:Clean(runService.Heartbeat:Connect(function(dt)
				if entitylib.isAlive and store.hand.toolType == 'sword' and ((not ClickAim.Enabled) or (tick() - bedwars.SwordController.lastSwing) < 0.4) then
					local ent = not KillauraTarget.Enabled and entitylib.EntityPosition({
						Range = Distance.Value,
						Part = 'RootPart',
						Wallcheck = Targets.Walls.Enabled,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Sort = sortmethods[Sort.Value]
					}) or store.KillauraTarget

					if ent then
						local delta = (ent.RootPart.Position - entitylib.character.RootPart.Position)
						local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
						local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
						if angle >= (math.rad(AngleSlider.Value) / 2) then return end
						targetinfo.Targets[ent] = tick() + 1
						gameCamera.CFrame = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.p, ent.RootPart.Position), (AimSpeed.Value + (StrafeIncrease.Enabled and (inputService:IsKeyDown(Enum.KeyCode.A) or inputService:IsKeyDown(Enum.KeyCode.D)) and 10 or 0)) * dt)
					end
				end
			end))
		end
	end,
	Tooltip = 'Smoothly aims to closest valid target with sword'
})
Targets = AimAssist:CreateTargets({
	Players = true,
	Walls = true
})
local methods = {'Damage', 'Distance'}
for i in sortmethods do
	if not table.find(methods, i) then
		table.insert(methods, i)
	end
end
Sort = AimAssist:CreateDropdown({
	Name = 'Target Mode',
	List = methods
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
KillauraTarget = AimAssist:CreateToggle({
	Name = 'Use killaura target'
})
StrafeIncrease = AimAssist:CreateToggle({Name = 'Strafe increase'})