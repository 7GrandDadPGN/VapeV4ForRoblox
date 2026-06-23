local PickupRange
local Range
local Network
local Lower

PickupRange = vape.Categories.Utility:CreateModule({
	Name = 'PickupRange',
	Function = function(callback)
		if callback then
			local items = collection('ItemDrop', PickupRange)
			repeat
				if entitylib.isAlive then
					local localPosition = entitylib.character.RootPart.Position
					for _, v in items do
						if tick() - (v:GetAttribute('ClientDropTime') or 0) < 2 then continue end
						if isnetworkowner(v) and Network.Enabled and entitylib.character.Humanoid.Health > 0 then 
							v.CFrame = CFrame.new(localPosition - Vector3.new(0, 3, 0)) 
						end
						
						if (localPosition - v.Position).Magnitude <= Range.Value then
							if Lower.Enabled and (localPosition.Y - v.Position.Y) < (entitylib.character.HipHeight - 1) then continue end
							task.spawn(function()
								bedwars.Client:Get(remotes.PickupItem):CallServerAsync({
									itemDrop = v
								}):andThen(function(suc)
									if suc and bedwars.SoundList then
										bedwars.SoundManager:playSound(bedwars.SoundList.PICKUP_ITEM_DROP)
										local sound = bedwars.ItemMeta[v.Name].pickUpOverlaySound
										if sound then
											bedwars.SoundManager:playSound(sound, {
												position = v.Position,
												volumeMultiplier = 0.9
											})
										end
									end
								end)
							end)
						end
					end
				end
				task.wait(0.1)
			until not PickupRange.Enabled
		end
	end,
	Tooltip = 'Picks up items from a farther distance'
})
Range = PickupRange:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 10,
	Default = 10,
	Suffix = function(val) 
		return val == 1 and 'stud' or 'studs' 
	end
})
Network = PickupRange:CreateToggle({
	Name = 'Network TP',
	Default = true
})
Lower = PickupRange:CreateToggle({Name = 'Feet Check'})