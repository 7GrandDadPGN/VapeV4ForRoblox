local AutoLoadout
local Lists = {}
local Regions = {}
local PickupList = {}
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
overlapParams.MaxParts = 1

local function doesPlayerOwn(item)
	local items = lplr:FindFirstChild('Items')
	return items and items:FindFirstChild(item) or false
end

AutoLoadout = vape.Categories.Inventory:CreateModule({
	Name = 'AutoLoadout',
	Function = function(callback)
		if callback then
			Regions = collectionService:GetTagged('GunShopRegion')
			overlapParams.FilterDescendantsInstances = Regions

			AutoLoadout:Clean(collectionService:GetInstanceAddedSignal('GunShopRegion'):Connect(function(obj)
				table.insert(Regions, obj)
				overlapParams.FilterDescendantsInstances = Regions
			end))

			AutoLoadout:Clean(collectionService:GetInstanceRemovedSignal('GunShopRegion'):Connect(function(obj)
				local index = table.find(Regions, obj)
				if index then
					table.remove(Regions, index)
				end
			end))

			repeat
				if entitylib.isAlive then
					local parts = workspace:GetPartsInPart(entitylib.character.RootPart, overlapParams)
					if #parts > 0 then
						for _, entry in PickupList[lplr.Team == teams.Police and 'Police' or 'Prisoner'].ListEnabled do
							if not InvTracker.Inventories[lplr][entry] and doesPlayerOwn(entry) then
								jb:FireServer('EquipItem', entry, nil)
							end
						end

						task.wait(0.2)
					end
				end

				task.wait(0.05)
			until not AutoLoadout.Enabled
		else
			table.clear(Regions)
		end
	end,
	Tooltip = 'Automatically equip guns when visting a gun shop.'
})

for _, team in {'Prisoner', 'Police'} do
	PickupList[team] = AutoLoadout:CreateTextList({
		Name = team,
		Default = team == 'Prisoner' and {'AK47', 'Shotgun', 'Pistol'} or {'AK47', 'Shotgun'},
		Placeholder = 'item'
	})
end