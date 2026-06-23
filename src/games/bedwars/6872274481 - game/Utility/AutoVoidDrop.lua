local AutoVoidDrop
local OwlCheck

AutoVoidDrop = vape.Categories.Utility:CreateModule({
	Name = 'AutoVoidDrop',
	Function = function(callback)
		if callback then
			repeat task.wait() until store.matchState ~= 0 or (not AutoVoidDrop.Enabled)
			if not AutoVoidDrop.Enabled then return end

			local lowestpoint = math.huge
			for _, v in store.blocks do
				local point = (v.Position.Y - (v.Size.Y / 2)) - 50
				if point < lowestpoint then
					lowestpoint = point
				end
			end

			repeat
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					if root.Position.Y < lowestpoint and (lplr.Character:GetAttribute('InflatedBalloons') or 0) <= 0 and not getItem('balloon') then
						if not OwlCheck.Enabled or not root:FindFirstChild('OwlLiftForce') then
							for _, item in {'iron', 'diamond', 'emerald', 'gold'} do
								item = getItem(item)
								if item then
									item = bedwars.Client:Get(remotes.DropItem):CallServer({
										item = item.tool,
										amount = item.amount
									})

									if item then
										item:SetAttribute('ClientDropTime', tick() + 100)
									end
								end
							end
						end
					end
				end

				task.wait(0.1)
			until not AutoVoidDrop.Enabled
		end
	end,
	Tooltip = 'Drops resources when you fall into the void'
})
OwlCheck = AutoVoidDrop:CreateToggle({
	Name = 'Owl check',
	Default = true,
	Tooltip = 'Refuses to drop items if being picked up by an owl'
})