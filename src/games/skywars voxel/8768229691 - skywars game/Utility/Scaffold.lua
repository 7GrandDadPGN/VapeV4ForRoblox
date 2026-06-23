local Scaffold
local Expand
local Tower
local Downwards
local Diagonal
local LimitItem
local adjacent, lastpos = {}, Vector3.zero

for x = -3, 3, 3 do
	for y = -3, 3, 3 do
		for z = -3, 3, 3 do
			local vec = Vector3.new(x, y, z)
			if vec.Y ~= 0 and (vec.X ~= 0 or vec.Z ~= 0) then
				continue
			end

			if vec ~= Vector3.zero then
				table.insert(adjacent, vec)
			end
		end
	end
end

local function getBlocksInPoints(s, e)
	local list = {}
	for x = s.X, e.X, 3 do
		for y = s.Y, e.Y, 3 do
			for z = s.Z, e.Z, 3 do
				local vec = Vector3.new(x, y, z)
				if store.blocks[vec] then
					table.insert(list, vec)
				end
			end
		end
	end
	return list
end

local function roundPos(vec)
	return Vector3.new(math.round(vec.X / 3) * 3, math.round(vec.Y / 3) * 3, math.round(vec.Z / 3) * 3)
end

local function nearCorner(poscheck, pos)
	local startpos = poscheck - Vector3.new(3, 3, 3)
	local endpos = poscheck + Vector3.new(3, 3, 3)
	local check = poscheck + (pos - poscheck).Unit * 100
	if math.abs(check.Y - startpos.Y) > 3 then
		return Vector3.new(poscheck.X, math.clamp(check.Y, startpos.Y, endpos.Y), poscheck.Z)
	end

	return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
end

local function blockProximity(pos)
	local mag, returned = 60
	local tab = getBlocksInPoints(pos - Vector3.new(21, 21, 21), pos + Vector3.new(21, 21, 21))

	for _, v in tab do
		local blockpos = nearCorner(v, pos)
		local newmag = (pos - blockpos).Magnitude
		if newmag < mag then
			mag, returned = newmag, blockpos
		end
	end

	table.clear(tab)
	return returned
end

local function checkAdjacent(pos)
	for _, v in adjacent do
		if store.blocks[pos + v] then return true end
	end
	return false
end

local function getBlock()
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		if item.Rewrite then return item, slot end
	end
end

Scaffold = vape.Categories.Utility:CreateModule({
	Name = 'Scaffold',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive then
					local wool = (not LimitItem.Enabled) and getBlock() or store.hand.Rewrite and store.hand
					if wool then
						local root = entitylib.character.RootPart
						if Tower.Enabled and inputService:IsKeyDown(Enum.KeyCode.Space) and (not inputService:GetFocusedTextBox()) then
							root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
						end

						for i = Expand.Value, 1, -1 do
							local currentpos = roundPos(root.Position - Vector3.new(0, entitylib.character.HipHeight + (Downwards.Enabled and inputService:IsKeyDown(Enum.KeyCode.LeftShift) and 4.5 or 1.5), 0) + entitylib.character.Humanoid.MoveDirection * (i * 3))
							if Diagonal.Enabled then
								if math.abs(math.round(math.deg(math.atan2(-entitylib.character.Humanoid.MoveDirection.X, -entitylib.character.Humanoid.MoveDirection.Z)) / 45) * 45) % 90 == 45 then
									local dt = (lastpos - currentpos)
									if ((dt.X == 0 and dt.Z ~= 0) or (dt.X ~= 0 and dt.Z == 0)) and ((lastpos - root.Position) * Vector3.new(1, 0, 1)).Magnitude < 2.5 then
										currentpos = lastpos
									end
								end
							end

							local block = store.blocks[currentpos]
							if not block then
								blockpos = checkAdjacent(currentpos) and currentpos or blockProximity(currentpos)
								if blockpos then
									local block = skywars.ItemMeta[wool.Rewrite.Type:gsub('{TeamId}', skywars.TeamController:getPlayerTeamId(lplr) or 'White')]
									skywars.BlockController:placeBlock(blockpos, wool.Name, block, Vector3.zero)
								end
							end
							lastpos = currentpos
						end
					end
				end

				task.wait(0.03)
			until not Scaffold.Enabled
		end
	end,
	Tooltip = 'Helps you make bridges/scaffold walk.'
})
Expand = Scaffold:CreateSlider({
	Name = 'Expand',
	Min = 1,
	Max = 6
})
Tower = Scaffold:CreateToggle({
	Name = 'Tower',
	Default = true
})
Downwards = Scaffold:CreateToggle({
	Name = 'Downwards',
	Default = true
})
Diagonal = Scaffold:CreateToggle({
	Name = 'Diagonal',
	Default = true
})
LimitItem = Scaffold:CreateToggle({Name = 'Limit to items'})