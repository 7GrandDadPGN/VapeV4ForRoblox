local AimAssist
local Targets
local Part
local FOV
local Speed
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local RightClick
local ShowTarget
local moveConst = Vector2.new(1, 0.77) * math.rad(0.5)

local function wrapAngle(num)
	num = num % math.pi
	num -= num >= (math.pi / 2) and math.pi or 0
	num += num < -(math.pi / 2) and math.pi or 0
	return num
end

AimAssist = vape.Categories.Combat:CreateModule({
	Name = 'AimAssist',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback
		end

		if callback then
			local ent
			local rightClicked = not RightClick.Enabled or inputService:IsMouseButtonPressed(1)
			AimAssist:Clean(runService.RenderStepped:Connect(function(dt)
				if CircleObject then
					CircleObject.Position = inputService:GetMouseLocation()
				end

				if rightClicked and not vape.gui.ScaledGui.ClickGui.Visible then
					ent = entitylib.EntityMouse({
						Range = FOV.Value,
						Part = Part.Value,
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Wallcheck = Targets.Walls.Enabled,
						Origin = gameCamera.CFrame.Position
					})

					if ent then
						local facing = gameCamera.CFrame.LookVector
						local new = (ent[Part.Value].Position - gameCamera.CFrame.Position).Unit
						new = new == new and new or Vector3.zero

						if ShowTarget.Enabled then
							targetinfo.Targets[ent] = tick() + 1
						end

						if new ~= Vector3.zero then
							local diffYaw = wrapAngle(math.atan2(facing.X, facing.Z) - math.atan2(new.X, new.Z))
							local diffPitch = math.asin(facing.Y) - math.asin(new.Y)
							local angle = Vector2.new(diffYaw, diffPitch) // (moveConst * UserSettings():GetService('UserGameSettings').MouseSensitivity)

							angle *= math.min(Speed.Value * dt, 1)
							mousemoverel(angle.X, angle.Y)
						end
					end
				end
			end))

			if RightClick.Enabled then
				AimAssist:Clean(inputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						ent = nil
						rightClicked = true
					end
				end))

				AimAssist:Clean(inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						rightClicked = false
					end
				end))
			end
		end
	end,
	Tooltip = 'Smoothly aims to closest valid target'
})
Targets = AimAssist:CreateTargets({Players = true})
Part = AimAssist:CreateDropdown({
	Name = 'Part',
	List = {'RootPart', 'Head'}
})
FOV = AimAssist:CreateSlider({
	Name = 'FOV',
	Min = 0,
	Max = 1000,
	Default = 100,
	Function = function(val)
		if CircleObject then
			CircleObject.Radius = val
		end
	end
})
Speed = AimAssist:CreateSlider({
	Name = 'Speed',
	Min = 0,
	Max = 30,
	Default = 15
})
AimAssist:CreateToggle({
	Name = 'Range Circle',
	Function = function(callback)
		if callback then
			CircleObject = Drawing.new('Circle')
			CircleObject.Filled = CircleFilled.Enabled
			CircleObject.Color = Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value)
			CircleObject.Position = vape.gui.AbsoluteSize / 2
			CircleObject.Radius = FOV.Value
			CircleObject.NumSides = 100
			CircleObject.Transparency = 1 - CircleTransparency.Value
			CircleObject.Visible = AimAssist.Enabled
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
CircleColor = AimAssist:CreateColorSlider({
	Name = 'Circle Color',
	Function = function(hue, sat, val)
		if CircleObject then
			CircleObject.Color = Color3.fromHSV(hue, sat, val)
		end
	end,
	Darker = true,
	Visible = false
})
CircleTransparency = AimAssist:CreateSlider({
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
CircleFilled = AimAssist:CreateToggle({
	Name = 'Circle Filled',
	Function = function(callback)
		if CircleObject then
			CircleObject.Filled = callback
		end
	end,
	Darker = true,
	Visible = false
})
RightClick = AimAssist:CreateToggle({
	Name = 'Require right click',
	Function = function()
		if AimAssist.Enabled then
			AimAssist:Toggle()
			AimAssist:Toggle()
		end
	end
})
ShowTarget = AimAssist:CreateToggle({
	Name = 'Show target info'
})