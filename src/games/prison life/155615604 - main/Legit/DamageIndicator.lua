local DamageIndicator
local FontOption
local ColorV
local Size
local tent, lent
local thealth, ttimer = 0, 0
local indi, indipart, indithread

-- completely skidded from RIVALS
local function renderStepForLoop(startVal, endVal, increment, callback)
	while true do
		if endVal >= startVal then
			if callback(startVal) then
				return
			else
				local diff = tick()
				runService.RenderStepped:Wait()
				startVal = startVal + increment * (tick() - diff) * 60
			end
		else
			callback(endVal)
			return
		end
	end
end

local function createIndicator(damage, pos)
	if indithread then
		task.cancel(indithread)
		indi.Text = math.ceil(tonumber(indi.Text) + damage)
		indipart.Position = pos
	else
		indipart = Instance.new('Part')
		indipart.Size = Vector3.zero
		indipart.Position = pos
		indipart.CanCollide = false
		indipart.CanQuery = false
		indipart.Anchored = true
		indipart.Parent = workspace
		local billboard = Instance.new('BillboardGui')
		billboard.Adornee = indipart
		billboard.Size = UDim2.new(15, 250, 15, 250)
		billboard.AlwaysOnTop = true
		billboard.Parent = indipart
		indi = Instance.new('TextLabel')
		indi.BackgroundTransparency = 1
		indi.TextStrokeTransparency = 0
		indi.Size = UDim2.fromScale(1, 0.075)
		indi.Position = UDim2.fromScale(0.5, 0.5)
		indi.AnchorPoint = Vector2.new(0.5, 0.5)
		indi.Text = math.ceil(damage)
		indi.TextColor3 = Color3.fromHSV(ColorV.Hue, ColorV.Sat, ColorV.Value)
		indi.TextScaled = true
		indi.Font = Enum.Font[FontOption.Value]
		indi.Parent = billboard
	end

	if indithread then
		task.cancel(indithread)
		indithread = nil
	end

	-- completely skidded from RIVALS
	indithread = task.spawn(function()
		local sign = math.sign(math.random() - 0.5)
		renderStepForLoop(0, 100, 3, function(value)
			local percent = value / 100
			local val0 = tweenService:GetValue(percent, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			local val1 = tweenService:GetValue(percent, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			local scale = 1 - 0.5 * val1
			indi.Position = UDim2.new(0.5 + 0.125 * val0 * sign, 0, 0.5 + 0.125 * val1, 0)
			indi.Size = UDim2.new(1 * scale, 0, 0.075 * scale * (v197 and 1 or 0.75), 0)
			indi.Rotation = percent ^ 4 * 260 * sign
		end)

		indipart:Destroy()
		indipart = nil
		indithread = nil
	end)
end

DamageIndicator = vape.Legit:CreateModule({
	Name = 'DamageIndicator',
	Function = function(callback)
		if callback then
			TracerHook:Add('DamageIndicator', function(...)
				local part = debug.getstack(4, 17)
				if typeof(part) == 'Instance' then
					for _, v in entitylib.List do
						if part:IsDescendantOf(v.Character) and entitylib.isVulnerable(v, true) then
							if ttimer <= os.clock() or v ~= tent then
								thealth = v.Health
							end

							tent = v
							ttimer = os.clock() + 0.5
							break
						end
					end
				end
			end)

			DamageIndicator:Clean(entitylib.Events.EntityUpdated:Connect(function(ent)
				if ent == tent and ttimer > os.clock() then
					if ent ~= lent then
						if indi then
							indi.Text = '0'
						end

						lent = ent
					end

					if thealth > ent.Health then
						createIndicator(thealth - ent.Health, ent.Head.Position + Vector3.new(0, 2, 0))
						thealth = ent.Health
					end
				end
			end))
		else
			TracerHook:Remove('DamageIndicator')
		end
	end,
	Tooltip = 'Add custom damage indicators for gun damage.'
})
local fontitems = {'GothamBlack'}
for _, v in Enum.Font:GetEnumItems() do
	if v.Name ~= 'GothamBlack' then
		table.insert(fontitems, v.Name)
	end
end
FontOption = DamageIndicator:CreateDropdown({
	Name = 'Font',
	List = fontitems,
	Function = function(val)
		if indi then
			indi.Font = Enum.Font[val]
		end
	end
})
ColorV = DamageIndicator:CreateColorSlider({
	Name = 'Color',
	DefaultHue = 0,
	Function = function(hue, sat, val)
		if indi then
			indi.Color = Color3.fromHSV(hue, sat, val)
		end
	end
})