local ProjectileAura
local Targets
local Range
local List
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Exclude
local FireDelays = {}

local function getProjectiles()
	local items = {}
	for slot, item in store.inventory do
		item = skywars.ItemMeta[item.Type]
		if item.Ranged and table.find(List.ListEnabled, item.Ranged.ProjectileType) and getItem(item.Ranged.ProjectileType) then
			table.insert(items, item)
		end
	end
	return items
end

ProjectileAura = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAura',
	Function = function(callback)
		if callback then
			repeat
				local ent = entitylib.EntityPosition({
					Part = 'RootPart',
					Range = Range.Value,
					Players = Targets.Players.Enabled,
					NPCs = Targets.NPCs.Enabled,
					Wallcheck = Targets.Walls.Enabled
				})

				if ent then
					local offsetpos = entitylib.character.RootPart.CFrame * skywars.FireOrigin
					for _, item in getProjectiles() do
						if (FireDelays[item] or 0) < tick() then
							rayCheck.FilterDescendantsInstances = {ent.Character, gameCamera}
							rayCheck.CollisionGroup = ent.RootPart.CollisionGroup
							local calc = prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, nil, rayCheck)

							if calc then
								targetinfo.Targets[ent] = tick() + 1
								FireDelays[item] = tick() + 0.5
								skywars.Remotes[remotes.updateActiveItem]:fire(item.Name)
								skywars.Remotes[remotes.chargeBow]:fire(CFrame.new(offsetpos.Position, calc).LookVector, 1)
								skywars.Remotes[remotes.updateActiveItem](store.hand.Name)
								break
							end
						end
					end
				end

				task.wait(0.1)
			until not ProjectileAura.Enabled
		end
	end,
	Tooltip = 'Shoots people around you'
})
Targets = ProjectileAura:CreateTargets({
	Players = true,
	Walls = true
})
List = ProjectileAura:CreateTextList({
	Name = 'Projectiles',
	Default = {'Arrow', 'Snowball', 'Capybara'}
})
Range = ProjectileAura:CreateSlider({
	Name = 'Range',
	Min = 1,
	Max = 50,
	Default = 50,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})