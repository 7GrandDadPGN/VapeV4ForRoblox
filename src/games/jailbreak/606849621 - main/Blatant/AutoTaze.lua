local AutoTaze
local HandCheck

AutoTaze = vape.Categories.Blatant:CreateModule({
	Name = 'AutoTaze',
	Function = function(callback)
		if callback then
			repeat
				local item = jb.ItemSystemController:GetLocalEquipped()
				item = item and item.__ClassName == 'Taser' or nil
				if not HandCheck.Enabled or item then
					local ent = entitylib.EntityPosition({
						Players = true,
						Part = 'RootPart',
						Range = 50
					})

					if ent and isIllegal(ent) and not isArrested(ent.Player.Name) then
						if item then
							jb:FireServer('TaseReplicate', ent.Head.Position)
						end
						jb:FireServer('Tase', ent.Humanoid, ent.Head, ent.Head.Position)
						task.wait(10)
					end
				end

				task.wait(0.016)
			until not AutoTaze.Enabled
		end
	end,
	Tooltip = 'Immobilizes entities around you'
})
HandCheck = AutoTaze:CreateToggle({Name = 'Hand Check'})