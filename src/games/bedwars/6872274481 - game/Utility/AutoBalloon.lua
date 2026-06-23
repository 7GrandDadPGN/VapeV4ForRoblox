local AutoBalloon

AutoBalloon = vape.Categories.Utility:CreateModule({
	Name = 'AutoBalloon',
	Function = function(callback)
		if callback then
			repeat task.wait() until store.matchState ~= 0 or (not AutoBalloon.Enabled)
			if not AutoBalloon.Enabled then return end

			local lowestpoint = math.huge
			for _, v in store.blocks do
				local point = (v.Position.Y - (v.Size.Y / 2)) - 50
				if point < lowestpoint then 
					lowestpoint = point 
				end
			end

			repeat
				if entitylib.isAlive then
					if entitylib.character.RootPart.Position.Y < lowestpoint and (lplr.Character:GetAttribute('InflatedBalloons') or 0) < 3 then
						local balloon = getItem('balloon')
						if balloon then
							for _ = 1, 3 do 
								bedwars.BalloonController:inflateBalloon() 
							end
						end
						task.wait(0.1)
					end
				end
				task.wait(0.1)
			until not AutoBalloon.Enabled
		end
	end,
	Tooltip = 'Inflates when you fall into the void'
})