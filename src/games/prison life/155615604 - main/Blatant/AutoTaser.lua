local AutoTaser
local Range
local VelocityCheck
local cooldown = 0

AutoTaser = vape.Categories.Blatant:CreateModule({
	Name = 'AutoTaser',
	Function = function(callback)
		if callback then
			repeat
				local backpack = lplr:FindFirstChildWhichIsA('Backpack')
				local taser = backpack and backpack:FindFirstChild('Taser')

				if taser and (taser:GetAttribute('CurrentAmmo') or 1) > 0 and cooldown < os.clock() and (arrestCooldown - os.clock()) < 3 then
					if not VelocityCheck.Enabled or entitylib.isAlive and entitylib.character.RootPart.AssemblyLinearVelocity.Magnitude < 40 then
						local entities = entitylib.AllPosition({
							Range = Range.Value,
							AttackCheck = false,
							Wallcheck = true,
							Part = 'Head',
							Origin = entitylib.isAlive and entitylib.character.Head.Position or Vector3.zero,
							Players = true
						})

						for _, ent in entities do 
							if not (ent.Character:GetAttribute('Tased') or ent.Character:GetAttribute('Arrested')) then
								cooldown = os.clock() + 2
								local equipped = lplr.Character:FindFirstChildWhichIsA('Tool')
								if equipped then 
									equipped.Parent = backpack
								end

								taser.Parent = lplr.Character
								break
							end
						end
					end
				end

				task.wait(0.05)
			until not AutoTaser.Enabled
		end
	end,
	Tooltip = 'Only works with silentaim autofire with position mode.'
})
Range = AutoTaser:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 52,
	Default = 52,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
VelocityCheck = AutoTaser:CreateToggle({
	Name = 'Velocity Check',
	Default = true
})