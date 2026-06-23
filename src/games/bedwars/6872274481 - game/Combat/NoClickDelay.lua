local old

vape.Categories.Combat:CreateModule({
	Name = 'NoClickDelay',
	Function = function(callback)
		if callback then
			old = bedwars.SwordController.isClickingTooFast
			bedwars.SwordController.isClickingTooFast = function(self)
				self.lastSwing = os.clock()
				return false
			end
		else
			bedwars.SwordController.isClickingTooFast = old
		end
	end,
	Tooltip = 'Remove the CPS cap'
})