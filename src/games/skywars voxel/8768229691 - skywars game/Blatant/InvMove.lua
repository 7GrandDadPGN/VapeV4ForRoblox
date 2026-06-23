local InvMove
local old

InvMove = vape.Categories.Blatant:CreateModule({
	Name = 'InvMove',
	Function = function(callback)
		if callback then
			old = skywars.FocusedController.enableFocus
			skywars.FocusedController.enableFocus = function(self, screen, ...)
				return old(self, true, ...)
			end
		else
			skywars.FocusedController.enableFocus = old
			old = nil
		end
	end,
	Tooltip = 'Allows you to have continuous movement in menus'
})