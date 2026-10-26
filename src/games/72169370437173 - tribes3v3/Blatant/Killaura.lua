local Killaura
local Targets
local AttackRange
local AngleSlider
local Max
local Mouse
local AutoBlock
local BoxSwingColor
local BoxAttackColor
local ParticleTexture
local ParticleColor1
local ParticleColor2
local ParticleSize
local Particles, Boxes, AttackDelay = {}, {}, os.clock()
local rand = Random.new()

local function getAttackData()
	if Mouse.Enabled then
		if not inputService:IsMouseButtonPressed(0) then return false end
	end

	if tribes.State.handler and tribes.State.handler.lastSwing then
		return tribes.State.handler.ctx.tool
	end
end

local function sanitizeAngle(cf)
	local y, x, z = cf:ToEulerAnglesYXZ()
	return CFrame.Angles(math.clamp(y, -1.3962634015954636, 1.361356816555577), x, z).LookVector
end

Killaura = vape.Categories.Blatant:CreateModule({
	Name = 'Killaura',
	Function = function(callback)
		if callback then
			repeat
				local tool = getAttackData()
				local attacked = {}

				if tool then
					local handler = tribes.State.handler
					local entities = entitylib.AllPosition({
						Range = AttackRange.Value,
						Wallcheck = Targets.Walls.Enabled or nil,
						Part = 'RootPart',
						Players = Targets.Players.Enabled,
						NPCs = Targets.NPCs.Enabled,
						Limit = Max.Value
					})

					if #entities > 0 then
						local localPos = entitylib.character.RootPart.Position
						local localFacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

						for _, entity in entities do
							local delta = (entity.RootPart.Position - localPos)
							local angle = math.abs(localFacing:Angle(delta * Vector3.new(1, 0, 1)))
							if angle > (math.rad(AngleSlider.Value) / 2) then
								continue
							end

							targetinfo.Targets[entity] = os.clock() + 1
							if #attacked < (handler.tuning.maxTargets or 1) then
								table.insert(attacked, {
									Entity = entity,
									Check = BoxAttackColor
								})
							end
						end

						if #attacked > 0 then
							local cmpPos = attacked[1].Entity.RootPart.Position
							local delta = (cmpPos - localPos)
							local angle = math.abs(localFacing:Angle(delta * Vector3.new(1, 0, 1)))
							if angle > math.rad(100) / 2 then
								entitylib.character.RootPart.CFrame = CFrame.lookAlong(localPos, delta * Vector3.new(1, 0, 1))
							end

							handler.lastSwing = os.clock()
							if AttackDelay < os.clock() and (AutoBlock.Enabled or not tribes.State.handler.blocking) then
								local targets = {}
								local cooldown = handler:Cooldown()
								local hitDelay = handler.preset.hitDelay or 0.1

								AttackDelay = os.clock() + cooldown
								for _, data in attacked do
									table.insert(targets, data.Entity.Character)
								end

								if AutoBlock.Enabled and handler.tuning.block then
									tribes.State.handler:SetBlock(false)
								end

								local oneHanded = handler:OneHanded()
								local comboTable = oneHanded and (handler.tuning.oneHanded.combo or {1}) or (handler.tuning.combo or {1})
								local animTable = oneHanded and handler.preset.oneSwings or handler.preset.swings or {}
								handler.combo = (handler.combo % #comboTable) + 1
								local finisher = (#comboTable > 2) and (handler.combo == #comboTable)
								local fakeTime = os.clock() - (hitDelay + (rand:NextNumber() * 0.02) - 0.01)
								tribes.Util.PlayAnim(handler.ctx.animator, animTable[((handler.combo - 1) % math.max(1, #animTable)) + 1], (handler.preset.swingSpeed or 1) * (finisher and 0.95 or 1), 0.05)

								handler.ctx.emit('Swing', {
									step = handler.combo,
									finisher = finisher,
									hitDelay = hitDelay,
									oneHanded = oneHanded
								})

								handler.ctx.send('Swing', {
									dir = sanitizeAngle(CFrame.lookAt(localPos + Vector3.new(0, 1.5, 0), attacked[1].Entity.RootPart.Position)),
									tool = tool,
									hits = targets,
									k = math.floor((os.clock() - fakeTime) * 1000),
									w = math.floor(fakeTime * 1000) % 9973
								})

								if AutoBlock.Enabled and handler.tuning.block then
									handler:SetBlock(true)
								end

								if vape.ThreadFix then
									setthreadidentity(8)
								end
							end
						end
					elseif AutoBlock.Enabled and handler.tuning.block then
						if tribes.Util.CanAct() then
							handler:SetBlock(true)
						end

						if vape.ThreadFix then
							setthreadidentity(8)
						end
					end
				end

				for index, box in Boxes do
					box.Adornee = attacked[index] and attacked[index].Entity.RootPart or nil
					if box.Adornee then
						box.Color3 = Color3.fromHSV(attacked[index].Check.Hue, attacked[index].Check.Sat, attacked[index].Check.Value)
						box.Transparency = 1 - attacked[index].Check.Opacity
					end
				end

				for index, particle in Particles do
					particle.Position = attacked[index] and attacked[index].Entity.RootPart.Position or Vector3.new(math.huge, math.huge, math.huge)
					particle.Parent = attacked[index] and gameCamera or nil
				end

				task.wait()
			until not Killaura.Enabled
		else
			for _, box in Boxes do
				box.Adornee = nil
			end

			for _, particle in Particles do
				particle.Parent = nil
			end
		end
	end,
	Tooltip = 'Attack players around you\nwithout aiming at them.'
})
Targets = Killaura:CreateTargets({
	Players = true,
	NPCs = true
})
AttackRange = Killaura:CreateSlider({
	Name = 'Attack range',
	Min = 1,
	Max = 14,
	Default = 14,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AngleSlider = Killaura:CreateSlider({
	Name = 'Max angle',
	Min = 1,
	Max = 360,
	Default = 90
})
Max = Killaura:CreateSlider({
	Name = 'Max targets',
	Min = 1,
	Max = 10,
	Default = 10
})
Mouse = Killaura:CreateToggle({
	Name = 'Require mouse down'
})
AutoBlock = Killaura:CreateToggle({
	Name = 'AutoBlock'
})
Killaura:CreateToggle({
	Name = 'Show target',
	Function = function(callback)
		BoxSwingColor.Object.Visible = callback
		BoxAttackColor.Object.Visible = callback

		if callback then
			for i = 1, 10 do
				local box = Instance.new('BoxHandleAdornment')
				box.Adornee = nil
				box.AlwaysOnTop = true
				box.CFrame = CFrame.new(0, -0.5, 0)
				box.Size = Vector3.new(3, 5, 3)
				box.ZIndex = 0
				box.Parent = vape.holder
				Boxes[i] = box
			end
		else
			for _, box in Boxes do
				box:Destroy()
			end
			table.clear(Boxes)
		end
	end
})
BoxSwingColor = Killaura:CreateColorSlider({
	Name = 'Target Color',
	Darker = true,
	DefaultHue = 0.6,
	DefaultOpacity = 0.5,
	Visible = false
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
			for _, particle in Particles do
				particle:Destroy()
			end
			table.clear(Particles)
		end
	end
})
ParticleTexture = Killaura:CreateTextBox({
	Name = 'Texture',
	Default = 'rbxassetid://14736249347',
	Function = function()
		for _, particle in Particles do
			particle.ParticleEmitter.Texture = ParticleTexture.Value
		end
	end,
	Darker = true,
	Visible = false
})
ParticleColor1 = Killaura:CreateColorSlider({
	Name = 'Color Begin',
	Function = function(hue, sat, val)
		for _, particle in Particles do
			particle.ParticleEmitter.Color = ColorSequence.new({
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
		for _, particle in Particles do
			particle.ParticleEmitter.Color = ColorSequence.new({
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
		for _, particle in Particles do
			particle.ParticleEmitter.Size = NumberSequence.new(val)
		end
	end,
	Darker = true,
	Visible = false
})