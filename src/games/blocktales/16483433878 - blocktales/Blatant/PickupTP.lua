local PickupTP

PickupTP = vape.Categories.Blatant:CreateModule({
	Name = 'PickupTP',
	Function = function(callback)
		if callback then
			local old
			repeat
				if entitylib.isAlive then
					local success = true
					for _, v in collectionService:GetTagged('Pickup') do
						if not v:GetAttribute('Inactive') then
							if not old then
								old = entitylib.character.RootPart.CFrame
							end

							success = false
							entitylib.character.RootPart.CFrame = v.CFrame
							break
						end
					end

					if success and old then
						entitylib.character.RootPart.CFrame = old
						old = nil
					end
				else
					old = nil
				end

				task.wait(0.4)
			until not PickupTP.Enabled
		end
	end,
	Tooltip = 'Teleport to any nearby active pickups.'
})