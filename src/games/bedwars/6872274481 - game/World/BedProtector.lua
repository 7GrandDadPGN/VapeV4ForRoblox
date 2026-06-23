local BedProtector

local function getBedNear()
	local localPosition = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
	for _, v in collectionService:GetTagged('bed') do
		if (localPosition - v.Position).Magnitude < 20 and v:GetAttribute('Team'..(lplr:GetAttribute('Team') or -1)..'NoBreak') then
			return v
		end
	end
end

local function getBlocks()
	local blocks = {}
	for _, item in store.inventory.inventory.items do
		local block = bedwars.ItemMeta[item.itemType].block
		if block then
			table.insert(blocks, {item.itemType, block.health})
		end
	end
	table.sort(blocks, function(a, b) 
		return a[2] > b[2]
	end)
	return blocks
end

local function getPyramid(size, grid)
	local positions = {}
	for h = size, 0, -1 do
		for w = h, 0, -1 do
			table.insert(positions, Vector3.new(w, (size - h), ((h + 1) - w)) * grid)
			table.insert(positions, Vector3.new(w * -1, (size - h), ((h + 1) - w)) * grid)
			table.insert(positions, Vector3.new(w, (size - h), (h - w) * -1) * grid)
			table.insert(positions, Vector3.new(w * -1, (size - h), (h - w) * -1) * grid)
		end
	end
	return positions
end

BedProtector = vape.Categories.World:CreateModule({
	Name = 'BedProtector',
	Function = function(callback)
		if callback then
			local bed = getBedNear()
			bed = bed and bed.Position or nil
			if bed then
				for i, block in getBlocks() do
					for _, pos in getPyramid(i, 3) do
						if not BedProtector.Enabled then break end
						if getPlacedBlock(bed + pos) then continue end
						bedwars.placeBlock(bed + pos, block[1], false)
					end
				end
				if BedProtector.Enabled then 
					BedProtector:Toggle() 
				end
			else
				notif('BedProtector', 'Unable to locate bed', 5)
				BedProtector:Toggle()
			end
		end
	end,
	Tooltip = 'Automatically places strong blocks around the bed.'
})