local AntiNPC

AntiNPC = vape.Categories.Blatant:CreateModule({
	Name = 'AntiNPC',
	Function = function(callback)
		if callback then
			repeat
				local entities = entitylib.AllPosition({
					Part = 'RootPart',
					Range = 100,
					NPCs = true
				})

				for _, entity in entities do
					if isnetworkowner(entity.RootPart) then
						entity.RootPart.CFrame = CFrame.new()
					end
				end

				task.wait()
			until not AntiNPC.Enabled
		end
	end,
	Tooltip = 'Remove all NPC\'s you have network ownership over.'
})