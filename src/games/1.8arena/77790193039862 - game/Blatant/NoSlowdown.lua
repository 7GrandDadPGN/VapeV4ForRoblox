local NoSlowdown
local old

NoSlowdown = vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			old = debug.getupvalue(arena.MoveFunction, 17)
			debug.setupvalue(arena.MoveFunction, 17, debug.getupvalue(arena.MoveFunction, 19))
		else
			if old then
				debug.setupvalue(arena.MoveFunction, 17, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Prevent you from slowing down when using items.'
})