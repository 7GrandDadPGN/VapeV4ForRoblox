local AutoTaze
local HandCheck
local cooldown = 0

AutoTaze = vape.Categories.Blatant:CreateModule({
	Name = 'AutoTaze',
	Function = function(callback)
		if callback then
			repeat
				local item = jb.ItemSystemController:GetLocalEquipped()
				item = item and item.__ClassName == 'Taser' or nil
				if not HandCheck.Enabled or item then
					local entities = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = 50
					})

					if cooldown < os.clock() then
						for _, entity in entities do
							if isIllegal(entity) and not isArrested(entity.Player.Name) then
								if item then
									jb:FireServer('TaseReplicate', entity.Head.Position)
								end

								jb:FireServer('Tase', entity.Humanoid, entity.Head, entity.Head.Position)
								cooldown = os.clock() + 10
								break
							end
						end
					end
				end

				task.wait(0.016)
			until not AutoTaze.Enabled
		end
	end,
	Tooltip = 'Immobilizes entities around you'
})
HandCheck = AutoTaze:CreateToggle({Name = 'Hand Check'})