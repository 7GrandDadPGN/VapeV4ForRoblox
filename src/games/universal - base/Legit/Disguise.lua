local Disguise
local Mode
local IDBox
local cloned = {}

local function itemAdded(obj, manual)
	if (obj:IsA('Accessory') or obj:IsA('ShirtGraphic') or obj:IsA('Shirt') or obj:IsA('Pants') or obj:IsA('BodyColors') or manual) and not cloned[obj] then
		obj:ClearAllChildren()
		task.defer(obj.Destroy, obj)
	end
end

local function localAdded(char)
	table.clear(cloned)
	if Mode.Value == 'Character' then
		local success, description = pcall(function()
			return playersService:GetHumanoidDescriptionFromUserId(IDBox.Value == '' and 239702688 or tonumber(IDBox.Value))
		end)

		if success and Disguise.Enabled then
			char.Character.Archivable = true
			local clone = char.Character:Clone()
			clone.Parent = game

			local original = char.Humanoid:WaitForChild('HumanoidDescription', 2) or {
				HeightScale = 1,
				SetEmotes = function() end,
				SetEquippedEmotes = function() end
			}

			original.JumpAnimation = description.JumpAnimation
			description.HeightScale = original.HeightScale
			clone:FindFirstChildWhichIsA('Humanoid'):ApplyDescriptionResetAsync(description)

			Disguise:Clean(char.Character.ChildAdded:Connect(itemAdded))
			for _, obj in char.Character:GetChildren() do
				itemAdded(obj)
			end

			for _, obj in clone:GetChildren() do
				cloned[obj] = true
				if obj:IsA('Accessory') then
					for _, objd in obj:GetDescendants() do
						if objd:IsA('Weld') and objd.Part1 then
							objd.Part1 = char.Character:FindFirstChild(objd.Part1.Name)
						elseif objd:IsA('RigidConstraint') then
							objd.Attachment1 = char.Character:FindFirstChild(objd.Attachment1.Name, true)
						end
					end

					obj.Parent = char.Character
				elseif obj:IsA('ShirtGraphic') or obj:IsA('Shirt') or obj:IsA('Pants') or obj:IsA('BodyColors') then
					obj.Parent = char.Character
				elseif obj.Name == 'Head' and char.Head:IsA('MeshPart') and (not char.Head:FindFirstChild('FaceControls')) then
					char.Head.MeshId = obj.MeshId
				end
			end

			local face = char.Character:FindFirstChild('face', true)
			local cface = clone:FindFirstChild('face', true)

			if face then
				itemAdded(face, true)
			end

			if cface then
				cface.Parent = char.Head
			end

			original:SetEmotes(description:GetEmotes())
			original:SetEquippedEmotes(description:GetEquippedEmotes())
			description:Destroy()
			clone:ClearAllChildren()
			clone:Destroy()
		elseif description then
			description:Destroy()
		end
	else
		local success, data = pcall(function()
			data = marketplaceService:GetProductInfo(IDBox.Value == '' and 43 or tonumber(IDBox.Value), Enum.InfoType.Bundle)
		end)

		if success and Disguise.Enabled then
			if data.BundleType == 'AvatarAnimations' then
				local animate = char.Character:FindFirstChild('Animate')
				if not animate then return end

				for _, item in desc.Items do
					local itemtype = item.Name:split(' ')[2]:lower()
					if itemtype ~= 'animation' then
						local suc, obj = pcall(function()
							return game:GetObjects('rbxassetid://'..item.Id)
						end)

						if suc then
							animate[itemtype]:FindFirstChildWhichIsA('Animation').AnimationId = obj[1]:FindFirstChildWhichIsA('Animation', true).AnimationId
						end
					end
				end
			else
				notif('Disguise', 'that\'s not an animation pack', 5, 'warning')
			end
		elseif type(data) == 'table' then
			table.clear(data)
		end
	end
end

Disguise = vape.Legit:CreateModule({
	Name = 'Disguise',
	Function = function(callback)
		if callback then
			Disguise:Clean(entitylib.Events.LocalAdded:Connect(localAdded))
			if entitylib.isAlive then
				task.spawn(localAdded, entitylib.character)
			end
		else
			table.clear(cloned)
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