local Killaura
local Targets
local SwingRange
local AttackRange
local Angle
local Max
local Mouse
local Limit
local Box
local BoxSwingColor
local BoxAttackColor
local Particle
local ParticleTexture
local ParticleColor1
local ParticleColor2
local ParticleSize
local Boxes = {}
local Particles = {}
local hitdelay = tick()
local didattack = false

local function getAttackData()
	if Mouse.Enabled then
		if not inputService:IsMouseButtonPressed(0) then return false end
	end

	local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
	local knifecheck = gun and gun.type == 2 and true or false
	if Limit.Enabled then
		if not knifecheck then return false end
	end

	return true, knifecheck
end

Killaura = vape.Categories.Blatant:CreateModule({
	Name = 'Killaura',
	Function = function(callback)
		if callback then
			repeat
				local suc, knifecheck = getAttackData()
				local attacked = {}
				local prevattack = didattack
				didattack = false
				if suc then
					local plrs = entitylib.AllPosition({
						Range = SwingRange.Value,
						Wallcheck = Targets.Walls.Enabled or nil,
						Part = 'RootPart',
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Limit = Max.Value
					})

					if #plrs > 0 then
						local gun = frontlines.Main.globals.fpv_sol_equipment.curr_equipment
						local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

						for i, v in plrs do
							local delta = (v.RootPart.Position - entitylib.character.RootPart.Position)
							local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
							if angle > (math.rad(Angle.Value) / 2) then continue end
							table.insert(attacked, {Entity = v, Check = delta.Magnitude > AttackRange.Value and BoxSwingColor or BoxAttackColor})
							targetinfo.Targets[v] = tick() + 1

							if delta.Magnitude > AttackRange.Value then continue end
							didattack = knifecheck
							if hitdelay < tick() then
								local id, part
								for i2, v2 in frontlines.Main.globals.soldier_hitbox_hash do
									if i2.Weld.Part0 == v.RootPart then
										id, part = v2, i2
										break
									end
								end

								if id then
									hitdelay = tick() + 0.1
									frontlines.Main.utils.net_msg_util.c_prep_net_msg(frontlines.Main.globals.combat_net_msg_state, frontlines.Main.enums.c_net_msg.MELEE_HIT_SOL, id)
									if knifecheck then
										frontlines.Main.globals.ctrl_states.trigger = true
										frontlines.Main.globals.ctrl_ts.trigger = time()
										frontlines.Main.exe_set(frontlines.Main.exe_set_t.FPV_SOL_MELEE_SOL_HIT, gun, part, Vector3.zero)
										if vape.ThreadFix then 
											setthreadidentity(8) 
										end
									end
								end
							end
						end
					end
				end

				if didattack ~= prevattack and prevattack then
					frontlines.Main.globals.ctrl_states.trigger = false
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
			for i, v in Boxes do 
				v.Adornee = nil 
			end
			for i, v in Particles do 
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
	Max = 8,
	Default = 8,
	Suffix = function(val) 
		return val == 1 and 'stud' or 'studs' 
	end
})
AttackRange = Killaura:CreateSlider({
	Name = 'Attack range',
	Min = 1,
	Max = 8,
	Default = 8,
	Suffix = function(val) 
		return val == 1 and 'stud' or 'studs' 
	end
})
Angle = Killaura:CreateSlider({
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
Limit = Killaura:CreateToggle({Name = 'Knife only'})
Box = Killaura:CreateToggle({
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
			for i, v in Boxes do 
				v:Destroy() 
			end
			table.clear(Boxes)
		end
	end
})
BoxSwingColor = Killaura:CreateColorSlider({
	Name = 'Target Color',
	Darker = true,
	Visible = false,
	DefaultHue = 0.6,
	DefaultOpacity = 0.5
})
BoxAttackColor = Killaura:CreateColorSlider({
	Name = 'Attack Color',
	Darker = true,
	Visible = false,
	DefaultOpacity = 0.5
})
Particle = Killaura:CreateToggle({
	Name = 'Target particles',
	Function = function(callback)
		ParticleTexture.Object.Visible = callback
		ParticleColor1.Object.Visible = callback
		ParticleColor2.Object.Visible = callback
		ParticleSize.Object.Visible = callback
		if callback then
			for i = 1, 10 do
				local part = Instance.new('Part')
				part.Size = Vector3.one
				part.Anchored = true
				part.CanCollide = false
				part.Transparency = 1
				part.CanQuery = false
				part.Parent = Killaura.Enabled and gameCamera or nil
				local particles = Instance.new('ParticleEmitter')
				particles.Brightness = 1.5
				particles.Size = NumberSequence.new(ParticleSize.Value)
				particles.Texture = ParticleTexture.Value
				particles.Transparency = NumberSequence.new(0, 1)
				particles.Lifetime = NumberRange.new(0.4)
				particles.Rate = 1000
				particles.Speed = NumberRange.new(12)
				particles.Drag = 6
				particles.Shape = Enum.ParticleEmitterShape.Sphere
				particles.ShapePartial = 1
				particles.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)), 
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
				particles.Parent = part
				Particles[i] = part
			end
		else
			for i, v in Particles do 
				v:Destroy() 
			end
			table.clear(Particles)
		end
	end
})
ParticleTexture = Killaura:CreateTextBox({
	Name = 'Texture',
	Default = 'rbxassetid://14736249347',
	Function = function(val)
		for i, v in Particles do
			v.ParticleEmitter.Texture = ParticleTexture.Value
		end
	end,
	Darker = true,
	Visible = false
})
ParticleColor1 = Killaura:CreateColorSlider({
	Name = 'Color Begin',
	Function = function(hue, sat, val)
		for i, v in Particles do
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
		for i, v in Particles do
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
	Default = 0.25,
	Decimal = 100,
	Function = function(val)
		for i, v in Particles do
			v.ParticleEmitter.Size = NumberSequence.new(val)
		end
	end,
	Darker = true,
	Visible = false
})