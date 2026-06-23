local Scaffold
local Expand
local Tower
local Downwards
local Diagonal
local LimitItem
local Mouse
local adjacent, lastpos, label = {}, Vector3.zero

for x = -3, 3, 3 do
	for y = -3, 3, 3 do
		for z = -3, 3, 3 do
			local vec = Vector3.new(x, y, z)
			if vec ~= Vector3.zero then
				table.insert(adjacent, vec)
			end
		end
	end
end

local function nearCorner(poscheck, pos)
	local startpos = poscheck - Vector3.new(3, 3, 3)
	local endpos = poscheck + Vector3.new(3, 3, 3)
	local check = poscheck + (pos - poscheck).Unit * 100
	return Vector3.new(math.clamp(check.X, startpos.X, endpos.X), math.clamp(check.Y, startpos.Y, endpos.Y), math.clamp(check.Z, startpos.Z, endpos.Z))
end

local function blockProximity(pos)
	local mag, returned = 60
	local tab = getBlocksInPoints(bedwars.BlockController:getBlockPosition(pos - Vector3.new(21, 21, 21)), bedwars.BlockController:getBlockPosition(pos + Vector3.new(21, 21, 21)))
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
		if getPlacedBlock(pos + v) then
			return true
		end
	end
	return false
end

local function getScaffoldBlock()
	if store.hand.toolType == 'block' then
		return store.hand.tool.Name, store.hand.amount
	elseif (not LimitItem.Enabled) then
		local wool, amount = getWool()
		if wool then
			return wool, amount
		else
			for _, item in store.inventory.inventory.items do
				if bedwars.ItemMeta[item.itemType].block then
					return item.itemType, item.amount
				end
			end
		end
	end

	return nil, 0
end

Scaffold = vape.Categories.Utility:CreateModule({
	Name = 'Scaffold',
	Function = function(callback)
		if label then
			label.Visible = callback
		end

		if callback then
			repeat
				if entitylib.isAlive then
					local wool, amount = getScaffoldBlock()

					if Mouse.Enabled then
						if not inputService:IsMouseButtonPressed(0) then
							wool = nil
						end
					end

					if label then
						amount = amount or 0
						label.Text = amount..' <font color="rgb(170, 170, 170)">(Scaffold)</font>'
						label.TextColor3 = Color3.fromHSV((amount / 128) / 2.8, 0.86, 1)
					end

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

							local block, blockpos = getPlacedBlock(currentpos)
							if not block then
								blockpos = checkAdjacent(blockpos * 3) and blockpos * 3 or blockProximity(currentpos)
								if blockpos then
									task.spawn(bedwars.placeBlock, blockpos, wool, false)
								end
							end
							lastpos = currentpos
						end
					end
				end

				task.wait(0.03)
			until not Scaffold.Enabled
		else
			Label = nil
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
Mouse = Scaffold:CreateToggle({Name = 'Require mouse down'})
Count = Scaffold:CreateToggle({
	Name = 'Block Count',
	Function = function(callback)
		if callback then
			label = Instance.new('TextLabel')
			label.Size = UDim2.fromOffset(100, 20)
			label.Position = UDim2.new(0.5, 6, 0.5, 60)
			label.BackgroundTransparency = 1
			label.AnchorPoint = Vector2.new(0.5, 0)
			label.Text = '0'
			label.TextColor3 = Color3.new(0, 1, 0)
			label.TextSize = 18
			label.RichText = true
			label.Font = Enum.Font.Arial
			label.Visible = Scaffold.Enabled
			label.Parent = vape.gui
		else
			label:Destroy()
			label = nil
		end
	end
})