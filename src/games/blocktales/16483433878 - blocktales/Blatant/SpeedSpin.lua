local SpeedSpin
local Value
local old

SpeedSpin = vape.Categories.Blatant:CreateModule({
	Name = 'SpeedSpin',
	Function = function(callback)
		if callback then
			old = hookfunction(bt.Shucky.HasBadge, function(...)
				local self, badge = ...
				if badge == 'Speed Spin' then
					return Value.Value
				end

				return old(...)
			end)
		else
			if old then
				hookfunction(bt.Shucky.HasBadge, old)
				old = nil
			end
		end
	end,
	Tooltip = 'Spoof the amount of speed spin cards you possess.'
})
Value = SpeedSpin:CreateSlider({
	Name = 'Card Amount',
	Min = 0,
	Max = 10,
	Default = 4
})