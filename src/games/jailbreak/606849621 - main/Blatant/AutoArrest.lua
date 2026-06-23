local AutoArrest

AutoArrest = vape.Categories.Blatant:CreateModule({
	Name = 'AutoArrest',
	Function = function(callback)
		if callback then
			repeat
				local item = jb.ItemSystemController:GetLocalEquipped()
				if item and item.__ClassName == 'Handcuffs' then
					local localPosition = entitylib.character.Humanoid.HumanoidUnloadServerPosition.Value
					local plrs = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = 50
					})

					for _, ent in plrs do
						if not AutoArrest.Enabled then break end
						if ent.Player and isIllegal(ent) then
							local vehicle = ent.Humanoid.Sit and getVehicle(ent) or nil
							if vehicle then
								jb:FireServer('Eject', vehicle)
							elseif not isArrested(ent.Player.Name) and (localPosition - ent.RootPart.Position).Magnitude < 18.4 then
								jb:FireServer('Arrest', ent.Player.Name)
								task.wait(0.6)
							end
						end
					end
				end

				task.wait(0.016)
			until not AutoArrest.Enabled
		end
	end,
	Tooltip = 'Automatically uses handcuffs on nearby entities'
})