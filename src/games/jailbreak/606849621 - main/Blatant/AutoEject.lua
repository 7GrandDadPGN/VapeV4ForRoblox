local AutoEject
local Range
local Hand
local cooldown = 0

AutoEject = vape.Categories.Blatant:CreateModule({
	Name = 'AutoEject',
	Function = function(callback)
		if callback then
			repeat
				local cuffs = InvTracker.Inventories[lplr].Handcuffs

				if entitylib.isAlive and lplr.Team == teams.Police and cuffs then
					local equipped = jb.ItemSystemController:GetLocalEquipped()

					if not Hand.Enabled or equipped and equipped.__ClassName == 'Handcuffs' then
						local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
						local vehicle

						local entities = entitylib.AllPosition({
							Players = true,
							Part = 'RootPart',
							Range = Range.Value,
							Origin = serverPos and serverPos.Value or nil
						})

						for _, entity in entities do
							if entity.Player and isIllegal(entity) then
								if entity.Character:GetAttribute('InVehicle') then
									if not vehicle and cooldown < os.clock() then
										vehicle = getVehicle(entity)
									end
								end
							end
						end

						if vehicle then
							jb:FireServer('Eject', vehicle)
							cooldown = os.clock() + 0.5
						end
					end
				end

				task.wait(0.016)
			until not AutoEject.Enabled
		end
	end,
	Tooltip = 'Automatically ejects on nearby vehicles'
})
Range = AutoEject:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 40,
	Default = 40,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Hand = AutoEject:CreateToggle({
	Name = 'Hand Check',
	Tooltip = 'Only eject while holding handcuffs'
})