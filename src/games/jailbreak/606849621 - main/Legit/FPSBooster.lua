local FPSBooster
local destructibles = {}
local old

local function addInstance(obj)
	local found = obj:FindFirstChild('DestructibleInstance')
	if found and found.Value then
		destructibles[obj] = found.Value
	end
end

FPSBooster = vape.Legit:CreateModule({
	Name = 'FPSBooster',
	Function = function(callback)
		if callback then
			old = debug.getupvalue(jb.GunController.Setup, 2)
			debug.setupvalue(jb.GunController.Setup, 2, {
				GetTagged = function()
					local self = debug.getstack(2, 1)
					if type(self) == 'table' and self.IgnoreList then
						for _, obj in destructibles do
							table.insert(self.IgnoreList, obj)
						end
					end

					return {}
				end
			})

			for _, obj in collectionService:GetTagged('DestructibleSpawn') do
				addInstance(obj)
			end

			FPSBooster:Clean(collectionService:GetInstanceAddedSignal('DestructibleSpawn'):Connect(addInstance))
			FPSBooster:Clean(collectionService:GetInstanceRemovedSignal('DestructibleSpawn'):Connect(function(obj)
				destructibles[obj] = nil
			end))
		else
			if old then
				debug.setupvalue(jb.GunController.Setup, 2, old)
				old = nil
			end

			table.clear(destructibles)
		end
	end,
	Tooltip = 'Optimize certain parts of the game to gain more FPS'
})