local AutoPickup
local Lists = {}
local Regions = {}
local pickupList = {Police = {}, Prisoner = {}}
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
overlapParams.MaxParts = 1

local function doesPlayerOwn(item)
	local items = lplr:FindFirstChild('Items')
	return items and items:FindFirstChild(item) or false
end

AutoPickup = vape.Categories.Inventory:CreateModule({
	Name = 'AutoPickup',
	Function = function(callback)
		if callback then
			Regions = collectionService:GetTagged('GunShopRegion')
			overlapParams.FilterDescendantsInstances = Regions

			AutoPickup:Clean(collectionService:GetInstanceAddedSignal('GunShopRegion'):Connect(function(obj)
				table.insert(Regions, obj)
				overlapParams.FilterDescendantsInstances = Regions
			end))

			AutoPickup:Clean(collectionService:GetInstanceRemovedSignal('GunShopRegion'):Connect(function(obj)
				local index = table.find(Regions, obj)
				if index then
					table.remove(Regions, index)
				end
			end))

			repeat
				if entitylib.isAlive then
					local parts = workspace:GetPartsInPart(entitylib.character.RootPart, overlapParams)
					if #parts > 0 then
						for _, entry in pickupList[lplr.Team == teams.Police and 'Police' or 'Prisoner'] do
							if not InvTracker.Inventories[lplr][entry] and doesPlayerOwn(entry) then
								jb:FireServer('EquipItem', entry, nil)
							end
						end

						task.wait(0.2)
					end
				end

				task.wait(0.05)
			until not AutoPickup.Enabled
		else
			table.clear(Regions)
		end
	end,
	Tooltip = 'Automatically grab item pickups'
})

for _, team in {'Prisoner', 'Police'} do
	AutoPickup:CreateTextList({
		Name = team..' Pickups',
		Default = team == 'Prisoner' and {'AK47', 'Shotgun', 'Pistol'} or {'AK47', 'Shotgun'},
		Placeholder = 'item',
		Function = function(list)
			table.clear(pickupList[team])

			for _, entry in list do
				table.insert(pickupList[team], entry)
			end
		end
	})
end