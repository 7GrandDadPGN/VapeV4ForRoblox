local Breaker
local Range
local BreakerPart
local BreakerUI
local BreakerRef = skywars.Roact.createRef()

local function clean()
	if not BreakerUI then return end
	if BreakerPart then
		BreakerPart:Destroy()
	end

	skywars.Roact.unmount(BreakerUI)
	BreakerUI = nil
	BreakerPart = nil
end

local function customHealthbar(block, health, maxHealth, changeHealth)
	if not BreakerPart then
		local create = skywars.Roact.createElement
		local percent = math.clamp(health / maxHealth, 0, 1)
		local cleanCheck = true
		local part = Instance.new('Part')
		part.Size = Vector3.one
		part.CFrame = block.PrimaryPart.CFrame
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.Parent = workspace
		BreakerPart = part

		BreakerUI = skywars.Roact.mount(create('BillboardGui', {
			Size = UDim2.fromOffset(249, 102),
			StudsOffset = Vector3.new(0, 2.5, 0),
			Adornee = part,
			MaxDistance = 40,
			AlwaysOnTop = true
		}, {
			create('Frame', {
				Size = UDim2.fromOffset(160, 50),
				Position = UDim2.fromOffset(44, 32),
				BackgroundColor3 = Color3.new(),
				BackgroundTransparency = 0.5
			}, {
				create('UICorner', {CornerRadius = UDim.new(0, 5)}),
				create('ImageLabel', {
					Size = UDim2.new(1, 89, 1, 52),
					Position = UDim2.fromOffset(-48, -31),
					BackgroundTransparency = 1,
					Image = getcustomasset('newvape/assets/new/blur.png'),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(52, 31, 261, 502)
				}),
				create('TextLabel', {
					Size = UDim2.fromOffset(145, 14),
					Position = UDim2.fromOffset(13, 12),
					BackgroundTransparency = 1,
					Text = block.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = Color3.new(),
					TextScaled = true,
					Font = Enum.Font.Arial
				}),
				create('TextLabel', {
					Size = UDim2.fromOffset(145, 14),
					Position = UDim2.fromOffset(12, 11),
					BackgroundTransparency = 1,
					Text = block.Name,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = color.Dark(uipallet.Text, 0.16),
					TextScaled = true,
					Font = Enum.Font.Arial
				}),
				create('Frame', {
					Size = UDim2.fromOffset(138, 4),
					Position = UDim2.fromOffset(12, 32),
					BackgroundColor3 = uipallet.Main
				}, {
					create('UICorner', {CornerRadius = UDim.new(1, 0)}),
					create('Frame', {
						[skywars.Roact.Ref] = BreakerRef,
						Size = UDim2.fromScale(percent, 1),
						BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
					}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
				})
			})
		}), part)

		task.delay(5, clean)
	end

	local progress = math.clamp((health - changeHealth) / maxHealth, 0, 1)
	if progress == 0 then
		clean()
		return
	end

	task.delay(0, function()
		local val = BreakerRef:getValue()
		if val then
			tweenService:Create(val, TweenInfo.new(0.3), {
				Size = UDim2.fromScale(progress, 1),
				BackgroundColor3 = Color3.fromHSV(math.clamp(progress / 2.5, 0, 1), 0.89, 0.75)
			}):Play()
		end
	end)
end

Breaker = vape.Categories.Minigames:CreateModule({
	Name = 'Breaker',
	Function = function(callback)
		if callback then
			local eggs = collection('egg', Breaker)
			local currentblock
			local oldblockhealth = 0

			repeat
				if entitylib.isAlive and store.hand then
					local localPosition = entitylib.character.RootPart.Position
					for _, v in eggs do
						if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude < Range.Value then
							local hp = v:GetAttribute('Health') or 0
							if v:GetAttribute('TeamId') == lplr:GetAttribute('TeamId') then continue end
							if currentblock ~= v then
								oldblockhealth = hp
								currentblock = v
							end

							if hp ~= oldblockhealth then
								customHealthbar(v, oldblockhealth, 100, oldblockhealth - hp)
								oldblockhealth = hp
							end

							store.noShoot = tick() + 1
							if hp <= 0 then continue end

							if store.hand.Melee then
								skywars.Remotes[remotes['MeleeController:attemptStrikeDesktop']]:fire(v)
							elseif store.hand.Pickaxe then
								skywars.Remotes[remotes.hitBlock]:fire((v.PrimaryPart.Position + Vector3.new(0, 1.5, 0)) // 1)
							end
						end
					end
				end

				task.wait(0.016)
			until not Breaker.Enabled
		end
	end,
	Tooltip = 'Automatically destroys eggs around you'
})
Range = Breaker:CreateSlider({
	Name = 'Break range',
	Min = 1,
	Max = 40,
	Default = 40,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})