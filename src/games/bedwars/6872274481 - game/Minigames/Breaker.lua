local Breaker
local Range
local BreakSpeed
local UpdateRate
local Custom
local Bed
local LuckyBlock
local IronOre
local Effect
local CustomHealth = {}
local Animation
local SelfBreak
local InstantBreak
local LimitItem
local customlist, parts = {}, {}

local function customHealthbar(self, blockRef, health, maxHealth, changeHealth, block)
	if block:GetAttribute('NoHealthbar') then return end
	if not self.healthbarPart or not self.healthbarBlockRef or self.healthbarBlockRef.blockPosition ~= blockRef.blockPosition then
		self.healthbarMaid:DoCleaning()
		self.healthbarBlockRef = blockRef
		local create = bedwars.Roact.createElement
		local percent = math.clamp(health / maxHealth, 0, 1)
		local cleanCheck = true
		local part = Instance.new('Part')
		part.Size = Vector3.one
		part.CFrame = CFrame.new(bedwars.BlockController:getWorldPosition(blockRef.blockPosition))
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.Parent = workspace
		self.healthbarPart = part
		bedwars.QueryUtil:setQueryIgnored(self.healthbarPart, true)

		local mounted = bedwars.Roact.mount(create('BillboardGui', {
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
					Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
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
					Text = bedwars.ItemMeta[block.Name].displayName or block.Name,
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
						[bedwars.Roact.Ref] = self.healthbarProgressRef,
						Size = UDim2.fromScale(percent, 1),
						BackgroundColor3 = Color3.fromHSV(math.clamp(percent / 2.5, 0, 1), 0.89, 0.75)
					}, {create('UICorner', {CornerRadius = UDim.new(1, 0)})})
				})
			})
		}), part)

		self.healthbarMaid:GiveTask(function()
			cleanCheck = false
			self.healthbarBlockRef = nil
			bedwars.Roact.unmount(mounted)
			if self.healthbarPart then
				self.healthbarPart:Destroy()
			end
			self.healthbarPart = nil
		end)

		bedwars.RuntimeLib.Promise.delay(5):andThen(function()
			if cleanCheck then
				self.healthbarMaid:DoCleaning()
			end
		end)
	end

	local newpercent = math.clamp((health - changeHealth) / maxHealth, 0, 1)
	tweenService:Create(self.healthbarProgressRef:getValue(), TweenInfo.new(0.3), {
		Size = UDim2.fromScale(newpercent, 1), BackgroundColor3 = Color3.fromHSV(math.clamp(newpercent / 2.5, 0, 1), 0.89, 0.75)
	}):Play()
end

local hit = 0

local function attemptBreak(tab, localPosition)
	if not tab then return end
	for _, v in tab do
		if (v.Position - localPosition).Magnitude < Range.Value and bedwars.BlockController:isBlockBreakable({blockPosition = v.Position / 3}, lplr) then
			if not SelfBreak.Enabled and v:GetAttribute('PlacedByUserId') == lplr.UserId then continue end
			if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then continue end
			if LimitItem.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then continue end

			hit += 1
			local target, path, endpos = bedwars.breakBlock(v, Effect.Enabled, Animation.Enabled, CustomHealth.Enabled and customHealthbar or nil, InstantBreak.Enabled)
			if path then
				local currentnode = target
				for _, part in parts do
					part.Position = currentnode or Vector3.zero
					if currentnode then
						part.BoxHandleAdornment.Color3 = currentnode == endpos and Color3.new(1, 0.2, 0.2) or currentnode == target and Color3.new(0.2, 0.2, 1) or Color3.new(0.2, 1, 0.2)
					end
					currentnode = path[currentnode]
				end
			end

			task.wait(InstantBreak.Enabled and (store.damageBlockFail > tick() and 4.5 or 0) or BreakSpeed.Value)

			return true
		end
	end

	return false
end

Breaker = vape.Categories.Minigames:CreateModule({
	Name = 'Breaker',
	Function = function(callback)
		if callback then
			for _ = 1, 30 do
				local part = Instance.new('Part')
				part.Anchored = true
				part.CanQuery = false
				part.CanCollide = false
				part.Transparency = 1
				part.Parent = gameCamera
				local highlight = Instance.new('BoxHandleAdornment')
				highlight.Size = Vector3.one
				highlight.AlwaysOnTop = true
				highlight.ZIndex = 1
				highlight.Transparency = 0.5
				highlight.Adornee = part
				highlight.Parent = part
				table.insert(parts, part)
			end

			local beds = collection('bed', Breaker)
			local luckyblock = collection('LuckyBlock', Breaker)
			local ironores = collection('iron-ore', Breaker)
			customlist = collection('block', Breaker, function(tab, obj)
				if table.find(Custom.ListEnabled, obj.Name) then
					table.insert(tab, obj)
				end
			end)

			repeat
				task.wait(1 / UpdateRate.Value)
				if not Breaker.Enabled then break end
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position

					if attemptBreak(Bed.Enabled and beds, localPosition) then continue end
					if attemptBreak(customlist, localPosition) then continue end
					if attemptBreak(LuckyBlock.Enabled and luckyblock, localPosition) then continue end
					if attemptBreak(IronOre.Enabled and ironores, localPosition) then continue end

					for _, v in parts do
						v.Position = Vector3.zero
					end
				end
			until not Breaker.Enabled
		else
			for _, v in parts do
				v:ClearAllChildren()
				v:Destroy()
			end
			table.clear(parts)
		end
	end,
	Tooltip = 'Break blocks around you automatically'
})
Range = Breaker:CreateSlider({
	Name = 'Break range',
	Min = 1,
	Max = 30,
	Default = 30,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
BreakSpeed = Breaker:CreateSlider({
	Name = 'Break speed',
	Min = 0,
	Max = 0.3,
	Default = 0.25,
	Decimal = 100,
	Suffix = 'seconds'
})
UpdateRate = Breaker:CreateSlider({
	Name = 'Update rate',
	Min = 1,
	Max = 120,
	Default = 60,
	Suffix = 'hz'
})
Custom = Breaker:CreateTextList({
	Name = 'Custom',
	Function = function()
		if not customlist then return end
		table.clear(customlist)
		for _, obj in store.blocks do
			if table.find(Custom.ListEnabled, obj.Name) then
				table.insert(customlist, obj)
			end
		end
	end
})
Bed = Breaker:CreateToggle({
	Name = 'Break Bed',
	Default = true
})
LuckyBlock = Breaker:CreateToggle({
	Name = 'Break Lucky Block',
	Default = true
})
IronOre = Breaker:CreateToggle({
	Name = 'Break Iron Ore',
	Default = true
})
Effect = Breaker:CreateToggle({
	Name = 'Show Healthbar & Effects',
	Function = function(callback)
		if CustomHealth.Object then
			CustomHealth.Object.Visible = callback
		end
	end,
	Default = true
})
CustomHealth = Breaker:CreateToggle({
	Name = 'Custom Healthbar',
	Default = true,
	Darker = true
})
Animation = Breaker:CreateToggle({Name = 'Animation'})
SelfBreak = Breaker:CreateToggle({Name = 'Self Break'})
InstantBreak = Breaker:CreateToggle({Name = 'Instant Break'})
LimitItem = Breaker:CreateToggle({
	Name = 'Limit to items',
	Tooltip = 'Only breaks when tools are held'
})