local AutoBlock

AutoBlock = vape.Categories.Blatant:CreateModule({
	Name = 'AutoBlock',
	Function = function(callback)
		if callback then
			oldhit = hookfunction(arena.Client.startHit, function(...)
				if debug.getupvalue(oldhit, 6) then
					arena.Client.endBlockEvent:FireServer()
					debug.setupvalue(oldhit, 6, false)

					local results = table.pack(oldhit(...))
					arena.Client.beginBlockEvent:FireServer()
					debug.setupvalue(oldhit, 6, true)

					return unpack(results, 1, results.n)
				else
					return oldhit(...)
				end
			end)
		else
			if oldhit then
				hookfunction(arena.Client.startHit, oldhit)
				oldhit = nil
			end
		end
	end,
	Tooltip = 'Automatically unblock and reblock before hitting'
})