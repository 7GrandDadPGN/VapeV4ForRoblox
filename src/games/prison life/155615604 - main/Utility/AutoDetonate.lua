local AutoDetonate
local SafeCheck
local localc4
local ticks = 0
local rayParams = RaycastParams.new()
rayParams.CollisionGroup = 'ClientBullet'
rayParams.FilterType = Enum.RaycastFilterType.Exclude

AutoDetonate = vape.Categories.Utility:CreateModule({
	Name = 'AutoDetonate',
	Function = function(callback)
		if callback then
			AutoDetonate:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(function(c4)
				if c4:GetAttribute('UserId') == lplr.UserId then
					localc4 = c4
				end
			end))

			for _, c4 in collectionService:GetTagged('C4') do
				if c4:GetAttribute('UserId') == lplr.UserId then
					localc4 = c4
				end
			end

			repeat
				local backpack = lplr:FindFirstChildWhichIsA('Backpack')

				if backpack and localc4 then
					local tool = backpack:FindFirstChild('C4 Explosive')

					if tool then
						local entity = entitylib.EntityPosition({
							Players = true,
							Part = 'RootPart',
							Range = 25,
							Origin = localc4.Position
						})

						if entity then
							rayParams.FilterDescendantsInstances = {entity.Character, lplr.Character, localc4}

							local rootdiff = (entitylib.character.RootPart.Position - localc4.Position)
							local ray = workspace:Raycast(localc4.Position, (entity.RootPart.Position - localc4.Position), rayParams)
							if SafeCheck.Enabled and not ray then
								ray = not (workspace:Raycast(localc4.Position, rootdiff, rayParams) or rootdiff.Magnitude > 40)
							end

							if not ray then
								ticks += 1
								if ticks > 3 then
									local lastEquip = lplr.Character:FindFirstChildWhichIsA('Tool')
									entitylib.character.Humanoid:EquipTool(tool)

									task.spawn(function()
										replicatedStorage.Remotes.C4.ActivateC4:InvokeServer()
									end)

									if lastEquip then
										entitylib.character.Humanoid:EquipTool(lastEquip)
									else
										entitylib.character.Humanoid:UnequipTools()
									end
								end

								task.wait(0.05)
								continue
							end
						end
					end
				end

				ticks = 0
				task.wait(0.05)
			until not AutoDetonate.Enabled
		end
	end,
	Tooltip = 'Automatically detonate when enemies are nearby.'
})
SafeCheck = AutoDetonate:CreateToggle({
	Name = 'Safety Check'
})