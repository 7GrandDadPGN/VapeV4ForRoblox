local AutoHotbar
local SortList = {Police = {}, Prisoner = {}}

local function DoSorting()
	local collected = {}
	for _, item in InvTracker.Inventories[lplr] do
		table.insert(collected, {
			Tool = item,
			Slot = item:GetAttribute('DisplayOrder') or 0
		})
	end

	local list = SortList[lplr.Team == teams.Police and 'Police' or 'Prisoner']
	table.sort(collected, function(a, b)
		return (list[a.Tool.name] or 15 + a.Slot) < (list[b.Tool.name] or 15 + b.Slot)
	end)

	for index, item in collected do
		item.Tool:SetAttribute('DisplayOrder', index)
		table.clear(item)
	end

	table.clear(collected)
end

AutoHotbar = vape.Categories.Inventory:CreateModule({
	Name = 'AutoHotbar',
	Function = function(callback)
		if callback then
			AutoHotbar:Clean(vapeEvents.ItemAdded.Event:Connect(DoSorting))
			task.spawn(DoSorting)
		end
	end,
	Tooltip = 'Automatically sort hotbar entries'
})

for _, team in {'Prisoner', 'Police'} do
	AutoHotbar:CreateTextList({
		Name = team..' Pickups',
		Default = team == 'Prisoner' and {'1/AK47', '2/Shotgun', '3/Pistol'} or {'1/AK47', '2/Shotgun', '3/Pistol', '4/Taser', '5/RoadSpike'},
		Placeholder = 'priority/item',
		Function = function(list)
			table.clear(SortList[team])

			for _, entry in list do
				local data = entry:split('/')
				local priority = tonumber(data[1]) or 999
				SortList[team][data[2] or ''] = priority
			end
		end
	})
end