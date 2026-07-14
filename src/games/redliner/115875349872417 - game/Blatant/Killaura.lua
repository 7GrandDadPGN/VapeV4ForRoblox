local Killaura
local Targets
local AttackRange
local AngleSlider
local AutoSwing
local BoxAttackColor
local ParticleTexture
local ParticleColor1
local ParticleColor2
local ParticleSize
local Overlay = OverlapParams.new()
Overlay.FilterType = Enum.RaycastFilterType.Include
Overlay.RespectCanCollide = false
local Particles, Boxes = {}, {}
local anims = {
	[replicatedStorage.Assets.Animations:FindFirstChild('3P_Parry', true).AnimationId] = true
}

local function getTarget()
	local selfpos = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
	local localfacing = gameCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
	local ent = entitylib.EntityPosition({
		Range = AttackRange.Value,
		Part = 'RootPart',
		Players = Targets.Players.Enabled,
		NPCs = Targets.NPCs.Enabled
	})

	if ent then
		local delta = (ent.RootPart.Position - selfpos)
		local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
		if angle > (math.rad(AngleSlider.Value) / 2) then
			return
		end

		return ent
	end
end

local function shouldAttack(ent)
	if playersService.NumPlayers <= 2 then
		for i, v in next, getIndicators() do
			if v.indicator_type == 'surefire_bullet' or v.indicator_type == 'timing_only' then
				local timediff = (v.expected_shot_time - os.clock())
				if timediff < 0.4 then
					return false
				end
			end
		end
	end

	local animator = ent.Humanoid:FindFirstChildWhichIsA('Animator')
	if animator then
		for _, track in animator:GetPlayingAnimationTracks() do
			if track.IsPlaying and anims[track.Animation.AnimationId] then
				return false
			end
		end
	end

	local origin = CFrame.lookAt(entitylib.character.RootPart.Position + Vector3.new(0, 2, 0), ent.RootPart.Position)
	for _, box in redline_boxes do
		if #castHitbox(box.data, origin) > 0 then
			return true
		end
	end

	return false
end

Killaura = vape.Categories.Blatant:CreateModule({
	Name = 'Killaura',
	Function = function(callback)
		if callback then
			SendHook:Add('Killaura', function(args)
				local self = args[1]
				if self and rawget(self, 'Name') == redline.AttackPacket and typeof(args[5]) == 'Vector3' then
					local ent = getTarget()

					if ent then
						local origin = CFrame.lookAt(entitylib.character.RootPart.Position + Vector3.new(0, 2, 0), ent.Hitbox.Position)
						for _, box in redline_boxes do
							if #castHitbox(box.data, origin) > 0 then
								args[5] = origin.LookVector
								break
							end
						end
					end
				end
			end, 1)

			repeat
				local attacked = {}
				if game.PlaceId ~= 94987506187454 then
					local ent = getTarget()

					if ent and shouldAttack(ent) then
						table.insert(attacked, {
							Entity = ent,
							Check = BoxAttackColor
						})

						targetinfo.Targets[ent] = tick() + 1
						if AutoSwing.Enabled then
							task.spawn(function()
								redline.ActionFunction(redline[redline.ActionController], 'MELEE').Pressed:Fire()
							end)
						end
					end
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

				task.wait(0.016)
			until not Killaura.Enabled
		else
			SendHook:Remove('Killaura')

			for _, v in Boxes do
				v.Adornee = nil
			end

			for _, v in Particles do
				v.Parent = nil
			end
		end
	end,
	Tooltip = 'Attack players around you\nwithout aiming at them.'
})
Targets = Killaura:CreateTargets({Players = true})
AttackRange = Killaura:CreateSlider({
	Name = 'Attack range',
	Min = 1,
	Max = 40,
	Default = 40,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AngleSlider = Killaura:CreateSlider({
	Name = 'Max angle',
	Min = 1,
	Max = 360,
	Default = 360
})
AutoSwing = Killaura:CreateToggle({
	Name = 'Auto Swing',
	Default = true
})
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
			for _, v in Boxes do
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
	Default = 0.2,
	Decimal = 100,
	Function = function(val)
		for _, v in Particles do
			v.ParticleEmitter.Size = NumberSequence.new(val)
		end
	end,
	Darker = true,
	Visible = false
})