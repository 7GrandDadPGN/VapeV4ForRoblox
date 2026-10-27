local SilentAura
local Targets
local AttackRange
local AngleSlider
local AutoSwing
local AutoBlock
local BoxAttackColor
local ParticleTexture
local ParticleColor1
local ParticleColor2
local ParticleSize
local Particle, Box = nil, nil
local gamingThread

SilentAura = vape.Categories.Combat:CreateModule({
	Name = 'SilentAura',
	Function = function(callback)
		if callback then
			local old, didSwing

			SilentAura:Clean(runService.PostSimulation:Connect(function()
				gamingThread = task.defer(function()
					local attacked

					if entitylib.isAlive and tribes.State.handler and tribes.State.handler.lastSwing then
						local localPos = entitylib.character.RootPart.Position
						local localFacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
						local entities = entitylib.AllPosition({
							Range = AttackRange.Value,
							Wallcheck = Targets.Walls.Enabled or nil,
							Part = 'RootPart',
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Limit = 10
						})

						if #entities > 0 then
							for _, entity in entities do
								local cmpPos = entity.RootPart.Position
								local delta = (cmpPos - localPos)
								local yaw = select(2, gameCamera.CFrame:ToEulerAnglesYXZ())
								local angle = math.abs(CFrame.fromEulerAnglesYXZ(0, yaw, 0).LookVector:Angle(delta * Vector3.new(1, 0, 1)))

								if angle > (math.rad(AngleSlider.Value) / 2) or delta.Y >= 8 then
									continue
								end

								if AutoSwing.Enabled and not tribes.State.handler.holding then
									local gui = lplr.PlayerGui:FindFirstChild('CombatTouch', true)
									gui = gui and gui.Enabled and gui:FindFirstChild('Attack', true) or nil

									if gui and gui:IsA('TextButton') and gui.Visible then
										local cPos = gui.AbsolutePosition + guiService:GetGuiInset()
										vim:SendTouchEvent(0, 0, cPos.X, cPos.Y)
									else
										vim:SendMouseButtonEvent(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2, 0, true, nil, 0)
									end

									didSwing = true
								end

								attacked = entity
								targetinfo.Targets[entity] = os.clock() + 1
								old = gameCamera.CFrame
								gameCamera.CFrame = CFrame.lookAlong(old.Position, CFrame.lookAt(localPos, cmpPos).LookVector)
								if angle > math.rad(100) then
									entitylib.character.RootPart.CFrame = CFrame.lookAlong(localPos, delta * Vector3.new(1, 0, 1))
								end

								break
							end
						else
							if AutoSwing.Enabled and tribes.State.handler.holding and didSwing then
								local gui = lplr.PlayerGui:FindFirstChild('CombatTouch', true)
								gui = gui and gui.Enabled and gui:FindFirstChild('Attack', true) or nil

								if gui and gui:IsA('TextButton') and gui.Visible then
									local cPos = gui.AbsolutePosition + guiService:GetGuiInset()
									vim:SendTouchEvent(0, 2, cPos.X, cPos.Y)
								else
									vim:SendMouseButtonEvent(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2, 0, false, nil, 0)
								end

								didSwing = false
							end
						end

						--[[if AutoBlock.Enabled and tribes.State.handler.tuning.block then
							if tribes.State.handler:Ready() and #entities > 0 then
								tribes.State.handler:SetBlock(false)
								tribes.State.handler:Swing()
							end

							tribes.State.handler:SetBlock(true)
							if vape.ThreadFix then
								setthreadidentity(8)
							end
						end]]
					end

					if Box then
						Box.Adornee = attacked and attacked.RootPart or nil
						if Box.Adornee then
							Box.Color3 = Color3.fromHSV(BoxAttackColor.Hue, BoxAttackColor.Sat, BoxAttackColor.Value)
							Box.Transparency = 1 - BoxAttackColor.Opacity
						end
					end

					if Particle then
						Particle.Position = attacked and attacked.RootPart.Position or Vector3.new(math.huge, math.huge, math.huge)
						Particle.Parent = attacked and gameCamera or nil
					end

					gamingThread = nil
				end)
			end))

			SilentAura:Clean(runService.Heartbeat:Connect(function()
				if old then
					gameCamera.CFrame = old
					old = nil
				end
			end))
		else
			if gamingThread then
				task.cancel(gamingThread)
				gamingThread = nil
			end

			if Box then
				Box.Adornee = nil
			end

			if Particle then
				Particle.Parent = nil
			end
		end
	end,
	Tooltip = 'Silently adjust your camera towards nearby targets.'
})
Targets = SilentAura:CreateTargets({
	Players = true,
	NPCs = true
})
AttackRange = SilentAura:CreateSlider({
	Name = 'Attack range',
	Min = 1,
	Max = 14,
	Default = 14,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AngleSlider = SilentAura:CreateSlider({
	Name = 'Max angle',
	Min = 1,
	Max = 360,
	Default = 90
})
AutoSwing = SilentAura:CreateToggle({
	Name = 'Auto swing'
})
--[[AutoBlock = SilentAura:CreateToggle({
	Name = 'AutoBlock'
})]]
SilentAura:CreateToggle({
	Name = 'Show target',
	Function = function(callback)
		BoxAttackColor.Object.Visible = callback

		if callback then
			Box = Instance.new('BoxHandleAdornment')
			Box.Adornee = nil
			Box.AlwaysOnTop = true
			Box.CFrame = CFrame.new(0, -0.5, 0)
			Box.Size = Vector3.new(3, 5, 3)
			Box.ZIndex = 0
			Box.Parent = vape.holder
		else
			Box:Destroy()
			Box = nil
		end
	end
})
BoxAttackColor = SilentAura:CreateColorSlider({
	Name = 'Attack Color',
	Darker = true,
	DefaultOpacity = 0.5,
	Visible = false
})
SilentAura:CreateToggle({
	Name = 'Target particles',
	Function = function(callback)
		ParticleTexture.Object.Visible = callback
		ParticleColor1.Object.Visible = callback
		ParticleColor2.Object.Visible = callback
		ParticleSize.Object.Visible = callback

		if callback then
			Particle = Instance.new('Part')
			Particle.Size = Vector3.new(2, 4, 2)
			Particle.Anchored = true
			Particle.CanCollide = false
			Particle.Transparency = 1
			Particle.CanQuery = false
			Particle.Parent = SilentAura.Enabled and gameCamera or nil
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
			particles.Parent = Particle
		else
			Particle:Destroy()
			Particle = nil
		end
	end
})
ParticleTexture = SilentAura:CreateTextBox({
	Name = 'Texture',
	Default = 'rbxassetid://14736249347',
	Function = function()
		if Particle then
			Particle.ParticleEmitter.Texture = ParticleTexture.Value
		end
	end,
	Darker = true,
	Visible = false
})
ParticleColor1 = SilentAura:CreateColorSlider({
	Name = 'Color Begin',
	Function = function(hue, sat, val)
		if Particle then
			Particle.ParticleEmitter.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
			})
		end
	end,
	Darker = true,
	Visible = false
})
ParticleColor2 = SilentAura:CreateColorSlider({
	Name = 'Color End',
	Function = function(hue, sat, val)
		if Particle then
			Particle.ParticleEmitter.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
			})
		end
	end,
	Darker = true,
	Visible = false
})
ParticleSize = SilentAura:CreateSlider({
	Name = 'Size',
	Min = 0,
	Max = 1,
	Default = 0.2,
	Decimal = 100,
	Function = function(val)
		if Particle then
			Particle.ParticleEmitter.Size = NumberSequence.new(val)
		end
	end,
	Darker = true,
	Visible = false
})