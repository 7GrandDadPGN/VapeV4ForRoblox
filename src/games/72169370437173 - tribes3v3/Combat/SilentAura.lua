local SilentAura
local Targets
local AttackRange
local AngleSlider
local AutoSwing
local AutoBlock

SilentAura = vape.Categories.Combat:CreateModule({
	Name = 'SilentAura',
	Function = function(callback)
		if callback then
			local old, didSwing

			SilentAura:Clean(runService.PostSimulation:Connect(function()
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
								vim:SendMouseButtonEvent(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2, 0, true, nil, 0)
								didSwing = true
							end

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
							vim:SendMouseButtonEvent(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2, 0, false, nil, 0)
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
			end))

			SilentAura:Clean(runService.Heartbeat:Connect(function()
				if old then
					gameCamera.CFrame = old
					old = nil
				end
			end))
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