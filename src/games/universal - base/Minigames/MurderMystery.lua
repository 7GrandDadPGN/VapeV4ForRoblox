local MurderMystery
local murderer, sheriff, oldtargetable, oldgetcolor

local function itemAdded(v, plr)
	if v:IsA('Tool') then
		local check = v:FindFirstChild('IsGun') and 'sheriff' or v:FindFirstChild('KnifeServer') and 'murderer' or nil
		check = check or v.Name:lower():find('knife') and 'murderer' or v.Name:lower():find('gun') and 'sheriff' or nil

		if check == 'murderer' and plr ~= murderer then
			murderer = plr
			if plr.Character then
				entitylib.refresh()
			end
		elseif check == 'sheriff' and plr ~= sheriff then
			sheriff = plr
			if plr.Character then
				entitylib.refresh()
			end
		end
	end
end

local function playerAdded(plr)
	MurderMystery:Clean(plr.DescendantAdded:Connect(function(v)
		itemAdded(v, plr)
	end))

	local pack = plr:FindFirstChildWhichIsA('Backpack')
	if pack then
		for _, v in pack:GetChildren() do
			itemAdded(v, plr)
		end
	end

	if plr.Character then
		for _, v in plr.Character:GetChildren() do
			itemAdded(v, plr)
		end
	end
end

MurderMystery = vape.Categories.Minigames:CreateModule({
	Name = 'MurderMystery',
	Function = function(callback)
		if callback then
			oldtargetable, oldgetcolor = entitylib.targetCheck, entitylib.getEntityColor

			entitylib.getEntityColor = function(ent)
				ent = ent.Player
				if not (ent and vape.Categories.Main.Options['Use team color'].Enabled) then return end
				if isFriend(ent, true) then
					return Color3.fromHSV(vape.Categories.Friends.Options['Friends color'].Hue, vape.Categories.Friends.Options['Friends color'].Sat, vape.Categories.Friends.Options['Friends color'].Value)
				end
				return murderer == ent and Color3.new(1, 0.3, 0.3) or sheriff == ent and Color3.new(0, 0.5, 1) or nil
			end

			entitylib.targetCheck = function(ent)
				if ent.Player and isFriend(ent.Player) then return false end
				if murderer == lplr then return true end
				return murderer == ent.Player or sheriff == ent.Player
			end

			for _, v in playersService:GetPlayers() do
				playerAdded(v)
			end

			MurderMystery:Clean(playersService.PlayerAdded:Connect(playerAdded))
			entitylib.refresh()
		else
			entitylib.getEntityColor = oldgetcolor
			entitylib.targetCheck = oldtargetable
			entitylib.refresh()
		end
	end,
	Tooltip = 'Automatic murder mystery teaming based on equipped roblox tools.'
})