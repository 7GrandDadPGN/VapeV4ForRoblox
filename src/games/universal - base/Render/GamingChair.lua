local GamingChair = {Enabled = false}
local Color
local wheelpositions = {
	Vector3.new(-0.8, -0.6, -0.18),
	Vector3.new(0.1, -0.6, -0.88),
	Vector3.new(0, -0.6, 0.7)
}
local chairhighlight
local currenttween
local movingsound
local flyingsound
local chairanim
local chair

GamingChair = vape.Categories.Render:CreateModule({
	Name = 'GamingChair',
	Function = function(callback)
		if callback then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
			chair = Instance.new('MeshPart')
			chair.Color = Color3.fromRGB(21, 21, 21)
			chair.Size = Vector3.new(2.16, 3.6, 2.3) / Vector3.new(12.37, 20.636, 13.071)
			chair.CanCollide = false
			chair.Massless = true
			chair.MeshId = 'rbxassetid://12972961089'
			chair.Material = Enum.Material.SmoothPlastic
			chair.Parent = workspace
			movingsound = Instance.new('Sound')
			--movingsound.SoundId = downloadVapeAsset('vape/assets/ChairRolling.mp3')
			movingsound.Volume = 0.4
			movingsound.Looped = true
			movingsound.Parent = workspace
			flyingsound = Instance.new('Sound')
			--flyingsound.SoundId = downloadVapeAsset('vape/assets/ChairFlying.mp3')
			flyingsound.Volume = 0.4
			flyingsound.Looped = true
			flyingsound.Parent = workspace
			local chairweld = Instance.new('WeldConstraint')
			chairweld.Part0 = chair
			chairweld.Parent = chair
			if entitylib.isAlive then
				chair.CFrame = entitylib.character.RootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
				chairweld.Part1 = entitylib.character.RootPart
			end
			chairhighlight = Instance.new('Highlight')
			chairhighlight.FillTransparency = 1
			chairhighlight.OutlineColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			chairhighlight.DepthMode = Enum.HighlightDepthMode.Occluded
			chairhighlight.OutlineTransparency = 0.2
			chairhighlight.Parent = chair
			local chairarms = Instance.new('MeshPart')
			chairarms.Color = chair.Color
			chairarms.Size = Vector3.new(1.39, 1.345, 2.75) / Vector3.new(97.13, 136.216, 234.031)
			chairarms.CFrame = chair.CFrame * CFrame.new(-0.169, -1.129, -0.013)
			chairarms.MeshId = 'rbxassetid://12972673898'
			chairarms.CanCollide = false
			chairarms.Parent = chair
			local chairarmsweld = Instance.new('WeldConstraint')
			chairarmsweld.Part0 = chairarms
			chairarmsweld.Part1 = chair
			chairarmsweld.Parent = chair
			local chairlegs = Instance.new('MeshPart')
			chairlegs.Color = chair.Color
			chairlegs.Name = 'Legs'
			chairlegs.Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)
			chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
			chairlegs.MeshId = 'rbxassetid://13003181606'
			chairlegs.CanCollide = false
			chairlegs.Parent = chair
			local chairfan = Instance.new('MeshPart')
			chairfan.Color = chair.Color
			chairfan.Name = 'Fan'
			chairfan.Size = Vector3.zero
			chairfan.CFrame = chair.CFrame * CFrame.new(0, -1.873, 0)
			chairfan.MeshId = 'rbxassetid://13004977292'
			chairfan.CanCollide = false
			chairfan.Parent = chair
			local trails = {}
			for _, v in wheelpositions do
				local attachment = Instance.new('Attachment')
				attachment.Position = v
				attachment.Parent = chairlegs
				local attachment2 = Instance.new('Attachment')
				attachment2.Position = v + Vector3.new(0, 0, 0.18)
				attachment2.Parent = chairlegs
				local trail = Instance.new('Trail')
				trail.Texture = 'http://www.roblox.com/asset/?id=13005168530'
				trail.TextureMode = Enum.TextureMode.Static
				trail.Transparency = NumberSequence.new(0.5)
				trail.Color = ColorSequence.new(Color3.new(0.5, 0.5, 0.5))
				trail.Attachment0 = attachment
				trail.Attachment1 = attachment2
				trail.Lifetime = 20
				trail.MaxLength = 60
				trail.MinLength = 0.1
				trail.Parent = chairlegs
				table.insert(trails, trail)
			end
			GamingChair:Clean(chair)
			GamingChair:Clean(movingsound)
			GamingChair:Clean(flyingsound)
			chairanim = {Stop = function() end}
			local oldmoving = false
			local oldflying = false
			repeat
				if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 then
					if not chairanim.IsPlaying then
						local temp2 = Instance.new('Animation')
						temp2.AnimationId = entitylib.character.Humanoid.RigType == Enum.HumanoidRigType.R15 and 'http://www.roblox.com/asset/?id=2506281703' or 'http://www.roblox.com/asset/?id=178130996'
						chairanim = entitylib.character.Humanoid:LoadAnimation(temp2)
						chairanim.Priority = Enum.AnimationPriority.Movement
						chairanim.Looped = true
						chairanim:Play()
					end
					chair.CFrame = entitylib.character.RootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
					chairweld.Part1 = entitylib.character.RootPart
					chairlegs.Velocity = Vector3.zero
					chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
					chairfan.Velocity = Vector3.zero
					chairfan.CFrame = chair.CFrame * CFrame.new(0.047, -1.873, 0) * CFrame.Angles(0, math.rad(tick() * 180 % 360), math.rad(180))
					local moving = entitylib.character.Humanoid:GetState() == Enum.HumanoidStateType.Running and entitylib.character.Humanoid.MoveDirection ~= Vector3.zero
					local flying = vape.Modules.Fly and vape.Modules.Fly.Enabled or vape.Modules.LongJump and vape.Modules.LongJump.Enabled or vape.Modules.InfiniteFly and vape.Modules.InfiniteFly.Enabled
					if movingsound.TimePosition > 1.9 then
						movingsound.TimePosition = 0.2
					end
					movingsound.PlaybackSpeed = (entitylib.character.RootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude / 16
					for _, v in trails do
						v.Enabled = not flying and moving
						v.Color = ColorSequence.new(movingsound.PlaybackSpeed > 1.5 and Color3.new(1, 0.5, 0) or Color3.new())
					end
					if moving ~= oldmoving then
						if movingsound.IsPlaying then
							if not moving then
								movingsound:Stop()
							end
						else
							if not flying and moving then
								movingsound:Play()
							end
						end
						oldmoving = moving
					end
					if flying ~= oldflying then
						if flying then
							if movingsound.IsPlaying then
								movingsound:Stop()
							end
							if not flyingsound.IsPlaying then
								flyingsound:Play()
							end
							if currenttween then
								currenttween:Cancel()
							end
							tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {
								Size = Vector3.zero
							})
							tween.Completed:Connect(function(state)
								if state == Enum.PlaybackState.Completed then
									chairfan.Transparency = 0
									chairlegs.Transparency = 1
									tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {
										Size = Vector3.new(1.534, 0.328, 1.537) / Vector3.new(791.138, 168.824, 792.027)
									})
									tween:Play()
								end
							end)
							tween:Play()
						else
							if flyingsound.IsPlaying then
								flyingsound:Stop()
							end
							if not movingsound.IsPlaying and moving then
								movingsound:Play()
							end
							if currenttween then currenttween:Cancel() end
							tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {
								Size = Vector3.zero
							})
							tween.Completed:Connect(function(state)
								if state == Enum.PlaybackState.Completed then
									chairfan.Transparency = 1
									chairlegs.Transparency = 0
									tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {
										Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)
									})
									tween:Play()
								end
							end)
							tween:Play()
						end
						oldflying = flying
					end
				else
					chair.Anchored = true
					chairlegs.Anchored = true
					chairfan.Anchored = true
					repeat task.wait() until entitylib.isAlive and entitylib.character.Humanoid.Health > 0
					chair.Anchored = false
					chairlegs.Anchored = false
					chairfan.Anchored = false
					chairanim:Stop()
				end
				task.wait()
			until not GamingChair.Enabled
		else
			if chairanim then
				chairanim:Stop()
			end
		end
	end,
	Tooltip = 'Sit in the best gaming chair known to mankind.'
})
Color = GamingChair:CreateColorSlider({
	Name = 'Color',
	Function = function(h, s, v)
		if chairhighlight then
			chairhighlight.OutlineColor = Color3.fromHSV(h, s, v)
		end
	end
})