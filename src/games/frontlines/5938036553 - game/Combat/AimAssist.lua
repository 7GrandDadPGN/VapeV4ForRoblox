local AimAssist
local FOV
local Speed
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true

AimAssist = vape.Categories.Combat:CreateModule({
	Name = 'AimAssist',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback
		end
		if callback then 
			repeat
				local dt = task.wait()
				if not AimAssist.Enabled then break end
				if CircleObject then 
					CircleObject.Position = inputService:GetMouseLocation() 
				end

				if inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then 
					local origin = entitylib.isAlive and frontlines.Main.globals.fpv_sol_instances.camera_bone.WorldPosition or Vector3.zero
					local ent = entitylib.EntityMouse({
						Range = FOV.Value,
						Players = true,
						Wallcheck = true,
						Part = 'RootPart',
						Origin = origin
					})

					if ent then 
						local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
						if gun and gun.fire_params then
							rayCheck.FilterDescendantsInstances = {gameCamera, ent.Character}
							rayCheck.CollisionGroup = ent.RootPart.CollisionGroup
							local velo = gun.fire_params.muzzle_velocity
							local targetpos = ent.RootPart.Root_M.Spine1_M.Spine2_M.Chest_M.Neck_M.Head_M.WorldCFrame.Position
							local calc = prediction.SolveTrajectory(origin, velo, workspace.Gravity, targetpos, Vector3.zero, workspace.Gravity, ent.HipHeight, nil, rayCheck)
							
							if calc then 
								local pos = gameCamera:WorldToViewportPoint(calc)
								local localmouse = (inputService:GetMouseLocation() - Vector2.new(pos.X, pos.Y)) * dt * (Speed.Value / 10000)
								targetinfo.Targets[ent] = tick() + 1
								frontlines.Main.exe_set(frontlines.Main.exe_set_t.CTRL_SOL_ATT_ROT, localmouse.Y, localmouse.X)
							end
						end
					end
				end
			until not AimAssist.Enabled
		end
	end,
	Tooltip = 'Uses game functions to move the camera towards players'
})
FOV = AimAssist:CreateSlider({
	Name = 'FOV',
	Min = 1,
	Max = 1000,
	Default = 300,
	Function = function(val)
		if CircleObject then
			CircleObject.Radius = val
		end
	end
})
Speed = AimAssist:CreateSlider({
	Name = 'Speed',
	Min = 1,
	Max = 100,
	Default = 10
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
