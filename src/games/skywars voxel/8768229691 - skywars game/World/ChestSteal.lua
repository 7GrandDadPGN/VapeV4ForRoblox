local ChestSteal
local Range
local Open
local Delay = {}

ChestSteal = vape.Categories.World:CreateModule({
	Name = 'ChestSteal',
	Function = function(callback)
		if callback then
			local chests = collection('block:chest', ChestSteal)
			ChestSteal:Clean(skywars.Remotes[remotes['ChestController:onStart']]:connect(function(self, items)
				if Delay[self] then return end

				for _, item in items do
					skywars.Remotes[remotes.updateChest]:fire(self, item.Type, -item.Quantity)
				end

				skywars.Remotes[remotes.closeChest]:fire(self)
				Delay[self] = true
			end))

			repeat
				if entitylib.isAlive and not Open.Enabled then
					local localPosition = entitylib.character.RootPart.Position
					for i, v in chests do
						if v.PrimaryPart and (localPosition - v.PrimaryPart.Position).Magnitude <= Range.Value and not Delay[v] then
							skywars.Remotes[remotes.openChest]:fire(v)
						end
					end
				end

				task.wait(0.1)
			until not ChestSteal.Enabled
		end
	end,
	Tooltip = 'Grabs items from near chests.'
})
Range = ChestSteal:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 10,
	Default = 10,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Open = ChestSteal:CreateToggle({Name = 'GUI Check'})