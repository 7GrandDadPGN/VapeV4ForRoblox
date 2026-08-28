local AutoArrest
local Range
local AutoEquip
local cooldown = 0

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
			repeat
				local cuffs = InvTracker.Inventories[lplr].Handcuffs

				if entitylib.isAlive and lplr.Team == teams.Police and cuffs then
					local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
					local target

					local entities = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = Range.Value,
						Origin = serverPos and serverPos.Value or nil
					})

					for _, entity in entities do
						if entity.Player and isIllegal(entity) then
							if not entity.Character:GetAttribute('InVehicle') and not entity.Character:GetAttribute('HasHandcuffs') and not target and cooldown < os.clock() then
								target = entity.Player.Name
							end
						end
					end

					if target then
						local lastEquipped = jb.ItemSystemController:GetLocalEquipped()
						if AutoEquip.Enabled and not (lastEquipped and lastEquipped.__ClassName == 'Handcuffs') then
							equipTool(cuffs)
						end

						local equipped = jb.ItemSystemController:GetLocalEquipped()
						if equipped and equipped.__ClassName == 'Handcuffs' then
							if target then
								jb:FireServer('Arrest', target)
								cooldown = os.clock() + 0.5
							end
						end

						if AutoEquip.Enabled and lastEquipped ~= equipped then
							equipTool(lastEquipped and lastEquipped.inventoryItemValue or cuffs)
						end
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