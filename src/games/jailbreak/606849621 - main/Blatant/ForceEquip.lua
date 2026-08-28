local ForceEquip
local old

ForceEquip = vape.Categories.Blatant:CreateModule({
	Name = 'ForceEquip',
	Function = function(callback)
		if callback then
			for _, condition in jb.InventoryItemSystem._equipConditions do
				if debug.getconstants(condition)[1] == 'IsCrawling' then
					debug.setconstant(condition, 1, '_IsCrawling')
					old = condition
					break
				end
			end
		else
			if old then
				debug.setconstant(old, 1, 'IsCrawling')
				old = nil
			end
		end
	end,
	Tooltip = 'Allow you to equip while crouching'
})