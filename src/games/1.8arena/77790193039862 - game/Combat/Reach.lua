local Reach
local Value
local old

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
            old = debug.getupvalue(oldhit or arena.Client.startHit, 4)
            debug.setupvalue(oldhit or arena.Client.startHit, 4, old + Value.Value)
		else
            if old then
                debug.setupvalue(oldhit or arena.Client.startHit, 4, old)
                old = nil
            end
		end
	end,
	Tooltip = 'Extends attack reach'
})
Value = Reach:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 6,
    Default = 6,
	Decimal = 10,
    Function = function(val)
		if Reach.Enabled then
			debug.setupvalue(oldhit or arena.Client.startHit, 4, old + val)
		end
	end,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})