local Breaker
local Value
local OnlyPlayer

local function getBlocksInPoints(s, e)
	local list = {}
	for x = s.X, e.X, 3 do
		for y = s.Y, e.Y, 3 do
			for z = s.Z, e.Z, 3 do
				local vec = Vector3.new(x, y, z)
				if store.blocks[vec] then
					list[vec] = store.blocks[vec]
				end
			end
		end
	end
	return list
end

local function getPickaxe()
	for name in bd.Entity.LocalEntity.Inventory do
		if name:find('Pickaxe') then
			return name
		end
	end
end

Breaker = vape.Categories.Minigames:CreateModule({
	Name = 'Breaker',
	Function = function(callback)
		if callback then
			local breakBlock
			local breakTime = 0
			local lastBreak

			repeat
				breakBlock = nil

				if entitylib.isAlive then
					local pickaxe = getPickaxe()

					if pickaxe then
						local pos = (entitylib.character.RootPart.Position // 3) * 3
						local rvec = Vector3.new(3, 3, 3) * Range.Value

						for blockpos, block in getBlocksInPoints(pos - rvec, pos + rvec) do
							if block and block.Name == 'Block' and (block.Parent.Name == 'Bed' and lplr.Team and block.Parent:GetAttribute('Team') ~= lplr.Team.Name) then
								breakBlock = block
								break
							end
						end

						if breakBlock ~= lastBreak then
							if breakBlock then
								breakTime = os.clock() + bd.BreakTimes[breakBlock:GetAttribute('block_type') or 'Clay']
								bd.Blink.item_action.start_break_block.fire({
									position = breakBlock.Position,
									pickaxe_name = pickaxe,
									timestamp = workspace:GetServerTimeNow()
								})
							else
								bd.Blink.item_action.stop_break_block.fire(false)
							end
							lastBreak = breakBlock
						elseif breakBlock and breakTime < os.clock() then
							bd.Blink.item_action.stop_break_block.fire(true)
							breakTime = math.huge
						end
					end
				end

				task.wait(1 / 60)
			until not Breaker.Enabled
		end
	end,
	Tooltip = 'Breaks enemy blocks around you'
})
Range = Breaker:CreateSlider({
	Name = 'Break range',
	Min = 1,
	Max = 5,
	Default = 5,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})