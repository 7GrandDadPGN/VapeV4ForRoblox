local AutoDoor

AutoDoor = vape.Categories.Blatant:CreateModule({
	Name = 'AutoDoor',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive then
					local localPos = entitylib.character.RootPart.Position

					for _, entry in (jb.DoorTable or {}) do
						if (localPos - entry.Part:GetClosestPointOnSurface(localPos)).Magnitude < 7 then
							task.spawn(entry.Fun, entitylib.character.RootPart)
						end
					end
				end

				task.wait(0.16)
			until not AutoDoor.Enabled
		end
	end,
	Tooltip = 'Increase the activation distance of nearby doors.'
})