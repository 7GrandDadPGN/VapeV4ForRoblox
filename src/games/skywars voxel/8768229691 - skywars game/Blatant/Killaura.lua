local Killaura
local Targets
local AttackRange
local AngleCheck
local Max
local Mouse
local Limit
local Swing
local BoxAttackColor
local ParticleTexture
local ParticleColor1
local ParticleColor2
local ParticleSize
local Animation
local AnimationMode
local AnimationSpeed
local AnimationTween
local AnimTween
local Attacking
local Particles, Boxes = {}, {}
local anims, armC0 = vape.Libraries.auraanims

local function getAttackData()
	if Mouse.Enabled then
		if inputService:IsMouseButtonPressed(0) then return false end
	end

	return (not Limit.Enabled) and store.tools.sword or store.hand
end

Killaura = vape.Categories.Blatant:CreateModule({
	Name = 'Killaura',
	Function = function(callback)
		if callback then
			if Animation.Enabled then
				task.spawn(function()
					local started = false
					repeat
						if ViewmodelMotor then
							if Attacking then
								if not armC0 then armC0 = ViewmodelMotor.C0 end
								local first = not started
								started = true

								if AnimationMode.Value == 'Random' then
									anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
								end

								for _, v in anims[AnimationMode.Value] do
									AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / AnimationSpeed.Value, Enum.EasingStyle.Linear), {
										C0 = armC0 * v.CFrame
									})
									AnimTween:Play()
									AnimTween.Completed:Wait()
									first = false
									if (not Killaura.Enabled) or (not Attacking) then break end
								end
							elseif started then
								started = false
								AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
									C0 = armC0
								})
								AnimTween:Play()
							end
						end

						if not started then
							task.wait(1 / 60)
						end
					until (not Killaura.Enabled) or (not Animation.Enabled)
				end)
			end

			repeat
				local attacked = {}
				local tool = getAttackData()
				if tool and tool.Melee then
					local plrs = entitylib.AllPosition({
						Range = AttackRange.Value,
						Wallcheck = Targets.Walls.Enabled or nil,
						Part = 'RootPart',
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Limit = Max.Value
					})
					local switched = false

					if #plrs > 0 then
						local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
						store.noShoot = tick() + 1

						for i, v in plrs do
							local delta = (v.RootPart.Position - entitylib.character.RootPart.Position)
							local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
							if angle > (math.rad(AngleCheck.Value) / 2) then continue end
							table.insert(attacked, v)
							targetinfo.Targets[v] = tick() + 1

							if not Swing.Enabled then
								skywars.MeleeController:playAnimation(lplr.Character, tool)
							end

							if not switched then
								switched = true
								skywars.Remotes[remotes.updateActiveItem]:fire(tool.Name)
							end

							skywars.Remotes[remotes.strikeDesktop]:fire(v.Player)
						end
					end

					if switched then
						skywars.Remotes[remotes.updateActiveItem](store.hand.Name)
					end
				end

				Attacking = #attacked > 0
				if Attacking and vape.ThreadFix then
					setthreadidentity(8)
				end

				for i, v in Boxes do
					v.Adornee = attacked[i] and attacked[i].RootPart or nil
					if v.Adornee then
						v.Color3 = Color3.fromHSV(BoxAttackColor.Hue, BoxAttackColor.Sat, BoxAttackColor.Value)
						v.Transparency = 1 - BoxAttackColor.Opacity
					end
				end

				for i, v in Particles do
					v.Position = attacked[i] and attacked[i].RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
					v.Parent = attacked[i] and gameCamera or nil
				end

				task.wait(0.05)
			until not Killaura.Enabled
		else
			for i, v in Boxes do
				v.Adornee = nil
			end
			for i, v in Particles do
				v.Parent = nil
			end
			if armC0 and ViewmodelMotor then
				AnimTween = tweenService:Create(ViewmodelMotor, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
					C0 = armC0
				})
				AnimTween:Play()
			end
		end
	end,
	Tooltip = 'Attack players around you\nwithout aiming at them.'
})
Targets = Killaura:CreateTargets({Players = true})
AttackRange = Killaura:CreateSlider({
	Name = 'Attack range',
	Min = 1,
	Max = 18,
	Default = 18,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AngleCheck = Killaura:CreateSlider({
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
Killaura:CreateToggle({
	Name = 'Show target',
	Function = function(callback)
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
Animation = Killaura:CreateToggle({
	Name = 'Custom Animation',
	Function = function(callback)
		AnimationMode.Object.Visible = callback
		AnimationTween.Object.Visible = callback
		AnimationSpeed.Object.Visible = callback
		if Killaura.Enabled then
			Killaura:Toggle()
			Killaura:Toggle()
		end
	end
})
local animnames = {}
for i in anims do
	table.insert(animnames, i)
end
AnimationMode = Killaura:CreateDropdown({
	Name = 'Animation Mode',
	List = animnames,
	Darker = true,
	Visible = false
})
AnimationSpeed = Killaura:CreateSlider({
	Name = 'Animation Speed',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 10,
	Darker = true,
	Visible = false
})
AnimationTween = Killaura:CreateToggle({
	Name = 'No Tween',
	Darker = true,
	Visible = false
})
Limit = Killaura:CreateToggle({
	Name = 'Limit to items',
	Tooltip = 'Only attacks when the sword is held'
})