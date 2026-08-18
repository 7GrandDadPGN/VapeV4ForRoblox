local connections = {}

vape.Categories.World:CreateModule({
	Name = 'Anti-AFK',
	Function = function(callback)
		if callback then
			for _, connection in getconnections(lplr.Idled) do
				table.insert(connections, connection)
				connection:Disable()
			end
		else
			for _, connection in connections do
				connection:Enable()
			end
			table.clear(connections)
		end
	end,
	Tooltip = 'Lets you stay ingame without getting kicked'
})