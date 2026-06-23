local ChestSteal
local Range
local Open
local Skywars
local Delays = {}

local function lootChest(chest)
	chest = chest and chest.Value or nil
	local chestitems = chest and chest:GetChildren() or {}
	if #chestitems > 1 and (Delays[chest] or 0) < tick() then
		Delays[chest] = tick() + 0.2
		bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(chest)

		for _, v in chestitems do
			if v:IsA('Accessory') then
				task.spawn(function()
					pcall(function()
						bedwars.Client:GetNamespace('Inventory'):Get('ChestGetItem'):CallServer(chest, v)
					end)
				end)
			end
		end

		bedwars.Client:GetNamespace('Inventory'):Get('SetObservedChest'):SendToServer(nil)
	end
end

ChestSteal = vape.Categories.World:CreateModule({
	Name = 'ChestSteal',
	Function = function(callback)
		if callback then
			local chests = collection('chest', ChestSteal)
			repeat task.wait() until store.queueType ~= 'bedwars_test'
			if (not Skywars.Enabled) or store.queueType:find('skywars') then
				repeat
					if entitylib.isAlive and store.matchState ~= 2 then
						if Open.Enabled then
							if bedwars.AppController:isAppOpen('ChestApp') then
								lootChest(lplr.Character:FindFirstChild('ObservedChestFolder'))
							end
						else
							local localPosition = entitylib.character.RootPart.Position
							for _, v in chests do
								if (localPosition - v.Position).Magnitude <= Range.Value then
									lootChest(v:FindFirstChild('ChestFolderValue'))
								end
							end
						end
					end
					task.wait(0.1)
				until not ChestSteal.Enabled
			end
		end
	end,
	Tooltip = 'Grabs items from near chests.'
})
Range = ChestSteal:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 18,
	Default = 18,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
Open = ChestSteal:CreateToggle({Name = 'GUI Check'})
Skywars = ChestSteal:CreateToggle({
	Name = 'Only Skywars',
	Function = function()
		if ChestSteal.Enabled then
			ChestSteal:Toggle()
			ChestSteal:Toggle()
		end
	end,
	Default = true
})