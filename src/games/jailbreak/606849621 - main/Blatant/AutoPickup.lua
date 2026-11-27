local AutoPickup
local Cash, CashRange
local Item, ItemRange
local NetworkOwner
local pickups = {}

local function addPickup(pickup)
	local isCash = pickup:HasTag('CashDrop')
	if isCash and not pickup.PrimaryPart then
		pickup:GetPropertyChangedSignal('PrimaryPart'):Wait()

		if not AutoPickup.Enabled then
			return
		end
	end

	table.insert(pickups, {
		isCash and pickup.PrimaryPart or pickup,
		isCash
	})
end

local function removePickup(obj)
	for index, entry in pickups do
		if entry[1] == obj then
			table.remove(pickups, index)
			break
		end
	end
end

AutoPickup = vape.Categories.Blatant:CreateModule({
	Name = 'AutoPickup',
	Function = function(callback)
		if callback then
			if Item.Enabled then
				AutoPickup:Clean(collectionService:GetInstanceAddedSignal('ItemDrop'):Connect(addPickup))
				AutoPickup:Clean(collectionService:GetInstanceRemovedSignal('ItemDrop'):Connect(removePickup))

				for _, obj in collectionService:GetTagged('ItemDrop') do
					task.spawn(addPickup, obj)
				end
			end

			if Cash.Enabled then
				AutoPickup:Clean(collectionService:GetInstanceAddedSignal('CashDrop'):Connect(addPickup))
				AutoPickup:Clean(collectionService:GetInstanceRemovedSignal('CashDrop'):Connect(removePickup))

				for _, obj in collectionService:GetTagged('CashDrop') do
					task.spawn(addPickup, obj)
				end
			end

			repeat
				if entitylib.isAlive then
					local localPos = entitylib.character.RootPart.Position

					for _, entry in pickups do
						if NetworkOwner.Enabled and isnetworkowner(entry[1]) then
							entry[1].CFrame = CFrame.new(localPos)
						end

						if (entry[1].Position - localPos).Magnitude <= (entry[2] and CashRange or ItemRange).Value then
							if not entry[2] and InvTracker.Inventories[lplr][entry[1].Parent.Name] then
								continue
							end

							for _, circle in jb.UI.CircleAction.Specs do
								if circle.Part == entry[1] then
									task.spawn(circle.Callback, circle, true)
									break
								end
							end
						end
					end
				end

				task.wait(0.1)
			until not AutoPickup.Enabled
		else
			table.clear(pickups)
		end
	end,
	Tooltip = 'Automatically pick up items and money off of the ground.'
})
ItemRange = AutoPickup:CreateSlider({
	Name = 'Item Range',
	Min = 1,
	Max = 16,
	Default = 16,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end,
	Darker = true,
	Visible = false
})
CashRange = AutoPickup:CreateSlider({
	Name = 'Cash Range',
	Min = 1,
	Max = 30,
	Default = 30,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end,
	Darker = true,
	Visible = false
})
Item = AutoPickup:CreateToggle({
	Name = 'Item',
	Function = function(callback)
		ItemRange.Object.Visible = callback

		if AutoPickup.Enabled then
			AutoPickup:Toggle()
			AutoPickup:Toggle()
		end
	end,
	Default = true
})
Cash = AutoPickup:CreateToggle({
	Name = 'Cash',
	Function = function(callback)
		CashRange.Object.Visible = callback

		if AutoPickup.Enabled then
			AutoPickup:Toggle()
			AutoPickup:Toggle()
		end
	end,
	Default = true
})
NetworkOwner = AutoPickup:CreateToggle({
	Name = 'Network Owner',
	Tooltip = 'Teleport items to you if you have network ownership.'
})