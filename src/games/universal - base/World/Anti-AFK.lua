local connections = {}

vape.Categories.World:CreateModule({
	Name = 'Anti-AFK',
	Function = function(callback)
		for _, connection in getconnections(lplr.Idled) do
			if callback then
				connection:Disable()
			else
				connection:Enable()
			end
		end
	end,
	Tooltip = 'Lets you stay ingame without getting kicked'
})