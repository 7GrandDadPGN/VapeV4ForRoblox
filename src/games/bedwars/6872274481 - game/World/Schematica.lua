local Schematica
local File
local Mode
local Transparency
local parts, guidata, poschecklist = {}, {}, {}
local point1, point2

for x = -3, 3, 3 do
	for y = -3, 3, 3 do
		for z = -3, 3, 3 do
			if Vector3.new(x, y, z) ~= Vector3.zero then
				table.insert(poschecklist, Vector3.new(x, y, z))
			end
		end
	end
end

local function checkAdjacent(pos)
	for _, v in poschecklist do
		if getPlacedBlock(pos + v) then return true end
	end
	return false
end

local function getPlacedBlocksInPoints(s, e)
	local list, blocks = {}, bedwars.BlockController:getStore()
	for x = (e.X > s.X and s.X or e.X), (e.X > s.X and e.X or s.X) do
		for y = (e.Y > s.Y and s.Y or e.Y), (e.Y > s.Y and e.Y or s.Y) do
			for z = (e.Z > s.Z and s.Z or e.Z), (e.Z > s.Z and e.Z or s.Z) do
				local vec = Vector3.new(x, y, z)
				local block = blocks:getBlockAt(vec)
				if block and block:GetAttribute('PlacedByUserId') == lplr.UserId then
					list[vec] = block
				end
			end
		end
	end
	return list
end

local function loadMaterials()
	for _, v in guidata do 
		v:Destroy() 
	end
	local suc, read = pcall(function() 
		return isfile(File.Value) and httpService:JSONDecode(readfile(File.Value)) 
	end)

	if suc and read then
		local items = {}
		for _, v in read do 
			items[v[2]] = (items[v[2]] or 0) + 1 
		end
		
		for i, v in items do
			local holder = Instance.new('Frame')
			holder.Size = UDim2.new(1, 0, 0, 32)
			holder.BackgroundTransparency = 1
			holder.Parent = Schematica.Children
			local icon = Instance.new('ImageLabel')
			icon.Size = UDim2.fromOffset(24, 24)
			icon.Position = UDim2.fromOffset(4, 4)
			icon.BackgroundTransparency = 1
			icon.Image = bedwars.getIcon({itemType = i}, true)
			icon.Parent = holder
			local text = Instance.new('TextLabel')
			text.Size = UDim2.fromOffset(100, 32)
			text.Position = UDim2.fromOffset(32, 0)
			text.BackgroundTransparency = 1
			text.Text = (bedwars.ItemMeta[i] and bedwars.ItemMeta[i].displayName or i)..': '..v
			text.TextXAlignment = Enum.TextXAlignment.Left
			text.TextColor3 = uipallet.Text
			text.TextSize = 14
			text.FontFace = uipallet.Font
			text.Parent = holder
			table.insert(guidata, holder)
		end
		table.clear(read)
		table.clear(items)
	end
end

local function save()
	if point1 and point2 then
		local tab = getPlacedBlocksInPoints(point1, point2)
		local savetab = {}
		point1 = point1 * 3
		for i, v in tab do
			i = bedwars.BlockController:getBlockPosition(CFrame.lookAlong(point1, entitylib.character.RootPart.CFrame.LookVector):PointToObjectSpace(i * 3)) * 3
			table.insert(savetab, {
				{
					x = i.X, 
					y = i.Y, 
					z = i.Z
				}, 
				v.Name
			})
		end
		point1, point2 = nil, nil
		writefile(File.Value, httpService:JSONEncode(savetab))
		notif('Schematica', 'Saved '..getTableSize(tab)..' blocks', 5)
		loadMaterials()
		table.clear(tab)
		table.clear(savetab)
	else
		local mouseinfo = bedwars.BlockBreaker.clientManager:getBlockSelector():getMouseInfo(0)
		if mouseinfo and mouseinfo.target then
			if point1 then
				point2 = mouseinfo.target.blockRef.blockPosition
				notif('Schematica', 'Selected position 2, toggle again near position 1 to save it', 3)
			else
				point1 = mouseinfo.target.blockRef.blockPosition
				notif('Schematica', 'Selected position 1', 3)
			end
		end
	end
end

local function load(read)
	local mouseinfo = bedwars.BlockBreaker.clientManager:getBlockSelector():getMouseInfo(0)
	if mouseinfo and mouseinfo.target then
		local position = CFrame.new(mouseinfo.placementPosition * 3) * CFrame.Angles(0, math.rad(math.round(math.deg(math.atan2(-entitylib.character.RootPart.CFrame.LookVector.X, -entitylib.character.RootPart.CFrame.LookVector.Z)) / 45) * 45), 0)

		for _, v in read do
			local blockpos = bedwars.BlockController:getBlockPosition((position * CFrame.new(v[1].x, v[1].y, v[1].z)).p) * 3
			if parts[blockpos] then continue end
			local handler = bedwars.BlockController:getHandlerRegistry():getHandler(v[2]:find('wool') and getWool() or v[2])
			if handler then
				local part = handler:place(blockpos / 3, 0)
				part.Transparency = Transparency.Value
				part.CanCollide = false
				part.Anchored = true
				part.Parent = workspace
				parts[blockpos] = part
			end
		end
		table.clear(read)

		repeat
			if entitylib.isAlive then
				local localPosition = entitylib.character.RootPart.Position
				for i, v in parts do
					if (i - localPosition).Magnitude < 60 and checkAdjacent(i) then
						if not Schematica.Enabled then break end
						if not getItem(v.Name) then continue end
						bedwars.placeBlock(i, v.Name, false)
						task.delay(0.1, function()
							local block = getPlacedBlock(i)
							if block then
								v:Destroy()
								parts[i] = nil
							end
						end)
					end
				end
			end
			task.wait()
		until getTableSize(parts) <= 0

		if getTableSize(parts) <= 0 and Schematica.Enabled then
			notif('Schematica', 'Finished building', 5)
			Schematica:Toggle()
		end
	end
end

Schematica = vape.Categories.World:CreateModule({
	Name = 'Schematica',
	Function = function(callback)
		if callback then
			if not File.Value:find('.json') then
				notif('Schematica', 'Invalid file', 3)
				Schematica:Toggle()
				return
			end

			if Mode.Value == 'Save' then
				save()
				Schematica:Toggle()
			else
				local suc, read = pcall(function() 
					return isfile(File.Value) and httpService:JSONDecode(readfile(File.Value)) 
				end)

				if suc and read then
					load(read)
				else
					notif('Schematica', 'Missing / corrupted file', 3)
					Schematica:Toggle()
				end
			end
		else
			for _, v in parts do 
				v:Destroy() 
			end
			table.clear(parts)
		end
	end,
	Tooltip = 'Save and load placements of buildings'
})
File = Schematica:CreateTextBox({
	Name = 'File',
	Function = function()
		loadMaterials()
		point1, point2 = nil, nil
	end
})
Mode = Schematica:CreateDropdown({
	Name = 'Mode',
	List = {'Load', 'Save'}
})
Transparency = Schematica:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.7,
	Decimal = 10,
	Function = function(val)
		for _, v in parts do 
			v.Transparency = val 
		end
	end
})