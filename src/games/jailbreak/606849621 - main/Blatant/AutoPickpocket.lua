local AutoPickpocket
local Range
local cooldown = 0

local function equipTool(tool)
	local obj = jb.InventoryItemBinder:Get(tool)
	if obj then
		obj:AttemptSelect()
	end
end

AutoPickpocket = vape.Categories.Blatant:CreateModule({
	Name = 'AutoPickpocket',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive then
					local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
					local target

					local entities = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = Range.Value,
						Origin = serverPos and serverPos.Value or nil
					})

					for _, entity in entities do
						if entity.Player and entity.Player.Team ~= teams.Prisoner then
							if not (target or entity.Pickpocket) and cooldown < os.clock() then
								if entity.Player.Team == teams.Criminal and not entity.Character:GetAttribute('HasHandcuffs') then
									continue
								end

								target = entity
								break
							end
						end
					end

					if target then
						target.Pickpocket = target.Player.Team == teams.Criminal
						jb:FireServer('Pickpocket', target.Player.Name)
						cooldown = os.clock() + 0.2
					end
				end

				task.wait(0.016)
			until not AutoPickpocket.Enabled
		end
	end,
	Tooltip = 'Automatically steals from nearby entities'
})
Range = AutoPickpocket:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 16,
	Default = 16,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})