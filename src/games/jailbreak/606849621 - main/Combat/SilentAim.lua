local SilentAim
local Target
local Mode
local Range
local HitChance
local HeadshotChance
local CircleColor
local CircleTransparency
local CircleFilled
local CircleObject
local Instant
local Hooked
local ProjectileRaycast = RaycastParams.new()
ProjectileRaycast.RespectCanCollide = true

SilentAim = vape.Categories.Combat:CreateModule({
	Name = 'SilentAim',
	Function = function(callback)
		if CircleObject then
			CircleObject.Visible = callback and Mode.Value == 'Mouse'
		end

		if callback then
			Hooked = jb.GunController.TransformLocalMousePosition
			jb.GunController.TransformLocalMousePosition = function(self, pos)
				local ent = entitylib['Entity'..Mode.Value]({
					Range = Range.Value,
					Wallcheck = Target.Walls.Enabled and (obj or true) or nil,
					Part = 'RootPart',
					Origin = entitylib.isAlive and entitylib.character.RootPart.Position or nil,
					Players = Target.Players.Enabled,
					NPCs = Target.NPCs.Enabled
				})

				if ent then
					local item = jb.ItemSystemController:GetLocalEquipped()
					if item and ((self.Tip.CFrame.Position - ent.RootPart.Position).Magnitude / (item.Config.BulletSpeed or 1000)) < item.BulletEmitter.LifeSpan then
						ProjectileRaycast.FilterDescendantsInstances = {gameCamera, ent.Character, workspace.Vehicles}
						ProjectileRaycast.CollisionGroup = ent.RootPart.CollisionGroup
						local calc = prediction.SolveTrajectory(self.Tip.CFrame.Position, item.Config.BulletSpeed or 1000, math.abs(item.BulletEmitter.GravityVector.Y), ent.RootPart.Position, Instant.Enabled and Vector3.zero or ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, nil, ProjectileRaycast)
						if calc then
							targetinfo.Targets[ent] = tick() + 1
							return calc
						end
					end
				end

				return pos
			end

			repeat
				if CircleObject then
					CircleObject.Position = inputService:GetMouseLocation()
				end

				if Instant.Enabled then
					local item = jb.ItemSystemController:GetLocalEquipped()
					if item and item.BulletEmitter then
						rawset(item.BulletEmitter, 'LastUpdate', tick() - (item.BulletEmitter.LifeSpan - 0.1))
					end
				end

				task.wait()
			until not SilentAim.Enabled
		else
			jb.GunController.TransformLocalMousePosition = Hooked
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
Instant = SilentAim:CreateToggle({Name = 'Hitscan Bullets'})