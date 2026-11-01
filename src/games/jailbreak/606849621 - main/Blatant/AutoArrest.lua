local AutoArrest
local Range
local AutoEquip

local function equipTool(tool)
	local obj = jb.InventoryItemBinder:Get(tool)
	if obj then
		obj:AttemptSelect()
	end
end

AutoArrest = vape.Categories.Blatant:CreateModule({
	Name = 'AutoArrest',
	Function = function(callback)
		if callback then
			local randkey, savetime

			repeat
				local cuffs = InvTracker.Inventories[lplr].Handcuffs

				if entitylib.isAlive and lplr.Team == teams.Police and cuffs then
					local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
					local target

					local entities = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = Range.Value,
						Origin = serverPos and serverPos.Value or nil,
						Arrest = true
					})

					for _, entity in entities do
						if entity.Player and isIllegal(entity) then
							if not entity.Character:GetAttribute('InVehicle') and not target then
								target = entity.Player
							end
						end
					end

					if target then
						local doAction = savetime and (os.clock() - savetime) > 0.5
						local lastEquipped = jb.ItemSystemController:GetLocalEquipped()
						if AutoEquip.Enabled and not (lastEquipped and lastEquipped.__ClassName == 'Handcuffs') and doAction then
							equipTool(cuffs)
						end

						local equipped = jb.ItemSystemController:GetLocalEquipped()
						if equipped and equipped.__ClassName == 'Handcuffs' or not savetime then
							if savetime then
								if doAction then
									jb:FireServer('ArrestEnd', randkey)
									savetime = nil
								end
							else
								savetime = os.clock()
								randkey = math.random(1, 1073741824)
								jb:FireServer('ArrestBegin', target, randkey)
							end
						end

						if AutoEquip.Enabled and lastEquipped ~= equipped then
							equipTool(lastEquipped and lastEquipped.inventoryItemValue or cuffs)
						end
					else
						savetime = nil
					end
				end

				task.wait(0.016)
			until not AutoArrest.Enabled
		end
	end,
	Tooltip = 'Automatically uses handcuffs on nearby entities'
})
Range = AutoArrest:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 16,
	Default = 16,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoEquip = AutoArrest:CreateToggle({
	Name = 'AutoEquip',
	Tooltip = 'Automatically equip the handcuffs for performing actions (RISKY)'
})