local AutoEject
local Range
local AutoEquip
local cooldown = 0

local function equipTool(tool)
	local obj = jb.InventoryItemBinder:Get(tool)
	if obj then
		obj:AttemptSelect()
	end
end

AutoEject = vape.Categories.Blatant:CreateModule({
	Name = 'AutoEject',
	Function = function(callback)
		if callback then
			repeat
				local cuffs = InvTracker.Inventories[lplr].Handcuffs

				if entitylib.isAlive and lplr.Team == teams.Police and cuffs then
					local equipped = jb.ItemSystemController:GetLocalEquipped()

					if AutoEquip.Enabled or equipped and equipped.__ClassName == 'Handcuffs' then
						local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
						local seat

						local entities = entitylib.AllPosition({
							Players = true,
							Part = 'RootPart',
							Range = Range.Value,
							Origin = serverPos and serverPos.Value or nil
						})

						for _, entity in entities do
							if entity.Player and isIllegal(entity) then
								if entity.Character:GetAttribute('InVehicle') then
									if not seat and cooldown < os.clock() then
										seat = getVehicleSeat(entity)
									end
								end
							end
						end

						if seat then
							local lastEquipped = jb.ItemSystemController:GetLocalEquipped()
							if AutoEquip.Enabled and not (lastEquipped and lastEquipped.__ClassName == 'Handcuffs') then
								equipTool(cuffs)
							end

							equipped = jb.ItemSystemController:GetLocalEquipped()
							if equipped and equipped.__ClassName == 'Handcuffs' then
								jb:FireServer('Eject', seat)
								cooldown = os.clock() + 0.5
							end

							if AutoEquip.Enabled and lastEquipped ~= equipped then
								equipTool(lastEquipped and lastEquipped.inventoryItemValue or cuffs)
							end
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
	Max = 18,
	Default = 18,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoEquip = AutoEject:CreateToggle({
	Name = 'AutoEquip',
	Tooltip = 'Automatically equip the handcuffs for performing actions (RISKY)'
})