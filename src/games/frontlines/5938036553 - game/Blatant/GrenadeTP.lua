local GrenadeTP
local Range

GrenadeTP = vape.Categories.Blatant:CreateModule({
	Name = 'GrenadeTP',
	Function = function(callback)
		if callback then
			repeat
				for _, v in frontlines.Throwables do
					if v.model and v.network_ownership then
						local ent = entitylib.EntityPosition({
							Range = Range.Value,
							Part = 'RootPart',
							Origin = v.model.PrimaryPart.Position,
							Players = true
						})

						if ent then
							local id
							for i, hash in frontlines.Main.globals.soldier_hitbox_hash do
								if i.Weld.Part0 == v.RootPart then
									id = hash
									break
								end
							end

							if id then
								v.model:PivotTo(ent.RootPart.Root_M.Spine1_M.WorldCFrame)
							end
						end
					end
				end
				task.wait(0.016)
			until not GrenadeTP.Enabled
		end
	end,
	Tooltip = 'Teleports throwables near enemy players'
})
Range = GrenadeTP:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 1000,
	Default = 1000
})