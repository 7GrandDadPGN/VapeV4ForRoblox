local AutoHotbar
local SortList = {}

local function DoSorting()
	table.sort(pl.SwitchTable, function(a, b)
		return (SortList[a.Tool.name] or 999 + a.Slot) < (SortList[b.Tool.name] or 999 + b.Slot)
	end)

	task.spawn(pl.SwitchUpdate)
end

local function EntityAdded()
	local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	if backpack then
		AutoHotbar:Clean(backpack.ChildAdded:Connect(function(tool)
			if SortList[tool.Name] then
				task.defer(DoSorting)
			end
		end))
	end

	DoSorting()
end

AutoHotbar = vape.Categories.Inventory:CreateModule({
	Name = 'AutoHotbar',
	Function = function(callback)
		if callback then
			AutoHotbar:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
			if entitylib.isAlive then
				task.spawn(EntityAdded)
			end
		end
	end,
	Tooltip = 'Automatically sort hotbar entries'
})
AutoHotbar:CreateTextList({
	Name = 'Sort Order',
	Default = {'1/AK-47', '1/MP5', '1/M4A1', '2/Remington 870', '2/M700', '3/M9', '3/Revolver', '4/Taser'},
	Function = function(list)
		table.clear(SortList)
		for _, entry in list do
			local tab = entry:split('/')
			local ind = tonumber(tab[1])
			SortList[tab[2]] = ind or 999
		end
	end
})