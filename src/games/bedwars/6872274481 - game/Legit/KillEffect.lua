local KillEffect
local Mode
local List
local NameToId = {}

local killeffects = {
	Gravity = function(_, _, char, _)
		char:BreakJoints()
		local highlight = char:FindFirstChildWhichIsA('Highlight')
		local nametag = char:FindFirstChild('Nametag', true)
		if highlight then
			highlight:Destroy()
		end
		if nametag then
			nametag:Destroy()
		end

		task.spawn(function()
			local partvelo = {}
			for _, v in char:GetDescendants() do
				if v:IsA('BasePart') then
					partvelo[v.Name] = v.Velocity
				end
			end
			char.Archivable = true
			local clone = char:Clone()
			clone.Humanoid.Health = 100
			clone.Parent = workspace
			game:GetService('Debris'):AddItem(clone, 30)
			char:Destroy()
			task.wait(0.01)
			clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
			clone:BreakJoints()
			task.wait(0.01)
			for _, v in clone:GetDescendants() do
				if v:IsA('BasePart') then
					local bodyforce = Instance.new('BodyForce')
					bodyforce.Force = Vector3.new(0, (workspace.Gravity - 10) * v:GetMass(), 0)
					bodyforce.Parent = v
					v.CanCollide = true
					v.Velocity = partvelo[v.Name] or Vector3.zero
				end
			end
		end)
	end,
	Lightning = function(_, _, char, _)
		char:BreakJoints()
		local highlight = char:FindFirstChildWhichIsA('Highlight')
		if highlight then
			highlight:Destroy()
		end
		local startpos = 1125
		local startcf = char.PrimaryPart.CFrame.p - Vector3.new(0, 8, 0)
		local newpos = Vector3.new((math.random(1, 10) - 5) * 2, startpos, (math.random(1, 10) - 5) * 2)

		for i = startpos - 75, 0, -75 do
			local newpos2 = Vector3.new((math.random(1, 10) - 5) * 2, i, (math.random(1, 10) - 5) * 2)
			if i == 0 then
				newpos2 = Vector3.zero
			end
			local part = Instance.new('Part')
			part.Size = Vector3.new(1.5, 1.5, 77)
			part.Material = Enum.Material.SmoothPlastic
			part.Anchored = true
			part.Material = Enum.Material.Neon
			part.CanCollide = false
			part.CFrame = CFrame.new(startcf + newpos + ((newpos2 - newpos) * 0.5), startcf + newpos2)
			part.Parent = workspace
			local part2 = part:Clone()
			part2.Size = Vector3.new(3, 3, 78)
			part2.Color = Color3.new(0.7, 0.7, 0.7)
			part2.Transparency = 0.7
			part2.Material = Enum.Material.SmoothPlastic
			part2.Parent = workspace
			game:GetService('Debris'):AddItem(part, 0.5)
			game:GetService('Debris'):AddItem(part2, 0.5)
			bedwars.QueryUtil:setQueryIgnored(part, true)
			bedwars.QueryUtil:setQueryIgnored(part2, true)
			if i == 0 then
				local soundpart = Instance.new('Part')
				soundpart.Transparency = 1
				soundpart.Anchored = true
				soundpart.Size = Vector3.zero
				soundpart.Position = startcf
				soundpart.Parent = workspace
				bedwars.QueryUtil:setQueryIgnored(soundpart, true)
				local sound = Instance.new('Sound')
				sound.SoundId = 'rbxassetid://6993372814'
				sound.Volume = 2
				sound.Pitch = 0.5 + (math.random(1, 3) / 10)
				sound.Parent = soundpart
				sound:Play()
				sound.Ended:Connect(function()
					soundpart:Destroy()
				end)
			end
			newpos = newpos2
		end
	end,
	Delete = function(_, _, char, _)
		char:Destroy()
	end
}

KillEffect = vape.Legit:CreateModule({
	Name = 'Kill Effect',
	Function = function(callback)
		if callback then
			for i, v in killeffects do
				bedwars.KillEffectController.killEffects['Custom'..i] = {
					new = function()
						return {
							onKill = v,
							isPlayDefaultKillEffect = function()
								return false
							end
						}
					end
				}
			end
			KillEffect:Clean(lplr:GetAttributeChangedSignal('KillEffectType'):Connect(function()
				lplr:SetAttribute('KillEffectType', Mode.Value == 'Bedwars' and NameToId[List.Value] or 'Custom'..Mode.Value)
			end))
			lplr:SetAttribute('KillEffectType', Mode.Value == 'Bedwars' and NameToId[List.Value] or 'Custom'..Mode.Value)
		else
			for i in killeffects do
				bedwars.KillEffectController.killEffects['Custom'..i] = nil
			end
			lplr:SetAttribute('KillEffectType', 'default')
		end
	end,
	Tooltip = 'Custom final kill effects'
})
local modes = {'Bedwars'}
for i in killeffects do
	table.insert(modes, i)
end
Mode = KillEffect:CreateDropdown({
	Name = 'Mode',
	List = modes,
	Function = function(val)
		List.Object.Visible = val == 'Bedwars'
		if KillEffect.Enabled then
			lplr:SetAttribute('KillEffectType', val == 'Bedwars' and NameToId[List.Value] or 'Custom'..val)
		end
	end
})
local KillEffectName = {}
for i, v in bedwars.KillEffectMeta do
	table.insert(KillEffectName, v.name)
	NameToId[v.name] = i
end
table.sort(KillEffectName)
List = KillEffect:CreateDropdown({
	Name = 'Bedwars',
	List = KillEffectName,
	Function = function(val)
		if KillEffect.Enabled then
			lplr:SetAttribute('KillEffectType', NameToId[val])
		end
	end,
	Darker = true
})