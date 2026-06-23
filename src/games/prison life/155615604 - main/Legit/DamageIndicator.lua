local DamageIndicator
local FontOption
local ColorV
local Size
local tent, lent
local thealth, ttimer = 0, 0
local indi, indipart, indithread

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
		billboard.Size = UDim2.fromOffset(30, 30)
		billboard.AlwaysOnTop = true
		billboard.Parent = indipart
		indi = Instance.new('TextLabel')
		indi.BackgroundTransparency = 1
		indi.TextStrokeTransparency = 0
		indi.Size = UDim2.fromScale(1, 1)
		indi.Text = math.ceil(damage)
		indi.TextColor3 = Color3.fromHSV(ColorV.Hue, ColorV.Sat, ColorV.Value)
		indi.TextScaled = true
		indi.Font = Enum.Font[FontOption.Value]
		indi.Parent = billboard
	end

	indithread = task.delay(1, function()
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