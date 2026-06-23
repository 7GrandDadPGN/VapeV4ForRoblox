local old

vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		local func = debug.getproto(bd.MovementController.KnitStart, 7)

		if callback then
			old = debug.getconstants(func)
			for i, v in old do
				if type(v) == 'string' and (v:find('Client') or v == 'IsChargingBow') and v ~= 'ClientSneaking' then
					debug.setconstant(func, i, 'IsSpectating')
				end
			end
		else
			for i, v in old do
				debug.setconstant(func, i, v)
			end
			table.clear(old)
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})