local connections = {}

vape.Categories.World:CreateModule({
	Name = 'Anti-AFK',
	Function = function(callback)
		if callback then
			for _, v in getconnections(lplr.Idled) do
				table.insert(connections, v)
				v:Disable()
			end
		else
			for _, v in connections do
				v:Enable()
			end
			table.clear(connections)
		end
	end,
	Tooltip = 'Lets you stay ingame without getting kicked'
})