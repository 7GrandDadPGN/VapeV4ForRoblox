local Disabler
local Speed
local FlyDis
local state = false

local function AddGlider(glider)
	if not glider then return end
	for _, v in glider:QueryDescendants('BasePart') do
		v.Transparency = 1
	end

	Disabler:Clean(glider.DescendantAdded:Connect(function(v)
		if v:IsA('BasePart') then
			v.Transparency = 1
		end
	end))
end

local function LocalAdded(char)
	Disabler:Clean(char.Character.ChildAdded:Connect(function(obj)
		if obj.Name == 'Glider' then
			AddGlider(obj)
		end
	end))

	Disabler:Clean(char.Humanoid.Animator.AnimationPlayed:Connect(function(track)
		if track.Animation.AnimationId == 'rbxassetid://1678614837' then
			track:Stop()
		end
	end))

	for _, track in char.Humanoid.Animator:GetPlayingAnimationTracks() do
		if track.Animation.AnimationId == 'rbxassetid://1678614837' then
			track:Stop()
		end
	end

	AddGlider(char.Character:FindFirstChild('Glider'))
end

Disabler = vape.Categories.Blatant:CreateModule({
	Name = 'Disabler',
	Function = function(callback)
		if callback then
			local cd = os.clock()
			local extraCd = os.clock()

			if Speed.Enabled then
				getInCallback = function()
					jb:FireServer('GliderStop')
				end

				Disabler:Clean(entitylib.Events.LocalAdded:Connect(LocalAdded))
				if entitylib.isAlive then
					task.spawn(LocalAdded, entitylib.character)
				end

				task.spawn(function()
					repeat
						if entitylib.isAlive and not (entitylib.character.Sit or lplr.Character:FindFirstChild('Glider')) then
							jb:FireServer('Glider')
						end

						task.wait(0.1)
					until not (Disabler.Enabled and Speed.Enabled)
				end)
			end

			if FlyDis.Enabled then
				repeat
					if entitylib.isAlive then
						local newState = cd > os.clock() or vape.Modules.Fly.Enabled

						if not isnetworkowner(entitylib.character.RootPart) and extraCd < os.clock() then
							if newState then
								jb:FireServer('Heartbeat')
								jb:FireServer('StartRagdolling')
								extraCd = os.clock() + 0.1
							end
						end

						if state ~= newState then
							if newState then
								jb:FireServer('StartRagdolling')
								cd = os.clock() + 0.1
							else
								jb:FireServer('Heartbeat')
							end

							state = newState
						end
					end

					task.wait()
				until not (Disabler.Enabled and FlyDis.Enabled)
			end
		else
			if state then
				jb:FireServer('Heartbeat')
				state = false
			end

			if getInCallback then
				jb:FireServer('GliderStop')
				getInCallback = nil
			end
		end
	end,
	Tooltip = 'Uses certain methods to weaken anticheat checks.'
})
Speed = Disabler:CreateToggle({
	Name = 'Speed',
	Default = true,
	Function = function()
		if Disabler.Enabled then
			Disabler:Toggle()
			Disabler:Toggle()
		end
	end
})
FlyDis = Disabler:CreateToggle({
	Name = 'Fly',
	Default = true,
	Function = function()
		if Disabler.Enabled then
			Disabler:Toggle()
			Disabler:Toggle()
		end
	end
})