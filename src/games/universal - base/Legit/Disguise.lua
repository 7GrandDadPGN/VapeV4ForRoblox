local Disguise
local Mode
local IDBox
local desc

local function itemAdded(v, manual)
	if (not v:GetAttribute('Disguise')) and ((v:IsA('Accessory') and (not v:GetAttribute('InvItem')) and (not v:GetAttribute('ArmorSlot'))) or v:IsA('ShirtGraphic') or v:IsA('Shirt') or v:IsA('Pants') or v:IsA('BodyColors') or manual) then
		repeat
			task.wait()
			v.Parent = game
		until v.Parent == game

		v:ClearAllChildren()
		v:Destroy()
	end
end

local function characterAdded(char)
	if Mode.Value == 'Character' then
		task.wait(0.1)
		char.Character.Archivable = true

		local clone = char.Character:Clone()
		repeat
			if pcall(function()
				desc = playersService:GetHumanoidDescriptionFromUserId(IDBox.Value == '' and 239702688 or tonumber(IDBox.Value))
			end) and desc then break end
			task.wait(1)
		until not Disguise.Enabled

		if not Disguise.Enabled then
			clone:ClearAllChildren()
			clone:Destroy()
			clone = nil
			if desc then
				desc:Destroy()
				desc = nil
			end
			return
		end

		clone.Parent = game

		local originalDesc = char.Humanoid:WaitForChild('HumanoidDescription', 2) or {
			HeightScale = 1,
			SetEmotes = function() end,
			SetEquippedEmotes = function() end
		}
		originalDesc.JumpAnimation = desc.JumpAnimation
		desc.HeightScale = originalDesc.HeightScale

		for _, v in clone:GetChildren() do
			if v:IsA('Accessory') or v:IsA('ShirtGraphic') or v:IsA('Shirt') or v:IsA('Pants') then
				v:ClearAllChildren()
				v:Destroy()
			end
		end

		clone.Humanoid:ApplyDescriptionClientServer(desc)
		for _, v in char.Character:GetChildren() do
			itemAdded(v)
		end
		Disguise:Clean(char.Character.ChildAdded:Connect(itemAdded))

		for _, v in clone:WaitForChild('Animate'):GetChildren() do
			if not char.Character:FindFirstChild('Animate') then return end
			local real = char.Character.Animate:FindFirstChild(v.Name)
			if v and real then
				local anim = v:FindFirstChildWhichIsA('Animation') or {AnimationId = ''}
				local realanim = real:FindFirstChildWhichIsA('Animation') or {AnimationId = ''}
				if realanim then
					realanim.AnimationId = anim.AnimationId
				end
			end
		end

		for _, v in clone:GetChildren() do
			v:SetAttribute('Disguise', true)
			if v:IsA('Accessory') then
				for _, v2 in v:GetDescendants() do
					if v2:IsA('Weld') and v2.Part1 then
						v2.Part1 = char.Character[v2.Part1.Name]
					end
				end
				v.Parent = char.Character
			elseif v:IsA('ShirtGraphic') or v:IsA('Shirt') or v:IsA('Pants') or v:IsA('BodyColors') then
				v.Parent = char.Character
			elseif v.Name == 'Head' and char.Head:IsA('MeshPart') and (not char.Head:FindFirstChild('FaceControls')) then
				char.Head.MeshId = v.MeshId
			end
		end

		local localface = char.Character:FindFirstChild('face', true)
		local cloneface = clone:FindFirstChild('face', true)
		if localface and cloneface then
			itemAdded(localface, true)
			cloneface.Parent = char.Head
		end
		originalDesc:SetEmotes(desc:GetEmotes())
		originalDesc:SetEquippedEmotes(desc:GetEquippedEmotes())
		clone:ClearAllChildren()
		clone:Destroy()
		clone = nil

		if desc then
			desc:Destroy()
			desc = nil
		end
	else
		local data
		repeat
			if pcall(function()
				data = marketplaceService:GetProductInfo(IDBox.Value == '' and 43 or tonumber(IDBox.Value), Enum.InfoType.Bundle)
			end) then break end
			task.wait(1)
		until not Disguise.Enabled

		if not Disguise.Enabled then
			if data then
				table.clear(data)
				data = nil
			end
			return
		end

		if data.BundleType == 'AvatarAnimations' then
			local animate = char.Character:FindFirstChild('Animate')
			if not animate then return end

			for _, v in desc.Items do
				local animtype = v.Name:split(' ')[2]:lower()
				if animtype ~= 'animation' then
					local suc, res = pcall(function()
						return game:GetObjects('rbxassetid://'..v.Id)
					end)

					if suc then
						animate[animtype]:FindFirstChildWhichIsA('Animation').AnimationId = res[1]:FindFirstChildWhichIsA('Animation', true).AnimationId
					end
				end
			end
		else
			notif('Disguise', 'that\'s not an animation pack', 5, 'warning')
		end
	end
end

Disguise = vape.Legit:CreateModule({
	Name = 'Disguise',
	Function = function(callback)
		if callback then
			Disguise:Clean(entitylib.Events.LocalAdded:Connect(characterAdded))
			if entitylib.isAlive then
				characterAdded(entitylib.character)
			end
		end
	end,
	Tooltip = 'Changes your character or animation to a specific ID (animation packs or userid\'s only)'
})
Mode = Disguise:CreateDropdown({
	Name = 'Mode',
	List = {'Character', 'Animation'},
	Function = function()
		if Disguise.Enabled then
			Disguise:Toggle()
			Disguise:Toggle()
		end
	end
})
IDBox = Disguise:CreateTextBox({
	Name = 'Disguise',
	Placeholder = 'Disguise User Id',
	Function = function()
		if Disguise.Enabled then
			Disguise:Toggle()
			Disguise:Toggle()
		end
	end
})