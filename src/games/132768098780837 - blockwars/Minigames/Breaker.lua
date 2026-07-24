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

local function attemptBreak(tab, localPosition)
	if not tab then return end
	for _, v in tab do
		if ((v:IsA('Model') and v.PrimaryPart or v).Position - localPosition).Magnitude < Range.Value and (v.Name ~= 'SpawnBlock' or v:GetAttribute('TeamId') ~= (lplr.Team and lplr.Team.Name or '')) then
			if v:IsA('Model') then
				local notCovered = false
				for _, normal in Enum.NormalId:GetEnumItems() do
					if normal ~= Enum.NormalId.Bottom then
						if not blocks[v.PrimaryPart.Position // 3 + Vector3.fromNormalId(normal)] then
							notCovered = true
							break
						end
					end
				end

				if notCovered then
					local box = v:FindFirstChild('Hitbox')
					bw.RemoteIndex.Block_AttemptHit:FireServer({
						camPos = localPosition,
						hitPos = box:GetClosestPointOnSurface(localPosition),
						blockInstance = box
					})
				else
					local aboveBlock = blocks[v.PrimaryPart.Position // 3 + Vector3.new(0, 1, 0)]

					if aboveBlock then
						bw.RemoteIndex.Block_AttemptHit:FireServer({
							camPos = localPosition,
							hitPos = aboveBlock:GetClosestPointOnSurface(localPosition),
							blockInstance = aboveBlock
						})
					end
				end

				task.wait(0.15)
			else
				bw.RemoteIndex.Mine_AttemptHit:FireServer(v)
			end

			task.wait(0.05)
			return true
		end
	end

	return false
end

Breaker = vape.Categories.Minigames:CreateModule({
	Name = 'Breaker',
	Function = function(callback)
		if callback then
			local beds = collection('BedWarsX_Bed', Breaker)
			local generators = collection('BedWarsX_Resource', Breaker)

			repeat
				task.wait(1 / UpdateRate.Value)
				if not Breaker.Enabled then break end

				local tool = getTool()
				if entitylib.isAlive and tool and tool:GetAttribute('Tier') then
					local localPosition = bypassRoot and bypassRoot.Position or entitylib.character.RootPart.Position

					if attemptBreak(beds, localPosition) then continue end
					if attemptBreak(generators, localPosition) then continue end
				end
			until not Breaker.Enabled
		end
	end,
	Tooltip = 'Break blocks around you automatically'
})
Range = Breaker:CreateSlider({
	Name = 'Break range',
	Min = 1,
	Max = 12,
	Default = 12,
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